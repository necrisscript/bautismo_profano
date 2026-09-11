local i18n = require("src.i18n")
local Entities = require("src.entities")
local Logic = require("src.logic")
local Data = require("src.data")
local UI = require("src.ui")


estado = "menu"

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

    return UI.estaEnBoton(
        x,
        y,
        bx,
        by,
        bw,
        bh
    )

end


-- ==========================================================
-- VOLVER AL MENÚ PRINCIPAL
-- ==========================================================

local function volverAlMenu()

    -- Eliminar partida actual.

    player = nil
    current_enemy = nil
    current_battle = nil

    -- Reiniciar progreso.

    current_tier = 1
    combates_en_tier = 0

    -- Limpiar mensajes.

    ultimo_loot_msg = ""
    mensaje_campamento = ""
    descanso_usado = false

    -- Volver al menú.

    estado = "menu"

end


-- ==========================================================
-- INPUT
-- ==========================================================

local function procesarInput(raw_x, raw_y)

    local x, y =
        getLogicalCoordinates(
            raw_x,
            raw_y
        )


    -- ======================================================
    -- CAMBIO DE IDIOMA
    -- ======================================================

    if x > 650 and y < 50 then

        i18n.toggle_lang()

        return

    end


    -- ======================================================
    -- MENÚ
    -- ======================================================

    if estado == "menu" then

        estado = "clase"


    -- ======================================================
    -- CLASE
    -- ======================================================

    elseif estado == "clase" then

        local clase_map = {

            {
                nombre = "Guerrero",
                hp = 150,
                ataque = 14,
                defensa = 13,
                afilado_bonus = 10
            },

            {
                nombre = "Explorador",
                hp = 150,
                ataque = 20,
                defensa = 4,
                afilado_bonus = 10
            },

            {
                nombre = "Bárbaro",
                hp = 150,
                ataque = 34,
                defensa = 2,
                afilado_bonus = 15
            }

        }


        if estaEnBoton(
            x,
            y,
            100,
            200,
            600,
            50
        ) then

            player =
                Entities.Player.new(
                    "Lucas",
                    clase_map[1].nombre,
                    clase_map[1]
                )

            estado = "equipo"


        elseif estaEnBoton(
            x,
            y,
            100,
            260,
            600,
            50
        ) then

            player =
                Entities.Player.new(
                    "Lucas",
                    clase_map[2].nombre,
                    clase_map[2]
                )

            estado = "equipo"


        elseif estaEnBoton(
            x,
            y,
            100,
            320,
            600,
            50
        ) then

            player =
                Entities.Player.new(
                    "Lucas",
                    clase_map[3].nombre,
                    clase_map[3]
                )

            estado = "equipo"

        end


    -- ======================================================
    -- EQUIPO
    -- ======================================================

    elseif estado == "equipo" then

        if estaEnBoton(
            x,
            y,
            100,
            200,
            600,
            50
        ) then

            player.runas =
                (player.runas or 0) + 1

            iniciar_aventura()


        elseif estaEnBoton(
            x,
            y,
            100,
            260,
            600,
            50
        ) then

            player.piedras =
                (player.piedras or 0) + 1

            iniciar_aventura()


        elseif estaEnBoton(
            x,
            y,
            100,
            320,
            600,
            50
        ) then

            player.pociones =
                (player.pociones or 0) + 1

            iniciar_aventura()

        end


    -- ======================================================
    -- COMBATE
    -- ======================================================

    elseif estado == "combate" then

        if not current_battle then

            return

        end


-- ==================================================
        -- ATACAR
        -- ==================================================

        if estaEnBoton(
            x,
            y,
            20,     -- X inicial
            480,
            145,    -- Ancho ajustado
            60
        ) then

            current_battle:player_attack()


            if current_enemy.hp <= 0 then

                finalizar_combate()

                return

            end


            current_battle:enemy_attack()


            if player.hp <= 0 then

                player.hp = 0
                estado = "derrota"

            end


        -- ==================================================
        -- DEFENDER (NUEVO)
        -- ==================================================

        elseif estaEnBoton(
            x,
            y,
            175,    -- 20 (anterior) + 145 (ancho) + 10 (espacio)
            480,
            145,    -- Ancho ajustado
            60
        ) then

            if current_battle.player_defend then
                current_battle:player_defend()
            end

            current_battle:enemy_attack()

            if player.hp <= 0 then
                player.hp = 0
                estado = "derrota"
            end


        -- ==================================================
        -- RUNA
        -- ==================================================

        elseif estaEnBoton(
            x,
            y,
            330,    -- 175 + 145 + 10
            480,
            145,    -- Ancho ajustado
            60
        ) then

            if (player.runas or 0) > 0 then

                player.runas =
                    player.runas - 1

                current_enemy.hp =
                    current_enemy.hp - 35


                if current_enemy.hp <= 0 then

                    finalizar_combate()

                    return

                end


                current_battle:enemy_attack()


                if player.hp <= 0 then

                    player.hp = 0
                    estado = "derrota"

                end

            end


        -- ==================================================
        -- POCIÓN
        -- ==================================================

        elseif estaEnBoton(
            x,
            y,
            485,    -- 330 + 145 + 10
            480,
            145,    -- Ancho ajustado
            60
        ) then

            if (player.pociones or 0) > 0 then

                Logic.usar_pocion(player)

                current_battle:enemy_attack()


                if player.hp <= 0 then

                    player.hp = 0
                    estado = "derrota"

                end

            end


        -- ==================================================
        -- HUIR
        -- ==================================================

        elseif estaEnBoton(
            x,
            y,
            640,    -- 485 + 145 + 10 (queda un borde prolijo al final)
            480,
            140,    -- Ancho ligeramente menor para el último
            60
        ) then

            volverAlMenu()

            return

        end


    -- ======================================================
    -- LOOT
    -- ======================================================

    elseif estado == "loot" then

        continuar_despues_del_loot()


    -- ======================================================
    -- CAMPAMENTO
    -- ======================================================

    elseif estado == "campamento" then


        if estaEnBoton(
            x,
            y,
            100,
            200,
            600,
            45
        ) then

            if descanso_usado then

                mensaje_campamento =
                    i18n.get("ya_descansaste")

            else

                local hp_recuperado =
                    Logic.aplicar_descanso(
                        player,
                        40
                    )

                descanso_usado = true


                if hp_recuperado > 0 then

                    mensaje_campamento =
                        i18n.get(
                            "descansaste_recuperaste"
                        )
                        .. hp_recuperado
                        .. " HP."

                else

                    mensaje_campamento =
                        i18n.get(
                            "descansaste_completo"
                        )

                end

            end


        elseif estaEnBoton(
            x,
            y,
            100,
            255,
            600,
            45
        ) then

            local ataque_ganado =
                Logic.aplicar_afilado(player)


            if ataque_ganado > 0 then

                mensaje_campamento =
                    i18n.get("afilaste_arma")
                    .. ataque_ganado
                    .. "."

            else

                mensaje_campamento =
                    i18n.get("no_piedras_afilar")

            end


        elseif estaEnBoton(
            x,
            y,
            100,
            310,
            600,
            45
        ) then

            current_tier =
                current_tier + 1


            if current_tier > MAX_TIER then

                estado = "victoria"

                return

            end


            descanso_usado = false
            mensaje_campamento = ""

            iniciar_aventura()


        elseif estaEnBoton(
            x,
            y,
            100,
            365,
            600,
            45
        ) then

            estado = "victoria"

        end


    -- ======================================================
    -- FINAL
    -- ======================================================

    elseif estado == "victoria"
        or estado == "derrota" then

        love.event.quit()

    end

end


-- ==========================================================
-- FINALIZAR COMBATE
-- ==========================================================

function finalizar_combate()

    ultimo_loot_msg =
        Logic.ganar_loot(player)

    combates_en_tier =
        combates_en_tier + 1

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

function iniciar_aventura()

    estado = "combate"
    ultimo_loot_msg = ""

    local pool = Data.enemies


    current_enemy =
        Logic.spawn_enemy(
            current_tier,
            pool
        )


    if not current_enemy.sprite then

        current_enemy.sprite = "rat"

    end


    current_battle =
        Logic.BattleManager.new(
            player,
            current_enemy
        )

end


-- ==========================================================
-- MOUSE
-- ==========================================================

function love.mousepressed(
    x,
    y,
    button
)

    procesarInput(x, y)

end


-- ==========================================================
-- TOUCH
-- ==========================================================

function love.touchpressed(
    id,
    x,
    y,
    dx,
    dy,
    pressure
)

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
