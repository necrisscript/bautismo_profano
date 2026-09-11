local Logic = {}
local i18n = require("src.i18n")

-- ==========================================================
-- RECURSOS ESPECIALES
-- ==========================================================

Logic.POTION_HEAL = 50
Logic.RUNE_DAMAGE = 35

Logic.ENEMY_POTION_CHANCE = 0.25
Logic.ENEMY_RUNE_CHANCE = 0.05
Logic.ENEMY_USE_POTION_CHANCE = 0.25

-- ==========================================================
-- BATTLE MANAGER
-- ==========================================================

local BattleManager = {}
BattleManager.__index = BattleManager


-- ==========================================================
-- CREAR BATALLA
-- ==========================================================

function BattleManager.new(player, enemy)

    local self = setmetatable({}, BattleManager)

    self.player = player
    self.enemy = enemy
    self.turn = 0
    self.log = {}

    self:update_enemy_intent()

    return self
end


-- ==========================================================
-- ATAQUE DEL JUGADOR
-- ==========================================================

function BattleManager:player_attack()

    if not self.enemy or not self.player then
        return 0
    end

    local enemy = self.enemy
    local player = self.player

    -- El ATQ del jugador viene directamente de sus estadísticas.
    local ataque =
        tonumber(player.ataque)
        or tonumber(player.attack)
        or 0

    -- La DEF del enemigo viene directamente de sus estadísticas.
    local defensa =
        tonumber(enemy.defensa)
        or tonumber(enemy.defense)
        or 0

    -- ======================================================
    -- DAÑO BASE
    -- ======================================================

    -- La defensa reduce el daño, pero NO convierte un ataque
    -- fuerte en 1 simplemente porque las estadísticas estén
    -- cerca.
    --
    -- Fórmula:
    --     daño = ataque * 100 / (100 + defensa)
    --
    -- Así DEF 30 reduce el daño, pero ATQ 40 sigue pegando
    -- bastante más que 1.

    local dano_base =
        ataque * (100 / (100 + defensa))

    local variacion =
        love.math.random(85, 115) / 100

    local dano_final =
        math.floor(dano_base * variacion)

    dano_final =
        math.max(1, dano_final)


    -- ======================================================
    -- ENEMIGO DEFENDIENDO
    -- ======================================================

    if enemy.intent == "defend" then

        -- Defender reduce el daño recibido a la mitad.
        dano_final =
            math.floor(dano_final * 0.50)

        dano_final =
            math.max(1, dano_final)
    end


    enemy.hp =
        math.max(
            0,
            enemy.hp - dano_final
        )

    return dano_final
end


-- ==========================================================
-- ACCIÓN DEL ENEMIGO
-- ==========================================================

function BattleManager:enemy_attack()

    if not self.enemy or not self.player then
        return 0
    end

    local enemy = self.enemy
    local player = self.player

    local intent =
        enemy.intent


    -- ======================================================
    -- DEFENDER
    -- ======================================================

    if intent == "defend" then

        self.turn =
            self.turn + 1

        self:update_enemy_intent()

        return 0
    end


    -- ======================================================
    -- POCIÓN
    -- ======================================================

    if intent == "potion" then

        local curacion =
            Logic.enemy_use_potion(enemy)

        self.turn =
            self.turn + 1

        self:update_enemy_intent()

        return 0, curacion
    end


    -- ======================================================
    -- RUNA
    -- ======================================================

    if intent == "rune" then

        local dano =
            Logic.enemy_use_rune(
                enemy,
                player
            )

        self.turn =
            self.turn + 1

        self:update_enemy_intent()

        return dano
    end


    -- ======================================================
    -- ATAQUE NORMAL
    -- ======================================================

    local ataque =
        tonumber(enemy.ataque)
        or tonumber(enemy.attack)
        or 0

    local defensa =
        tonumber(player.defensa)
        or tonumber(player.defense)
        or 0


    -- ======================================================
    -- DAÑO
    -- ======================================================

    -- Igual que con el jugador:
    -- la defensa reduce, pero no destruye el ataque.

    local dano_base =
        ataque * (100 / (100 + defensa))

    local variacion =
        love.math.random(90, 110) / 100

    local dano_final =
        math.floor(dano_base * variacion)

    dano_final =
        math.max(1, dano_final)


    player.hp =
        math.max(
            0,
            player.hp - dano_final
        )


    self.turn =
        self.turn + 1

    self:update_enemy_intent()

    return dano_final
end


-- ==========================================================
-- ACTUALIZAR INTENCIÓN DEL ENEMIGO
-- ==========================================================

function BattleManager:update_enemy_intent()

    local enemy =
        self.enemy

    if not enemy then
        return
    end


    enemy.intent =
        "attack"

    enemy.intent_damage =
        0

    enemy.intent_heal =
        0


    -- ======================================================
    -- POCIÓN
    -- ======================================================

    if Logic.enemy_should_use_potion(enemy) then

        enemy.intent =
            "potion"

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


    -- ======================================================
    -- RUNA
    -- ======================================================

    if (enemy.runas or 0) > 0
    and love.math.random() < Logic.ENEMY_RUNE_CHANCE then

        enemy.intent =
            "rune"

        enemy.intent_damage =
            Logic.RUNE_DAMAGE

        return
    end


    -- ======================================================
    -- DEFENSA / ATAQUE
    -- ======================================================

    local roll =
        love.math.random()


    if roll < 0.25 then

        -- ==================================================
        -- DEFENDER
        -- ==================================================
        --
        -- IMPORTANTE:
        -- NO ponemos 0.
        --
        -- La UI puede mostrar la DEF real del enemigo.
        --
        enemy.intent =
            "defend"

        enemy.intent_damage =
            tonumber(enemy.defensa)
            or tonumber(enemy.defense)
            or 0

    else

        -- ==================================================
        -- ATAQUE
        -- ==================================================
        --
        -- La intención muestra el ATQ REAL del enemigo.
        -- No mostramos "ataque - defensa del jugador".
        --
        enemy.intent =
            "attack"

        enemy.intent_damage =
            tonumber(enemy.ataque)
            or tonumber(enemy.attack)
            or 0
    end
end


-- ==========================================================
-- CREAR ENEMIGO
-- ==========================================================

function Logic.spawn_enemy(floor, pool)

    local floor_pool =
        pool[floor]


    if not floor_pool then

        local max_key =
            1

        for k, _ in pairs(pool) do

            if k > max_key then
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


    -- ======================================================
    -- ESCALADO
    -- ======================================================

    local multi =
        1 + (floor - 1) * 0.15


    -- ======================================================
    -- LEER ESTADÍSTICAS DEL DATA
    -- ======================================================
    --
    -- Aceptamos diferentes nombres para evitar que el juego
    -- termine usando nil/0 porque data.lua usa otro nombre.
    --

    local hp_data =
        tonumber(data.hp)
        or tonumber(data.health)
        or tonumber(data.vida)
        or 1


    local ataque_data =
        tonumber(data.atk)
        or tonumber(data.attack)
        or tonumber(data.ataque)
        or 1


    local defensa_data =
        tonumber(data.def)
        or tonumber(data.defense)
        or tonumber(data.defensa)

    -- Si el enemigo no tiene DEF definida,
    -- usamos su ATQ como defensa.
    --
    -- Esto mantiene la regla que veníamos usando:
    -- los enemigos tienen una defensa comparable a su ataque.

    if not defensa_data then
        defensa_data =
            ataque_data
    end


    local max_hp =
        math.floor(hp_data * multi)

    local ataque =
        math.floor(ataque_data * multi)

    local defensa =
        math.floor(defensa_data * multi)


    -- ======================================================
    -- CREAR ENEMIGO
    -- ======================================================

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


        max_hp =
            max_hp,

        hp =
            max_hp,


        -- ESTADÍSTICAS REALES DEL DATA
        ataque =
            ataque,

        defensa =
            defensa,


        -- ==================================================
        -- RECURSOS
        -- ==================================================

        pociones =
            love.math.random()
            < Logic.ENEMY_POTION_CHANCE
            and 1
            or 0,

        runas =
            love.math.random()
            < Logic.ENEMY_RUNE_CHANCE
            and 1
            or 0,


        -- ==================================================
        -- INTENCIÓN
        -- ==================================================

        intent =
            "attack",

        intent_damage =
            ataque,

        intent_heal =
            0
    }


    return enemy
end


-- ==========================================================
-- LOOT
-- ==========================================================

function Logic.ganar_loot(player)

    local chance =
        love.math.random()


    -- ======================================================
    -- POCIÓN POR VIDA BAJA
    -- ======================================================

    if player.hp <
        (player.max_hp * 0.40)
    and chance < 0.50 then

        player.pociones =
            (player.pociones or 0) + 1

        return i18n.get("loot_found") .. i18n.get("loot_potion")
    end


    -- ======================================================
    -- PIEDRA POR ATAQUE BAJO
    -- ======================================================

    if player.ataque < 65
    and chance < 0.45 then

        player.piedras =
            (player.piedras or 0) + 1

        return i18n.get("loot_found") .. i18n.get("loot_whetstone")
    end


    -- ======================================================
    -- LOOT NORMAL
    -- ======================================================

    if chance < 0.35 then

        player.piedras =
            (player.piedras or 0) + 1

        return i18n.get("loot_found") .. i18n.get("loot_whetstone")


    elseif chance < 0.60 then

        player.pociones =
            (player.pociones or 0) + 1

        return i18n.get("loot_found") .. i18n.get("loot_potion")


    elseif chance < 0.75 then

        player.runas =
            (player.runas or 0) + 1

        return i18n.get("loot_found") .. i18n.get("loot_rune")
    end


    -- ======================================================
    -- SIN LOOT
    -- ======================================================

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


    local antes =
        player.hp


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
-- POCIÓN DEL ENEMIGO
-- ==========================================================

function Logic.enemy_use_potion(enemy)

    if not enemy then
        return 0
    end

    if (enemy.pociones or 0) <= 0 then
        return 0
    end


    local antes =
        enemy.hp


    enemy.hp =
        math.min(
            enemy.max_hp,
            enemy.hp + Logic.POTION_HEAL
        )


    enemy.pociones =
        enemy.pociones - 1


    return enemy.hp - antes
end


-- ==========================================================
-- DECIDIR SI USA POCIÓN
-- ==========================================================

function Logic.enemy_should_use_potion(enemy)

    if not enemy then
        return false
    end

    if (enemy.pociones or 0) <= 0 then
        return false
    end


    if enemy.hp >=
        enemy.max_hp * 0.60 then

        return false
    end


    return
        love.math.random()
        < Logic.ENEMY_USE_POTION_CHANCE
end


-- ==========================================================
-- RUNA DEL ENEMIGO
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


    local dano =
        Logic.RUNE_DAMAGE


    player.hp =
        math.max(
            0,
            player.hp - dano
        )


    return dano
end


-- ==========================================================
-- DESCANSO
-- ==========================================================

function Logic.aplicar_descanso(player, cantidad)

    if not player then
        return 0
    end


    cantidad =
        cantidad or 40


    local antes =
        player.hp


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


    local bono =
        player.afilado_bonus
        or 10


    player.ataque =
        player.ataque + bono


    return bono
end


-- ==========================================================
-- EXPORTAR
-- ==========================================================

Logic.BattleManager =
    BattleManager


return Logic
