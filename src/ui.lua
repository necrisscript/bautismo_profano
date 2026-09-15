local i18n = require("src.i18n")
local Logic = require("src.logic")

-- ==========================================================
-- LOOT LOCALIZADO
-- ==========================================================

local function mensajeLoot(loot)
    if not loot or not loot.tipo then
        return i18n.get("no_loot")
    end

    local objeto_key = nil

    if loot.tipo == "pociones" then
        objeto_key = "loot_potion"
    elseif loot.tipo == "piedras" then
        objeto_key = "loot_whetstone"
    elseif loot.tipo == "runas" then
        objeto_key = "loot_rune"
    end

    if not objeto_key then
        return i18n.get("no_loot")
    end

    local prefijo = i18n.get("loot_found")
    local objeto = i18n.get(objeto_key)

    return prefijo .. objeto
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

local LOGIC_W = 1280
local LOGIC_H = 720

-- Variables de Escalado
local scale = 1
local offsetX, offsetY = 0, 0

-- ==========================================================
-- CARGAR ASSETS Y REDIMENSIONAMIENTO
-- ==========================================================

function UI.load()
    assets.background = love.graphics.newImage("assets/background.png")
    assets.title = love.graphics.newImage("assets/title.png")
    assets.enemy_sprites = {}

    local enemy_names = {
        "archmage", "cultist", "gargoyle", "goblin", "incubus",
        "jelly", "kobold", "mimic", "minotaur", "orc", "rat",
        "skeleton", "spider", "succubus", "vampire", "wraith", "zombie",
        "ogre"
    }

    for _, name in ipairs(enemy_names) do
        assets.enemy_sprites[name] = love.graphics.newImage("assets/" .. name .. ".png")
    end

    assets.items = {
        heart = love.graphics.newImage("assets/heart.png"),
        potion = love.graphics.newImage("assets/potion.png"),
        runes = love.graphics.newImage("assets/runes.png"),
        whetstone = love.graphics.newImage("assets/whetstone.png"),
        attack = love.graphics.newImage("assets/attack.png"),
        defend = love.graphics.newImage("assets/defend.png")
    }

    UI.resize(love.graphics.getDimensions())
end

function UI.resize(w, h)
    local scaleX = w / LOGIC_W
    local scaleY = h / LOGIC_H
    
    if scaleX < scaleY then
        scale = scaleX
        offsetX = 0
        offsetY = (h - (LOGIC_H * scale)) / 2
    else
        scale = scaleY
        offsetX = (w - (LOGIC_W * scale)) / 2
        offsetY = 0
    end
end

-- ==========================================================
-- COORDENADAS
-- ==========================================================

function UI.getLogicalCoordinates(x, y)
    local logicalX = (x - offsetX) / scale
    local logicalY = (y - offsetY) / scale
    return logicalX, logicalY
end

-- ==========================================================
-- BOTÓN
-- ==========================================================

function UI.estaEnBoton(x, y, bx, by, bw, bh)
    return x >= bx and x <= bx + bw and y >= by and y <= by + bh
end

local function dibujarBoton(x, y, w, h, texto)
    love.graphics.setColor(0.03, 0.03, 0.05, 0.95)
    love.graphics.rectangle("fill", x, y, w, h, 8, 8)

    love.graphics.setColor(0.35, 0.35, 0.4, 1)
    love.graphics.rectangle("line", x, y, w, h, 8, 8)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(texto, x, y + (h - 20) / 2, w, "center")
end

local function dibujarIcono(imagen, x, y, size)
    if not imagen then return end

    local sc = size / math.max(imagen:getWidth(), imagen:getHeight())

    love.graphics.draw(
        imagen, x, y, 0, sc, sc,
        imagen:getWidth() / 2,
        imagen:getHeight() / 2
    )
end

-- ==========================================================
-- PAUSA / MENÚ DESPLEGABLE
-- ==========================================================

local function dibujarPausa()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, LOGIC_W, LOGIC_H)

    love.graphics.setColor(0.05, 0.05, 0.08, 0.95)
    love.graphics.rectangle("fill", 440, 160, 400, 390, 10, 10)
    love.graphics.setColor(0.35, 0.35, 0.4, 1)
    love.graphics.rectangle("line", 440, 160, 400, 390, 10, 10)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(i18n.get("menu") or "MENÚ", 440, 185, 400, "center")

    local lang_text = i18n.get("language_label")
    local fs_text = love.window.getFullscreen() and i18n.get("fullscreen_on") or i18n.get("fullscreen_off")

    dibujarBoton(480, 230, 320, 45, lang_text)
    dibujarBoton(480, 290, 320, 45, fs_text)
    dibujarBoton(480, 350, 320, 45, i18n.get("resume_game"))
    dibujarBoton(480, 410, 320, 45, i18n.get("exit_game"))
end

-- ==========================================================
-- BARRA DEL JUGADOR
-- ==========================================================

local function dibujarBarraJugador(player, tier)
    love.graphics.setColor(0.02, 0.02, 0.03, 0.90)
    love.graphics.rectangle("fill", 0, 0, LOGIC_W, 45)

    love.graphics.setColor(0.25, 0.25, 0.28, 1)
    love.graphics.line(0, 45, LOGIC_W, 45)

    if player then
        love.graphics.setColor(0.9, 0.9, 0.9, 1)

        love.graphics.printf(i18n.get("hp") .. " " .. player.hp .. "/" .. player.max_hp, 20, 13, 150, "left")
        love.graphics.printf(i18n.get("atk") .. " " .. player.ataque, 180, 13, 100, "left")
        love.graphics.printf(i18n.get("def") .. " " .. player.defensa, 290, 13, 100, "left")

        dibujarIcono(assets.items.potion, 415, 22, 22)
        love.graphics.printf(tostring(player.pociones or 0), 435, 13, 50, "left")

        dibujarIcono(assets.items.runes, 505, 22, 22)
        love.graphics.printf(tostring(player.runas or 0), 525, 13, 50, "left")

        dibujarIcono(assets.items.whetstone, 595, 22, 22)
        love.graphics.printf(tostring(player.piedras or 0), 615, 13, 50, "left")

        love.graphics.printf(i18n.get("tier") .. " " .. tostring(tier or 1), 950, 13, 120, "right")
    end

    dibujarBoton(1150, 6, 110, 33, i18n.get("menu"))

    love.graphics.setColor(1, 1, 1, 1)
end

-- ==========================================================
-- INTENCIÓN
-- ==========================================================

local function dibujarIntencion(enemy)
    if not enemy then return end

    local intent = enemy.intent or "attack"
    local centerX = LOGIC_W / 2
    local intentY = 180

    if intent == "attack" then
        local image = assets.items.attack
        if image then
            local size = 28
            local scaleX = size / image:getWidth()
            local scaleY = size / image:getHeight()

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(image, centerX - size / 2 - 25, intentY, 0, scaleX, scaleY)
        end

        love.graphics.setColor(1, 0.35, 0.25, 1)
        love.graphics.printf(tostring(enemy.intent_damage or 0), centerX + 5, intentY + 2, 100, "left")

    elseif intent == "defend" then
        local image = assets.items.defend
        if image then
            local size = 28
            local scaleX = size / image:getWidth()
            local scaleY = size / image:getHeight()

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(image, centerX - size / 2 - 25, intentY, 0, scaleX, scaleY)
        end

        love.graphics.setColor(0.35, 0.75, 1, 1)
        love.graphics.printf(tostring(enemy.defensa or 0), centerX + 5, intentY + 2, 100, "left")

    elseif intent == "potion" then
        local image = assets.items.heart
        if image then
            local size = 30
            local sc = size / math.max(image:getWidth(), image:getHeight())

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(image, centerX - 15 - 25, intentY, 0, sc, sc, image:getWidth() / 2, image:getHeight() / 2)
        end

        love.graphics.setColor(1, 0.25, 0.35, 1)
        love.graphics.printf("+" .. tostring(enemy.intent_heal or 50), centerX + 5, intentY + 2, 100, "left")

    elseif intent == "rune" then
        local image = assets.items.runes
        if image then
            local size = 30
            local sc = size / math.max(image:getWidth(), image:getHeight())

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(image, centerX - 15 - 25, intentY, 0, sc, sc, image:getWidth() / 2, image:getHeight() / 2)
        end

        love.graphics.setColor(0.75, 0.4, 1, 1)
        love.graphics.printf(tostring(enemy.intent_damage or 35), centerX + 5, intentY + 2, 100, "left")

    elseif intent == "skill" then
        love.graphics.setColor(0.8, 0.4, 1, 1)
        love.graphics.printf("✦", centerX - 100, intentY, 200, "center")

    elseif intent == "debuff" then
        love.graphics.setColor(0.7, 0.3, 0.8, 1)
        love.graphics.printf("☠", centerX - 100, intentY, 200, "center")
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- ==========================================================
-- DIBUJAR RÉCORD Y PANTALLA DE INGRESO DE NOMBRE
-- ==========================================================

function UI.draw_record(x, y)
    if estado == "pedir_nombre" then
        love.graphics.printf(i18n.get("new_record"), 0, 180, LOGIC_W, "center")
        love.graphics.printf(i18n.get("enter_name"), 0, 240, LOGIC_W, "center")
        
        -- Caja de texto visual
        love.graphics.rectangle("line", 440, 300, 400, 60)
        love.graphics.printf((input_nombre_record or "") .. "_", 440, 315, 400, "center")
        
        -- Botones con i18n
        dibujarBoton(440, 400, 400, 60, i18n.get("save_record"))
        dibujarBoton(440, 480, 400, 60, i18n.get("cancel"))
        return
    end

    local records = Logic.cargar_records()
    
    if not x or not y then
        return
    end

    if #records == 0 then
        love.graphics.setColor(0.9, 0.8, 0.3, 1)
        love.graphics.print(i18n.get("no_records") or "No records yet", x, y)
        love.graphics.setColor(1, 1, 1, 1)
        return
    end

    for i, rec in ipairs(records) do
        local nombre_jugador = rec.nombre or "Anónimo"
        local texto = string.format("%d. %s - Tier %d (Pelea %d)", i, nombre_jugador, rec.tier, rec.pelea)
        if (tonumber(rec.tier) or 0) >= 7 then
            texto = string.format("%d. %s - ¡VICTORIA! (Tier %d)", i, nombre_jugador, rec.tier)
        end
        love.graphics.setColor(0.9, 0.8, 0.3, 1)
        love.graphics.print(texto, x, y + (i - 1) * 30)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

-- ==========================================================
-- MENÚ PRINCIPAL
-- ==========================================================

local function dibujarMenu()
    -- Si cargó correctamente la imagen del título, la dibujamos centrada
    if assets.title then
        local img = assets.title
        local targetW = 600 -- Ancho máximo deseado para el título en la pantalla lógica
        local sc = targetW / img:getWidth()
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            img, 
            LOGIC_W / 2, 140, -- Posición central X, y coordenada Y inicial
            0, 
            sc, sc, 
            img:getWidth() / 2, 0 -- Origin X al centro, Origin Y arriba
        )
    else
        -- Fallback por si la imagen llegara a faltar
        love.graphics.printf(i18n.get("title") or "BAUTISMO PROFANO", 0, 180, LOGIC_W, "center")
    end
    
    dibujarBoton(440, 360, 400, 60, i18n.get("play_btn"))
    dibujarBoton(440, 440, 400, 60, i18n.get("records_btn"))

    dibujarBoton(1150, 10, 110, 33, i18n.get("menu"))
end

-- ==========================================================
-- PANTALLA DE RÉCORDS (TOP 10)
-- ==========================================================

local function dibujarRecordsScreen()
    love.graphics.printf(i18n.get("records_title"), 0, 100, LOGIC_W, "center")

    local records = Logic.cargar_records()

    if #records == 0 then
        love.graphics.printf(i18n.get("no_records"), 0, 260, LOGIC_W, "center")
    else
        local startY = 180
        for i, rec in ipairs(records) do
            local nombre_jugador = rec.nombre or "Anónimo"
            local tiempo_jugador = rec.tiempo or "00:00"
            local tier_record = tonumber(rec.tier) or 1
            local pelea_record = tonumber(rec.pelea) or 1

            local texto = string.format("%2d. %s - Tier %d (Pelea %d) [%s]", i, nombre_jugador, tier_record, pelea_record, tiempo_jugador)
            
            if (tonumber(rec.tier) or 0) >= 7 then
                texto = string.format("%2d. %s - ¡VICTORIA! [%s]", i, nombre_jugador, tiempo_jugador)
            end
            
            love.graphics.printf(texto, 0, startY, LOGIC_W, "center")
            startY = startY + 30
        end
    end

    dibujarBoton(440, 520, 400, 50, i18n.get("back"))
end

-- ==========================================================
-- CLASE
-- ==========================================================

local function dibujarClase()
    love.graphics.printf(i18n.get("arsenal"), 140, 120, 1000, "center")
    dibujarBoton(240, 240, 800, 60, i18n.get("class_1"))
    dibujarBoton(240, 320, 800, 60, i18n.get("class_2"))
    dibujarBoton(240, 400, 800, 60, i18n.get("class_3"))
    dibujarBoton(1150, 10, 110, 33, i18n.get("menu"))
end

-- ==========================================================
-- EQUIPO
-- ==========================================================

local function dibujarEquipo()
    love.graphics.printf(i18n.get("supplies"), 140, 120, 1000, "center")
    dibujarBoton(240, 240, 800, 60, i18n.get("supply_1"))
    dibujarBoton(240, 320, 800, 60, i18n.get("supply_2"))
    dibujarBoton(240, 400, 800, 60, i18n.get("supply_3"))
    dibujarBoton(1150, 10, 110, 33, i18n.get("menu"))
end

-- ==========================================================
-- COMBATE
-- ==========================================================

local function dibujarCombate(player, enemy, tier)
    dibujarBarraJugador(player, tier)

    local sprite
    if enemy then
        sprite = assets.enemy_sprites[enemy.sprite]
    end

    if not sprite then
        sprite = assets.enemy_sprites.rat
    end

    if sprite then
        local targetSize = 220
        local sc = targetSize / math.max(sprite:getWidth(), sprite:getHeight())

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            sprite, LOGIC_W / 2, LOGIC_H / 2, 0, sc, sc,
            sprite:getWidth() / 2,
            sprite:getHeight() / 2
        )
    end

    if enemy then
        local barWidth = 300
        local barHeight = 10
        local barX = (LOGIC_W - barWidth) / 2
        local barY = 220
        local hp_ratio = math.max(0, enemy.hp / enemy.max_hp)

        love.graphics.setColor(0.12, 0.02, 0.02, 1)
        love.graphics.rectangle("fill", barX, barY, barWidth, barHeight, 3, 3)

        love.graphics.setColor(0.75, 0.06, 0.06, 1)
        love.graphics.rectangle("fill", barX, barY, barWidth * hp_ratio, barHeight, 3, 3)

        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", barX, barY, barWidth, barHeight, 3, 3)

        love.graphics.setColor(1, 1, 1, 1)
        local enemy_name = i18n.get(enemy.name_key)
        love.graphics.printf(enemy_name, 140, 165, 1000, "center")

        dibujarIntencion(enemy)
    end

    dibujarBoton(60, 580, 215, 70, i18n.get("attack"))
    dibujarBoton(295, 580, 215, 70, i18n.get("defend"))
    dibujarBoton(530, 580, 215, 70, i18n.get("rune") .. " (" .. (player and player.runas or 0) .. ")")
    dibujarBoton(765, 580, 215, 70, i18n.get("potion") .. " (" .. (player and player.pociones or 0) .. ")")
    dibujarBoton(1000, 580, 215, 70, i18n.get("flee"))
end

-- ==========================================================
-- LOOT
-- ==========================================================

local function dibujarLoot(loot_msg, player, tier)
    dibujarBarraJugador(player, tier)

    love.graphics.printf(i18n.get("defeated"), 140, 180, 1000, "center")

    love.graphics.setColor(1, 0.84, 0, 1)
    love.graphics.printf(loot_msg or "", 140, 290, 1000, "center")

    love.graphics.setColor(1, 1, 1, 1)
    dibujarBoton(440, 420, 400, 70, i18n.get("continue"))
end

-- ==========================================================
-- CAMPAMENTO
-- ==========================================================

local function dibujarCampamento(player, tier, mensaje, descanso_usado)
    dibujarBarraJugador(player, tier)

    love.graphics.printf(i18n.get("camp") .. tier, 140, 100, 1000, "center")

    if mensaje and mensaje ~= "" then
        love.graphics.setColor(0.3, 1, 0.5, 1)
        love.graphics.printf(mensaje, 140, 160, 1000, "center")
        love.graphics.setColor(1, 1, 1, 1)
    end

    local texto_descanso = i18n.get("camp_1")
    if descanso_usado then
        texto_descanso = i18n.get("already_rest")
    end

    dibujarBoton(240, 230, 800, 55, texto_descanso)
    dibujarBoton(240, 305, 800, 55, i18n.get("camp_2"))
    dibujarBoton(240, 380, 800, 55, i18n.get("camp_3") .. (tier + 1))
end

-- ==========================================================
-- FINAL
-- ==========================================================

local function dibujarFinal(texto)
    love.graphics.printf(texto, 0, 250, LOGIC_W, "center")
    dibujarBoton(440, 400, 400, 60, i18n.get("exit_prompt"))
    dibujarBoton(1150, 10, 110, 33, i18n.get("menu"))
end

-- ==========================================================
-- DRAW
-- ==========================================================

function UI.draw(estado, player, enemy, tier, loot_msg, camp_msg, descanso_usado)
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    if assets.background then
        local bg = assets.background
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(bg, 0, 0, 0, LOGIC_W / bg:getWidth(), LOGIC_H / bg:getHeight())
    end

    if estado == "menu" then
        dibujarMenu()
    elseif estado == "records" then
        dibujarRecordsScreen()
    elseif estado == "clase" then
        dibujarClase()
    elseif estado == "equipo" then
        dibujarEquipo()
    elseif estado == "combate" then
        dibujarCombate(player, enemy, tier)
    elseif estado == "loot" then
        dibujarLoot(loot_msg, player, tier)
    elseif estado == "campamento" then
        dibujarCampamento(player, tier, camp_msg, descanso_usado)
    elseif estado == "victoria" then
        dibujarFinal(i18n.get("victory"))
    elseif estado == "derrota" then
        dibujarFinal(i18n.get("defeat"))
    elseif estado == "pedir_nombre" then
        UI.draw_record()
    end

    if estado == "pausa" then
        dibujarPausa()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end
return UI
