local i18n = require("src.i18n")




-- ==========================================================
-- LOOT LOCALIZADO
-- ==========================================================

local function mensajeLoot(loot)

    -- No hubo objeto
    if not loot or not loot.tipo then
        return i18n.get("no_loot")
    end

    -- ======================================================
    -- DETERMINAR LA CLAVE DEL OBJETO
    -- ======================================================

    local objeto_key = nil

    if loot.tipo == "pociones" then

        objeto_key = "loot_potion"

    elseif loot.tipo == "piedras" then

        objeto_key = "loot_whetstone"

    elseif loot.tipo == "runas" then

        objeto_key = "loot_rune"
    end


    -- Si el tipo no es válido, tratarlo como ausencia de loot.
    if not objeto_key then
        return i18n.get("no_loot")
    end

    -- ======================================================
    -- CONSTRUIR MENSAJE
    -- ======================================================

    local prefijo =
        i18n.get("loot_found")

    local objeto =
        i18n.get(objeto_key)


    return prefijo .. objeto
end

-- ==========================================================
-- NOMBRE LOCALIZADO DEL LOOT
-- ==========================================================

local function nombreLootLocalizado(loot)

    if not loot or not loot.tipo then
        return ""
    end


    if loot.tipo == "pociones" then
        return i18n.get("loot_potion")
    end


    if loot.tipo == "piedras" then
        return i18n.get("loot_whetstone")
    end


    if loot.tipo == "runas" then
        return i18n.get("loot_rune")
    end


    return ""
end

-- ==========================================================
-- NOMBRE LOCALIZADO DEL LOOT
-- ==========================================================

local function nombreLootLocalizado(loot)
    if not loot or not loot.tipo then
        return i18n.get("no_loot")
    end

    if loot.tipo == "pociones" then
        return i18n.get("loot_potion")
    end

    if loot.tipo == "piedras" then
        return i18n.get("loot_whetstone")
    end

    if loot.tipo == "runas" then
        return i18n.get("loot_rune")
    end

    return i18n.get("no_loot")
end


local UI = {}

local assets = {}

local LOGIC_W = 800
local LOGIC_H = 600

-- ==========================================================
-- CARGAR ASSETS
-- ==========================================================

function UI.load()

    assets.background =
        love.graphics.newImage(
            "assets/background.png"
        )

    assets.enemy_sprites = {}

    local enemy_names = {
        "archmage",
        "cultist",
        "gargoyle",
        "goblin",
        "incubus",
        "jelly",
        "kobold",
        "mimic",
        "minotaur",
        "orc",
        "rat",
        "skeleton",
        "spider",
        "succubus",
        "vampire",
        "wraith",
        "zombie"
    }

    for _, name in ipairs(enemy_names) do
        assets.enemy_sprites[name] =
            love.graphics.newImage(
                "assets/" .. name .. ".png"
            )
    end

    assets.items = {

        heart =
            love.graphics.newImage(
                "assets/heart.png"
            ),


        potion =
            love.graphics.newImage(
                "assets/potion.png"
            ),

        runes =
            love.graphics.newImage(
                "assets/runes.png"
            ),

        whetstone =
            love.graphics.newImage(
                "assets/whetstone.png"
            ),

        attack =
            love.graphics.newImage(
                "assets/attack.png"
            ),

        defend =
            love.graphics.newImage(
                "assets/defend.png"
            )
    }
end

-- ==========================================================
-- COORDENADAS
-- ==========================================================

function UI.getLogicalCoordinates(x, y)

    local windowW, windowH =
        love.graphics.getDimensions()

    return
        x / (windowW / LOGIC_W),
        y / (windowH / LOGIC_H)
end

-- ==========================================================
-- BOTÓN
-- ==========================================================

function UI.estaEnBoton(
    x, y,
    bx, by,
    bw, bh
)

    return
        x >= bx
        and x <= bx + bw
        and y >= by
        and y <= by + bh
end

local function dibujarBoton(
    x, y, w, h, texto
)

    love.graphics.setColor(
        0.03, 0.03, 0.05, 0.95
    )

    love.graphics.rectangle(
        "fill",
        x, y, w, h,
        8, 8
    )

    love.graphics.setColor(
        0.35, 0.35, 0.4, 1
    )

    love.graphics.rectangle(
        "line",
        x, y, w, h,
        8, 8
    )

    love.graphics.setColor(
        1, 1, 1, 1
    )

    love.graphics.printf(
        texto,
        x,
        y + (h - 20) / 2,
        w,
        "center"
    )
end

local function dibujarIcono(
    imagen,
    x,
    y,
    size
)

    if not imagen then
        return
    end

    local scale =
        size /
        math.max(
            imagen:getWidth(),
            imagen:getHeight()
        )

    love.graphics.draw(
        imagen,
        x,
        y,
        0,
        scale,
        scale,
        imagen:getWidth() / 2,
        imagen:getHeight() / 2
    )
end

-- ==========================================================
-- BARRA DEL JUGADOR
-- ==========================================================

local function dibujarBarraJugador(
    player,
    tier
)

    love.graphics.setColor(
        0.02, 0.02, 0.03, 0.90
    )

    love.graphics.rectangle(
        "fill",
        0, 0,
        LOGIC_W,
        38
    )

    love.graphics.setColor(
        0.25, 0.25, 0.28, 1
    )

    love.graphics.line(
        0, 38,
        LOGIC_W, 38
    )

    if player then

        love.graphics.setColor(
            0.9, 0.9, 0.9, 1
        )

        love.graphics.printf(
            i18n.get("hp")
            .. " "
            .. player.hp
            .. "/"
            .. player.max_hp,
            12, 11,
            110,
            "left"
        )

        love.graphics.printf(
            i18n.get("atk")
            .. " "
            .. player.ataque,
            125, 11,
            80,
            "left"
        )

        love.graphics.printf(
            i18n.get("def")
            .. " "
            .. player.defensa,
            210, 11,
            80,
            "left"
        )

        dibujarIcono(
            assets.items.potion,
            315, 19,
            20
        )

        love.graphics.printf(
            tostring(player.pociones or 0),
            330, 11,
            40,
            "left"
        )

        dibujarIcono(
            assets.items.runes,
            385, 19,
            20
        )

        love.graphics.printf(
            tostring(player.runas or 0),
            400, 11,
            40,
            "left"
        )

        dibujarIcono(
            assets.items.whetstone,
            455, 19,
            20
        )

        love.graphics.printf(
            tostring(player.piedras or 0),
            470, 11,
            40,
            "left"
        )

        love.graphics.printf(
            i18n.get("tier")
            .. " "
            .. tostring(tier or 1),
            680, 11,
            100,
            "right"
        )
    end

    love.graphics.setColor(
        1, 1, 1, 1
    )
end

-- ==========================================================
-- INTENCIÓN
-- ==========================================================


local function dibujarIntencion(enemy)

    if not enemy then
        return
    end

    local intent =
        enemy.intent or "attack"

    local centerX =
        LOGIC_W / 2

    local intentY =
        155

    -- ======================================================
    -- ATAQUE
    -- ======================================================

    if intent == "attack" then

        local image =
            assets.items.attack

        if image then

            local size = 24

            local scaleX =
                size / image:getWidth()

            local scaleY =
                size / image:getHeight()

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.draw(
                image,
                centerX - size / 2 - 18,
                intentY,
                0,
                scaleX,
                scaleY
            )
        end

        love.graphics.setColor(
            1,
            0.35,
            0.25,
            1
        )

        love.graphics.printf(
            tostring(
                enemy.intent_damage or 0
            ),
            centerX + 2,
            intentY + 2,
            50,
            "left"
        )

    -- ======================================================
    -- DEFENSA
    -- ======================================================

    elseif intent == "defend" then

        local image =
            assets.items.defend

        if image then

            local size = 24

            local scaleX =
                size / image:getWidth()

            local scaleY =
                size / image:getHeight()

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.draw(
                image,
                centerX - size / 2 - 18,
                intentY,
                0,
                scaleX,
                scaleY
            )
        end

        -- Solo mostramos el valor de defensa.
        -- NO mostramos cuánto ataque necesita el jugador.

        love.graphics.setColor(
            0.35,
            0.75,
            1,
            1
        )

        love.graphics.printf(
            tostring(
                enemy.defensa or 0
            ),
            centerX + 2,
            intentY + 2,
            50,
            "left"
        )

    -- ======================================================
    -- POCIÓN
    -- ======================================================

    elseif intent == "potion" then

        local image =
            assets.items.heart

        if image then

            local size = 26

            local scale =
                size /
                math.max(
                    image:getWidth(),
                    image:getHeight()
                )

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.draw(
                image,
                centerX - 13 - 20,
                intentY,
                0,
                scale,
                scale,
                image:getWidth() / 2,
                image:getHeight() / 2
            )
        end

        love.graphics.setColor(
            1,
            0.25,
            0.35,
            1
        )

        love.graphics.printf(
            "+" ..
            tostring(
                enemy.intent_heal or 50
            ),
            centerX + 2,
            intentY + 2,
            70,
            "left"
        )

    -- ======================================================
    -- RUNA
    -- ======================================================

    elseif intent == "rune" then

        local image =
            assets.items.runes

        if image then

            local size = 26

            local scale =
                size /
                math.max(
                    image:getWidth(),
                    image:getHeight()
                )

            love.graphics.setColor(
                1,
                1,
                1,
                1
            )

            love.graphics.draw(
                image,
                centerX - 13 - 20,
                intentY,
                0,
                scale,
                scale,
                image:getWidth() / 2,
                image:getHeight() / 2
            )
        end

        love.graphics.setColor(
            0.75,
            0.4,
            1,
            1
        )

        love.graphics.printf(
            tostring(
                enemy.intent_damage or 35
            ),
            centerX + 2,
            intentY + 2,
            70,
            "left"
        )

    -- ======================================================
    -- SKILL
    -- ======================================================

    elseif intent == "skill" then

        love.graphics.setColor(
            0.8,
            0.4,
            1,
            1
        )

        love.graphics.printf(
            "✦",
            centerX - 100,
            intentY,
            200,
            "center"
        )

    -- ======================================================
    -- DEBUFF
    -- ======================================================

    elseif intent == "debuff" then

        love.graphics.setColor(
            0.7,
            0.3,
            0.8,
            1
        )

        love.graphics.printf(
            "☠",
            centerX - 100,
            intentY,
            200,
            "center"
        )
    end

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )
end

local function dibujarMenu()

    love.graphics.printf(
        i18n.get("title"),
        0, 180,
        LOGIC_W,
        "center"
    )

    dibujarBoton(
        250, 320,
        300, 50,
        i18n.get("press_enter")
    )
end

-- ==========================================================
-- CLASE
-- ==========================================================

local function dibujarClase()

    love.graphics.printf(
        i18n.get("arsenal"),
        50, 100,
        700,
        "center"
    )

    dibujarBoton(
        100, 200,
        600, 50,
        i18n.get("class_1")
    )

    dibujarBoton(
        100, 260,
        600, 50,
        i18n.get("class_2")
    )

    dibujarBoton(
        100, 320,
        600, 50,
        i18n.get("class_3")
    )
end

-- ==========================================================
-- EQUIPO
-- ==========================================================

local function dibujarEquipo()

    love.graphics.printf(
        i18n.get("supplies"),
        50, 100,
        700,
        "center"
    )

    dibujarBoton(
        100, 200,
        600, 50,
        i18n.get("supply_1")
    )

    dibujarBoton(
        100, 260,
        600, 50,
        i18n.get("supply_2")
    )

    dibujarBoton(
        100, 320,
        600, 50,
        i18n.get("supply_3")
    )
end

-- ==========================================================
-- COMBATE
-- ==========================================================

local function dibujarCombate(
    player,
    enemy,
    tier
)

    dibujarBarraJugador(
        player,
        tier
    )

    local sprite

    if enemy then
        sprite =
            assets.enemy_sprites[
                enemy.sprite
            ]
    end

    if not sprite then
        sprite =
            assets.enemy_sprites.rat
    end

    if sprite then

        local targetSize = 180

        local scale =
            targetSize /
            math.max(
                sprite:getWidth(),
                sprite:getHeight()
            )

        love.graphics.setColor(
            1, 1, 1, 1
        )

        love.graphics.draw(
            sprite,
            LOGIC_W / 2,
            LOGIC_H / 2,
            0,
            scale,
            scale,
            sprite:getWidth() / 2,
            sprite:getHeight() / 2
        )
    end

    if enemy then

        local barWidth = 220
        local barHeight = 8

        local barX =
            (LOGIC_W - barWidth) / 2

        local barY = 185

        local hp_ratio =
            math.max(
                0,
                enemy.hp / enemy.max_hp
            )

        love.graphics.setColor(
            0.12, 0.02, 0.02, 1
        )

        love.graphics.rectangle(
            "fill",
            barX, barY,
            barWidth, barHeight,
            3, 3
        )

        love.graphics.setColor(
            0.75, 0.06, 0.06, 1
        )

        love.graphics.rectangle(
            "fill",
            barX, barY,
            barWidth * hp_ratio,
            barHeight,
            3, 3
        )

        love.graphics.setColor(
            0.8, 0.8, 0.8, 1
        )

        love.graphics.rectangle(
            "line",
            barX, barY,
            barWidth, barHeight,
            3, 3
        )

        love.graphics.setColor(
            1, 1, 1, 1
        )

        local enemy_name =
            i18n.get(enemy.name_key)

        love.graphics.printf(
            enemy_name,
            50, 200,
            700,
            "center"
        )

        dibujarIntencion(enemy)
    end

    dibujarBoton(
        20, 480,
        145, 60,
        i18n.get("attack")
    )

    dibujarBoton(
        175, 480,
        145, 60,
        i18n.get("defend")
    )

    dibujarBoton(
        330, 480,
        145, 60,
        i18n.get("rune")
        .. " ("
        .. (player and player.runas or 0)
        .. ")"
    )

    dibujarBoton(
        485, 480,
        145, 60,
        i18n.get("potion")
        .. " ("
        .. (player and player.pociones or 0)
        .. ")"
    )

    dibujarBoton(
        640, 480,
        140, 60,
        i18n.get("flee")
    )
end

-- ==========================================================
-- LOOT
-- ==========================================================

local function dibujarLoot(
    loot_msg,
    player,
    tier
)

    dibujarBarraJugador(
        player,
        tier
    )

    love.graphics.printf(
        i18n.get("defeated"),
        50, 150,
        700,
        "center"
    )

    love.graphics.setColor(
        1, 0.84, 0, 1
    )

    love.graphics.printf(
        loot_msg or "",
        50, 245,
        700,
        "center"
    )

    love.graphics.setColor(
        1, 1, 1, 1
    )

    dibujarBoton(
        250, 350,
        300, 60,
        i18n.get("continue")
    )
end

-- ==========================================================
-- CAMPAMENTO
-- ==========================================================

local function dibujarCampamento(
    player,
    tier,
    mensaje,
    descanso_usado
)

    dibujarBarraJugador(
        player,
        tier
    )

    love.graphics.printf(
        i18n.get("camp")
        .. tier,
        50, 80,
        700,
        "center"
    )

    if mensaje and mensaje ~= "" then

        love.graphics.setColor(
            0.3, 1, 0.5, 1
        )

        love.graphics.printf(
            mensaje,
            50, 135,
            700,
            "center"
        )

        love.graphics.setColor(
            1, 1, 1, 1
        )
    end

    local texto_descanso =
        i18n.get("camp_1")

    if descanso_usado then
        texto_descanso =
            i18n.get("already_rest")
    end

    dibujarBoton(
        100, 200,
        600, 45,
        texto_descanso
    )

    dibujarBoton(
        100, 255,
        600, 45,
        i18n.get("camp_2")
    )

    dibujarBoton(
        100, 310,
        600, 45,
        i18n.get("camp_3")
        .. (tier + 1)
    )

    dibujarBoton(
        100, 365,
        600, 45,
        i18n.get("camp_4")
    )
end

-- ==========================================================
-- FINAL
-- ==========================================================

local function dibujarFinal(texto)

    love.graphics.printf(
        texto,
        0, 200,
        LOGIC_W,
        "center"
    )

    dibujarBoton(
        250, 320,
        300, 50,
        i18n.get("exit_prompt")
    )
end

-- ==========================================================
-- DRAW
-- ==========================================================

function UI.draw(
    estado,
    player,
    enemy,
    tier,
    loot_msg,
    camp_msg,
    descanso_usado
)

    if assets.background then

        local bg =
            assets.background

        love.graphics.setColor(
            1, 1, 1, 1
        )

        love.graphics.draw(
            bg,
            0, 0,
            0,
            LOGIC_W / bg:getWidth(),
            LOGIC_H / bg:getHeight()
        )
    end

    if estado == "menu"
    or estado == "clase"
    or estado == "equipo" then

        local idiomas = {
            en = "EN",
            es = "ES",
            pt = "PT"
        }

        dibujarBoton(
            730, 5,
            60, 35,
            idiomas[i18n.current_lang]
            or "?"
        )
    end

    if estado == "menu" then

        dibujarMenu()

    elseif estado == "clase" then

        dibujarClase()

    elseif estado == "equipo" then

        dibujarEquipo()

    elseif estado == "combate" then

        dibujarCombate(
            player,
            enemy,
            tier
        )

    elseif estado == "loot" then

        dibujarLoot(
            loot_msg,
            player,
            tier
        )

    elseif estado == "campamento" then

        dibujarCampamento(
            player,
            tier,
            camp_msg,
            descanso_usado
        )

    elseif estado == "victoria" then

        dibujarFinal(
            i18n.get("victory")
        )

    elseif estado == "derrota" then

        dibujarFinal(
            i18n.get("defeat")
        )
    end

    love.graphics.setColor(
        1, 1, 1, 1
    )
end

return UI
