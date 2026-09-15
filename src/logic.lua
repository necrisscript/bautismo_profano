local Logic = {}
local i18n = require("src.i18n")

-- ==========================================================
-- CONFIGURACIÓN
-- ==========================================================

Logic.POTION_HEAL = 50
Logic.RUNE_DAMAGE = 35

Logic.ENEMY_POTION_CHANCE = 0.25
Logic.ENEMY_RUNE_GIVE_CHANCE = 0.15
Logic.ENEMY_RUNE_USE_CHANCE = 0.15
Logic.ENEMY_USE_POTION_CHANCE = 0.35

local RECORD_FILE = "records.lua"

-- ==========================================================
-- BATTLE MANAGER
-- ==========================================================

local BattleManager = {}
BattleManager.__index = BattleManager

function BattleManager.new(player, enemy)
    local self = setmetatable({}, BattleManager)

    self.player = player
    self.enemy = enemy
    self.turn = 0
    self.player_defending = false

    self:update_enemy_intent()

    return self
end

-- ==========================================================
-- DEFENDER
-- ==========================================================

function BattleManager:player_defend()
    self.player_defending = true
    self.turn = self.turn + 1

    return true
end

-- ==========================================================
-- ATAQUE DEL JUGADOR
-- ==========================================================

function BattleManager:player_attack()
    if not self.player or not self.enemy then
        return 0
    end

    self.player_defending = false

    local ataque =
        tonumber(self.player.ataque)
        or tonumber(self.player.attack)
        or 0

    local defensa =
        tonumber(self.enemy.defensa)
        or tonumber(self.enemy.defense)
        or 0

    local dano_base =
        ataque * (100 / (100 + defensa))

    local variacion =
        love.math.random(85, 115) / 100

    local dano =
        math.floor(dano_base * variacion)

    dano = math.max(1, dano)

    if self.enemy.intent == "defend" then
        dano = math.floor(dano * 0.50)
        dano = math.max(1, dano)
    end

    self.enemy.hp =
        math.max(0, self.enemy.hp - dano)

    self.turn = self.turn + 1

    return dano
end

-- ==========================================================
-- ATAQUE ENEMIGO
-- ==========================================================

function BattleManager:enemy_attack()
    if not self.player or not self.enemy then
        return 0
    end

    local enemy = self.enemy
    local player = self.player

    local intent = enemy.intent

    -- DEFENDER
    if intent == "defend" then
        self.turn = self.turn + 1
        self.player_defending = false
        self:update_enemy_intent()

        return 0
    end

    -- POCIÓN
    if intent == "potion" then
        local heal =
            Logic.enemy_use_potion(enemy)

        self.turn = self.turn + 1
        self.player_defending = false
        self:update_enemy_intent()

        return 0, heal
    end

    -- RUNA
    if intent == "rune" then
        local damage =
            Logic.enemy_use_rune(enemy, player)

        self.turn = self.turn + 1
        self.player_defending = false
        self:update_enemy_intent()

        return damage
    end

    -- ATAQUE NORMAL
    local ataque =
        tonumber(enemy.ataque)
        or tonumber(enemy.attack)
        or 0

    local defensa =
        tonumber(player.defensa)
        or tonumber(player.defense)
        or 0

    local dano_base =
        ataque * (100 / (100 + defensa))

    local variacion =
        love.math.random(90, 110) / 100

    local dano =
        math.floor(dano_base * variacion)

    dano = math.max(1, dano)

    -- DEFENSA DEL JUGADOR
    if self.player_defending then
        dano = math.floor(dano * 0.50)
        dano = math.max(0, dano)
    end

    player.hp =
        math.max(0, player.hp - dano)

    self.turn = self.turn + 1
    self.player_defending = false

    self:update_enemy_intent()

    return dano
end

-- ==========================================================
-- INTENCIÓN ENEMIGA
-- ==========================================================

function BattleManager:update_enemy_intent()
    local enemy = self.enemy

    if not enemy then
        return
    end

    enemy.intent = "attack"
    enemy.intent_damage = enemy.ataque or 0
    enemy.intent_heal = 0

    -- POCIÓN
    if Logic.enemy_should_use_potion(enemy) then
        enemy.intent = "potion"

        enemy.intent_heal =
            math.min(
                Logic.POTION_HEAL,
                math.max(
                    0,
                    enemy.max_hp - enemy.hp
                )
            )

        return
    end

    -- RUNA
    if (enemy.runas or 0) > 0
    and love.math.random() < Logic.ENEMY_RUNE_USE_CHANCE then

        enemy.intent = "rune"
        enemy.intent_damage = Logic.RUNE_DAMAGE

        return
    end

    -- DEFENSA
    local roll = love.math.random()

    if roll < 0.25 then
        enemy.intent = "defend"

        enemy.intent_damage =
            tonumber(enemy.defensa)
            or 0

        return
    end

    -- ATAQUE
    enemy.intent = "attack"

    enemy.intent_damage =
        tonumber(enemy.ataque)
        or 0
end

-- ==========================================================
-- CREAR ENEMIGO
-- ==========================================================

function Logic.spawn_enemy(floor, pool)
    if not pool then
        return nil
    end

    local floor_pool = pool[floor]

    if not floor_pool then
        local max_key = 1

        for k, _ in pairs(pool) do
            if type(k) == "number" and k > max_key then
                max_key = k
            end
        end

        floor_pool =
            pool[max_key]
            or pool[1]
    end

    if not floor_pool or #floor_pool == 0 then
        return nil
    end

    local data =
        floor_pool[
            love.math.random(#floor_pool)
        ]

    if not data then
        return nil
    end

    local multiplier =
        1 + (floor - 1) * 0.15

    local hp_data =
        tonumber(data.hp)
        or tonumber(data.health)
        or tonumber(data.vida)
        or 1

    local attack_data =
        tonumber(data.atk)
        or tonumber(data.attack)
        or tonumber(data.ataque)
        or 1

    local defense_data =
        tonumber(data.def)
        or tonumber(data.defense)
        or tonumber(data.defensa)
        or attack_data

    local max_hp =
        math.max(
            1,
            math.floor(hp_data * multiplier)
        )

    local ataque =
        math.max(
            1,
            math.floor(attack_data * multiplier)
        )

    local defensa =
        math.max(
            0,
            math.floor(defense_data * multiplier)
        )

    local enemy = {
        nombre =
            data.name
            or data.nombre
            or data.name_key
            or "Enemy",

        name_key =
            data.name_key,

        sprite =
            data.sprite
            or "rat",

        boss =
            data.boss == true,

        max_hp = max_hp,
        hp = max_hp,

        ataque = ataque,
        defensa = defensa,

        pociones =
            love.math.random()
            < Logic.ENEMY_POTION_CHANCE
            and 1
            or 0,

        runas =
            love.math.random()
            < Logic.ENEMY_RUNE_GIVE_CHANCE
            and 1
            or 0,

        intent = "attack",
        intent_damage = ataque,
        intent_heal = 0
    }

    return enemy
end

-- ==========================================================
-- LOOT
-- ==========================================================

function Logic.ganar_loot(player)
    if not player then
        return i18n.get("no_loot")
    end

    local chance = love.math.random()

    -- Si está muy herido, aumenta la posibilidad de poción.
    if player.hp < player.max_hp * 0.40
    and chance < 0.50 then

        player.pociones =
            (player.pociones or 0) + 1

        return
            i18n.get("loot_found")
            .. i18n.get("loot_potion")
    end

    -- Si tiene poco ataque, aumenta la posibilidad de piedra.
    if player.ataque < 65
    and chance < 0.45 then

        player.piedras =
            (player.piedras or 0) + 1

        return
            i18n.get("loot_found")
            .. i18n.get("loot_whetstone")
    end

    -- Loot normal.
    if chance < 0.35 then
        player.piedras =
            (player.piedras or 0) + 1

        return
            i18n.get("loot_found")
            .. i18n.get("loot_whetstone")

    elseif chance < 0.60 then
        player.pociones =
            (player.pociones or 0) + 1

        return
            i18n.get("loot_found")
            .. i18n.get("loot_potion")

    elseif chance < 0.75 then
        player.runas =
            (player.runas or 0) + 1

        return
            i18n.get("loot_found")
            .. i18n.get("loot_rune")
    end

    return i18n.get("no_loot")
end

-- ==========================================================
-- POCIÓN DEL JUGADOR
-- ==========================================================

function Logic.usar_pocion(player)
    if not player then
        return 0
    end

    if (player.pociones or 0) <= 0 then
        return 0
    end

    local antes = player.hp

    player.hp =
        math.min(
            player.max_hp,
            player.hp + Logic.POTION_HEAL
        )

    player.pociones =
        player.pociones - 1

    return player.hp - antes
end

-- ==========================================================
-- RUNA DEL JUGADOR
-- ==========================================================

function Logic.usar_runa(player, enemy)
    if not player or not enemy then
        return 0
    end

    if (player.runas or 0) <= 0 then
        return 0
    end

    player.runas =
        player.runas - 1

    enemy.hp =
        math.max(
            0,
            enemy.hp - Logic.RUNE_DAMAGE
        )

    return Logic.RUNE_DAMAGE
end

-- ==========================================================
-- POCIÓN ENEMIGA
-- ==========================================================

function Logic.enemy_use_potion(enemy)
    if not enemy then
        return 0
    end

    if (enemy.pociones or 0) <= 0 then
        return 0
    end

    local antes = enemy.hp

    enemy.hp =
        math.min(
            enemy.max_hp,
            enemy.hp + Logic.POTION_HEAL
        )

    enemy.pociones =
        enemy.pociones - 1

    return enemy.hp - antes
end

function Logic.enemy_should_use_potion(enemy)
    if not enemy then
        return false
    end

    if (enemy.pociones or 0) <= 0 then
        return false
    end

    if enemy.hp >= enemy.max_hp * 0.60 then
        return false
    end

    return
        love.math.random()
        < Logic.ENEMY_USE_POTION_CHANCE
end

-- ==========================================================
-- RUNA ENEMIGA
-- ==========================================================

function Logic.enemy_use_rune(enemy, player)
    if not enemy or not player then
        return 0
    end

    if (enemy.runas or 0) <= 0 then
        return 0
    end

    enemy.runas =
        enemy.runas - 1

    player.hp =
        math.max(
            0,
            player.hp - Logic.RUNE_DAMAGE
        )

    return Logic.RUNE_DAMAGE
end

-- ==========================================================
-- DESCANSO
-- ==========================================================

function Logic.aplicar_descanso(player, cantidad)
    if not player then
        return 0
    end

    cantidad = cantidad or 40

    local antes = player.hp

    player.hp =
        math.min(
            player.max_hp,
            player.hp + cantidad
        )

    return player.hp - antes
end

-- ==========================================================
-- AFILADO
-- ==========================================================

function Logic.aplicar_afilado(player)
    if not player then
        return 0
    end

    if (player.piedras or 0) <= 0 then
        return 0
    end

    player.piedras =
        player.piedras - 1

    local bonus =
        player.afilado_bonus or 10

    player.ataque =
        player.ataque + bonus

    return bonus
end

-- ==========================================================
-- RÉCORDS
-- ==========================================================

function Logic.cargar_records()
    if not love.filesystem.getInfo(RECORD_FILE) then
        return {}
    end

    local contenido =
        love.filesystem.read(RECORD_FILE)

    if not contenido or contenido == "" then
        return {}
    end

    local chunk, error_message =
        loadstring(contenido)

    if not chunk then
        print(
            "Error cargando récords: "
            .. tostring(error_message)
        )

        return {}
    end

    local ok, records =
        pcall(chunk)

    if not ok or type(records) ~= "table" then
        return {}
    end

    return records
end

local function tiempo_a_segundos(tiempo)
    if type(tiempo) ~= "string" then
        return math.huge
    end

    local minutos, segundos =
        tiempo:match("^(%d+):(%d+)$")

    if not minutos then
        return math.huge
    end

    return
        tonumber(minutos) * 60
        + tonumber(segundos)
end

local function ordenar_records(records)
    table.sort(records, function(a, b)
        local tier_a = tonumber(a.tier) or 0
        local tier_b = tonumber(b.tier) or 0

        if tier_a ~= tier_b then
            return tier_a > tier_b
        end

        local pelea_a = tonumber(a.pelea) or 0
        local pelea_b = tonumber(b.pelea) or 0

        if pelea_a ~= pelea_b then
            return pelea_a > pelea_b
        end

        return
            tiempo_a_segundos(a.tiempo)
            <
            tiempo_a_segundos(b.tiempo)
    end)
end

local function serializar(valor, nivel)
    nivel = nivel or 0

    local indent =
        string.rep("    ", nivel)

    if type(valor) == "table" then
        local result = "{\n"

        for key, value in pairs(valor) do
            local key_string

            if type(key) == "number" then
                key_string = "[" .. key .. "]"
            else
                key_string =
                    "["
                    .. string.format("%q", key)
                    .. "]"
            end

            result =
                result
                .. indent
                .. "    "
                .. key_string
                .. " = "
                .. serializar(value, nivel + 1)
                .. ",\n"
        end

        result =
            result
            .. indent
            .. "}"

        return result

    elseif type(valor) == "string" then
        return string.format("%q", valor)

    elseif type(valor) == "number" then
        return tostring(valor)

    elseif type(valor) == "boolean" then
        return tostring(valor)
    end

    return "nil"
end

function Logic.guardar_record(
    tier,
    pelea,
    victoria,
    nombre,
    tiempo
)
    local records =
        Logic.cargar_records()

    table.insert(records, {
        nombre = nombre or "Anónimo",
        tier = tonumber(tier) or 1,
        pelea = tonumber(pelea) or 1,
        victoria = victoria == true,
        tiempo = tiempo or "00:00"
    })

    ordenar_records(records)

    while #records > 10 do
        table.remove(records)
    end

    local contenido =
        "return "
        .. serializar(records)

    local ok, error_message =
        love.filesystem.write(
            RECORD_FILE,
            contenido
        )

    if not ok then
        print(
            "Error guardando récord: "
            .. tostring(error_message)
        )

        return false
    end

    return true
end

-- ==========================================================
-- EXPORTAR
-- ==========================================================

Logic.BattleManager = BattleManager

return Logic
