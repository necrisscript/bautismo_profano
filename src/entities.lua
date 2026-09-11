local Entities = {}

-- ==========================================================
-- ENTITY BASE
-- ==========================================================

local Entity = {}
Entity.__index = Entity

function Entity.new(nombre, hp, ataque, defensa)
    local self = setmetatable({}, Entity)

    self.nombre = nombre
    self.hp = hp
    self.max_hp = hp
    self.ataque = ataque
    self.defensa = defensa or 0

    return self
end

-- ==========================================================
-- PLAYER
-- ==========================================================

local Player = setmetatable({}, {
    __index = Entity
})

Player.__index = Player

function Player.new(nombre, clase, class_data)

    local self = setmetatable(
        Entity.new(
            nombre,
            class_data.hp,
            class_data.ataque,
            class_data.defensa
        ),
        Player
    )

    self.clase = clase

    self.pociones = 0
    self.runas = 0
    self.piedras = 0

    self.afilado_bonus =
        class_data.afilado_bonus or 10

    return self
end

-- ==========================================================
-- ENEMY
-- ==========================================================

local Enemy = setmetatable({}, {
    __index = Entity
})

Enemy.__index = Enemy

function Enemy.new(data, multiplier)

    multiplier = multiplier or 1

    local hp =
        math.floor(data.hp * multiplier)

    local ataque =
        math.floor(data.atk * multiplier)

    local defensa =
        math.floor(data.def * multiplier)

    local self = setmetatable(
        Entity.new(
            data.name_key,
            hp,
            ataque,
            defensa
        ),
        Enemy
    )

    self.sprite = data.sprite
    self.boss = data.boss or false

    self.intent = "attack"
    self.intent_damage = 0

    self.name_key = data.name_key

    return self
end

Entities.Entity = Entity
Entities.Player = Player
Entities.Enemy = Enemy

return Entities
