local utf8 = require("utf8")
local i18n = require("src.i18n")
local Entities = require("src.entities")
local Logic = require("src.logic")
local Data = require("src.data")
local UI = require("src.ui")

local tiempo_juego = 0
local juego_activo = false

estado = "menu"
estado_anterior = "menu"

player = nil
current_enemy = nil
current_battle = nil

current_tier = 1
combates_en_tier = 0

local MAX_COMBATES_POR_TIER = 3
local MAX_TIER = 7

ultimo_loot_msg = ""
mensaje_campamento = ""
descanso_usado = false

input_nombre_record = ""

-- ==========================================================
-- TIEMPO 
-- ==========================================================

function love.update(dt)
    if juego_activo and estado ~= "pausa" and estado ~= "menu" and estado ~= "records" and estado ~= "clase" and estado ~= "equipo" and estado ~= "pedir_nombre" and estado ~= "victoria" and estado ~= "derrota" then
        tiempo_juego = tiempo_juego + dt
    end
end

-- ==========================================================
-- FORMATEAR SEGUNDOS 
-- ==========================================================

local function formatear_tiempo(segundos_totales)
    local mins = math.floor(segundos_totales / 60)
    local secs = math.floor(segundos_totales % 60)
    return string.format("%02d:%02d", mins, secs)
end

-- ==========================================================
-- RESIZE 
-- ==========================================================

function love.resize(w, h)
    if UI.resize then
        UI.resize(w, h)
    end
end

-- ==========================================================
-- CARGAR JUEGO
-- ==========================================================

function love.load()
    UI.load()
end

-- ==========================================================
-- COORDENADAS
-- ==========================================================

local function getLogicalCoordinates(x, y)
    return UI.getLogicalCoordinates(x, y)
end

local function estaEnBoton(x, y, bx, by, bw, bh)
    return UI.estaEnBoton(x, y, bx, by, bw, bh)
end

-- ==========================================================
-- VOLVER AL MENÚ PRINCIPAL
-- ==========================================================

local function volverAlMenu()
    tiempo_juego = 0
    juego_activo = false

    player = nil
    current_enemy = nil
    current_battle = nil

    current_tier = 1
    combates_en_tier = 0

    ultimo_loot_msg = ""
    mensaje_campamento = ""
    descanso_usado = false

    estado = "menu"
end

-- Declaraciones adelantadas para evitar errores de orden
local iniciar_aventura
local finalizar_combate
local continuar_despues_del_loot

-- ==========================================================
-- INPUT
-- ==========================================================

local function procesarInput(raw_x, raw_y)
    local x, y = getLogicalCoordinates(raw_x, raw_y)

    -- ======================================================
    -- BOTÓN SUPERIOR DERECHO (ABRIR MENÚ/PAUSA)
    -- ======================================================
    if estado ~= "pausa" then
        if estaEnBoton(x, y, 1150, 6, 110, 33) then
            estado_anterior = estado
            estado = "pausa"
            return
        end
    end

    -- ======================================================
    -- PAUSA / MENÚ DESPLEGABLE
    -- ======================================================
    if estado == "pausa" then
        -- 1. Cambiar Idioma
        if estaEnBoton(x, y, 480, 230, 320, 45) then
            i18n.toggle_lang()
            return

        -- 2. Cambiar Fullscreen
        elseif estaEnBoton(x, y, 480, 290, 320, 45) then
            local esFullscreen = love.window.getFullscreen()
            love.window.setFullscreen(not esFullscreen, "desktop")
            return

        -- 3. Volver al Juego
        elseif estaEnBoton(x, y, 480, 350, 320, 45) then
            estado = estado_anterior
            return

        -- 4. Salir del Juego por completo
        elseif estaEnBoton(x, y, 480, 410, 320, 45) then
            love.event.quit()
            return
        end
        return
    end

    -- ======================================================
    -- MENÚ
    -- ======================================================

    if estado == "menu" then
        if estaEnBoton(x, y, 440, 360, 400, 60) then
            estado = "clase"
        elseif estaEnBoton(x, y, 440, 440, 400, 60) then
            estado = "records"
        end

    -- ======================================================
    -- RÉCORDS
    -- ======================================================

    elseif estado == "records" then
        if estaEnBoton(x, y, 440, 520, 400, 50) then
            estado = "menu"
        end

    -- ======================================================
    -- CLASE
    -- ======================================================

    elseif estado == "clase" then
        local classes_keys = { "warrior", "explorer", "barbarian" }

        for i, key in ipairs(classes_keys) do
            local by = 240 + (i - 1) * 80
            if estaEnBoton(x, y, 240, by, 800, 60) then
                local class_data = Data.classes[key]
                local nombre_clase = i18n.get(class_data.name_key)
                player = Entities.Player.new("Lucas", nombre_clase, class_data)

                tiempo_juego = 0
                juego_activo = true

                estado = "equipo"
                break
            end
        end

    -- ======================================================
    -- EQUIPO
    -- ======================================================

    elseif estado == "equipo" then
        if estaEnBoton(x, y, 240, 240, 800, 60) then
            player.runas = (player.runas or 0) + 1
            iniciar_aventura()
        elseif estaEnBoton(x, y, 240, 320, 800, 60) then
            player.piedras = (player.piedras or 0) + 1
            iniciar_aventura()
        elseif estaEnBoton(x, y, 240, 400, 800, 60) then
            player.pociones = (player.pociones or 0) + 1
            iniciar_aventura()
        end

    -- ======================================================
    -- COMBATE
    -- ======================================================

    elseif estado == "combate" then
        if not current_battle then
            return
        end

        -- ATACAR
        if estaEnBoton(x, y, 60, 580, 215, 70) then
            current_battle:player_attack()

            if current_enemy.hp <= 0 then
                finalizar_combate()
                return
            end

            current_battle:enemy_attack()

            if player.hp <= 0 then
                player.hp = 0
                input_nombre_record = player.name or "Lucas"
                estado = "pedir_nombre"
            end

        -- DEFENDER
        elseif estaEnBoton(x, y, 295, 580, 215, 70) then
            if current_battle.player_defend then
                current_battle:player_defend()
            end

            current_battle:enemy_attack()

            if player.hp <= 0 then
                player.hp = 0
                input_nombre_record = player.name or "Lucas"
                estado = "pedir_nombre"
            end

        -- RUNA
        elseif estaEnBoton(x, y, 530, 580, 215, 70) then
            if (player.runas or 0) > 0 then
                Logic.usar_runa(player, current_enemy)

                if current_enemy.hp <= 0 then
                    finalizar_combate()
                    return
                end

                current_battle:enemy_attack()

                if player.hp <= 0 then
                    player.hp = 0
                    input_nombre_record = player.name or "Lucas"
                    estado = "pedir_nombre"
                end
            end
        

        -- POCIÓN
        elseif estaEnBoton(x, y, 765, 580, 215, 70) then
            if (player.pociones or 0) > 0 then
                Logic.usar_pocion(player)
                current_battle:enemy_attack()

                if player.hp <= 0 then
                    player.hp = 0
                    input_nombre_record = player.name or "Lucas"
                    estado = "pedir_nombre"
                end
            end

        -- HUIR
        elseif estaEnBoton(x, y, 1000, 580, 215, 70) then
            volverAlMenu()
            return
        end

    -- ======================================================
    -- LOOT
    -- ======================================================

    elseif estado == "loot" then
        if estaEnBoton(x, y, 440, 420, 400, 70) then
            continuar_despues_del_loot()
        end

    -- ======================================================
    -- CAMPAMENTO
    -- ======================================================

    elseif estado == "campamento" then
        if estaEnBoton(x, y, 240, 230, 800, 55) then
            if descanso_usado then
                mensaje_campamento = i18n.get("already_rest")
            else
                local hp_recuperado = Logic.aplicar_descanso(player, 40)
                descanso_usado = true

                if hp_recuperado > 0 then
                    mensaje_campamento = i18n.get("rested") .. hp_recuperado .. " HP."
                else
                    mensaje_campamento = i18n.get("rested_full")
                end
            end

        elseif estaEnBoton(x, y, 240, 305, 800, 55) then
            local ataque_ganado = Logic.aplicar_afilado(player)

            if ataque_ganado > 0 then
                mensaje_campamento = i18n.get("sharpened") .. ataque_ganado .. "."
            else
                mensaje_campamento = i18n.get("no_whetstones")
            end

        elseif estaEnBoton(x, y, 240, 380, 800, 55) then
            current_tier = current_tier + 1

            if current_tier > MAX_TIER then
                input_nombre_record = player.name or "Lucas"
                estado = "pedir_nombre"
                return
            end

            descanso_usado = false
            mensaje_campamento = ""
            iniciar_aventura()
        end

    -- ======================================================
    -- PEDIR NOMBRE PARA RECORD
    -- ======================================================

    elseif estado == "pedir_nombre" then
        if estaEnBoton(x, y, 440, 400, 400, 60) then
            if #input_nombre_record > 0 and #input_nombre_record <= 16 then
                local es_victoria = (current_tier > MAX_TIER)
                local tier_a_guardar = es_victoria and 7 or current_tier
                local pelea_a_guardar = es_victoria and 1 or (combates_en_tier + 1)
                
                local tiempo_str = formatear_tiempo(tiempo_juego)
                Logic.guardar_record(tier_a_guardar, pelea_a_guardar, es_victoria, input_nombre_record, tiempo_str)
            end
            volverAlMenu()
        elseif estaEnBoton(x, y, 440, 480, 400, 60) then
            volverAlMenu()
        end

    -- ======================================================
    -- FINAL
    -- ======================================================

    elseif estado == "victoria" or estado == "derrota" then
        if estaEnBoton(x, y, 440, 400, 400, 60) then
            volverAlMenu()
        end
    end
end

-- ==========================================================
-- GESTIÓN DE NOMBRES PARA RECORD
-- ==========================================================

function love.textinput(text)
    if estado == "pedir_nombre" then
        if #input_nombre_record < 16 then
            input_nombre_record = input_nombre_record .. text
        end
    end
end

function love.keypressed(key)
    if estado == "pedir_nombre" then
        if key == "backspace" then
            local byteoffset = utf8.offset(input_nombre_record, -1)
            if byteoffset then
                input_nombre_record = string.sub(input_nombre_record, 1, byteoffset - 1)
            end
        elseif key == "return" or key == "kpenter" then
            if #input_nombre_record > 0 and #input_nombre_record <= 16 then
                local es_victoria = (current_tier > MAX_TIER)
                local tier_a_guardar = es_victoria and 7 or current_tier
                local pelea_a_guardar = es_victoria and 1 or (combates_en_tier + 1)
                
                local tiempo_str = formatear_tiempo(tiempo_juego)
                Logic.guardar_record(tier_a_guardar, pelea_a_guardar, es_victoria, input_nombre_record, tiempo_str)
            end
            volverAlMenu()
        elseif key == "escape" then
            volverAlMenu()
        end
    end
end

-- ==========================================================
-- FINALIZAR COMBATE
-- ==========================================================

function finalizar_combate()
    ultimo_loot_msg = Logic.ganar_loot(player)
    combates_en_tier = combates_en_tier + 1
    estado = "loot"
end

-- ==========================================================
-- CONTINUAR DESPUÉS DEL LOOT
-- ==========================================================

function continuar_despues_del_loot()
    if combates_en_tier >= MAX_COMBATES_POR_TIER then
        combates_en_tier = 0
        descanso_usado = false
        mensaje_campamento = ""
        estado = "campamento"
        return
    end

    iniciar_aventura()
end

-- ==========================================================
-- INICIAR AVENTURA
-- ==========================================================

iniciar_aventura = function()
    -- El tiempo se reinicia solamente al comenzar una partida.
    juego_activo = true
    estado = "combate"
    ultimo_loot_msg = ""

    local pool = Data.enemies
    current_enemy = Logic.spawn_enemy(current_tier, pool)

    if not current_enemy.sprite then
        current_enemy.sprite = "rat"
    end

    current_battle = Logic.BattleManager.new(player, current_enemy)
end

-- ==========================================================
-- MOUSE
-- ==========================================================

function love.mousepressed(x, y, button)
    procesarInput(x, y)
end

-- ==========================================================
-- TOUCH
-- ==========================================================

function love.touchpressed(id, x, y, dx, dy, pressure)
    procesarInput(x, y)
end

-- ==========================================================
-- DRAW
-- ==========================================================

function love.draw()
    UI.draw(
        estado,
        player,
        current_enemy,
        current_tier,
        ultimo_loot_msg,
        mensaje_campamento,
        descanso_usado
    )
end
