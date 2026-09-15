local i18n = {}

i18n.current_lang = "es"

i18n.translations = {

    en = {
        -- ==========================================
        -- MENÚ DE PAUSA / OPCIONES GLOBALES
        -- ==========================================
        exit_game = "Exit Game",
        resume_game = "Resume Game",
        fullscreen_on = "Fullscreen: ON",
        fullscreen_off = "Fullscreen: OFF",
        language_label = "Language: English",
        menu = "Menu",

        -- ==========================================
        -- RESTO DEL JUEGO
        -- ==========================================
        new_record = "New High Score!",
        enter_name = "Enter your name (max. 16 chars):",
        save_record = "Save Score",
        cancel = "Cancel",

        play_btn = "PLAY",
        records_btn = "HIGH SCORES",
        records_title = "TOP 10 HIGH SCORES",
        no_records = "No records registered yet.",
        back = "BACK",

        record_display = "Record: Tier %d - Fight %d/3",
        record_victory = "Record: Tier 7 (Final Boss Reached/Defeated)!",

        loot_found = "Found: ",

        title = "BAUTISMO PROFANO",
        press_enter = "[ Tap to Start ]",

        arsenal = "STEEL MARKET - Choose your Class:",

        class_1_name = "Warrior",
        class_1_desc = "Balanced combatant in heavy steel",

        class_2_name = "Explorer",
        class_2_desc = "Swift pathfinder of the ruins",

        class_3_name = "Barbarian",
        class_3_desc = "Unstoppable brute force",

        class_1 = "1. Warrior (Balanced combatant in heavy steel)",
        class_2 = "2. Explorer (Swift pathfinder of the ruins)",
        class_3 = "3. Barbarian (Unstoppable brute force)",

        supplies = "DESCENT PREPARATION - Choose your supplies:",

        supply_1_name = "Explosive Runes",
        supply_2_name = "Whetstone",
        supply_3_name = "Health Potion",

        supply_1 = "1. Explosive Runes (Volatile magic runes)",
        supply_2 = "2. Whetstone (Sharpen weapons)",
        supply_3 = "3. Health Potion (Restores health)",

        attack = "Attack",
        defend = "Defend",
        rune = "Rune",
        potion = "Potion",
        flee = "Flee",

        hp = "HP",
        atk = "ATK",
        def = "DEF",
        tier = "TIER",

        defeated = "ENEMY DEFEATED",
        continue = "[ Continue ]",

        camp = "DEEP CAMP - TIER ",
        camp_1 = "1. Rest and heal wounds",
        camp_2 = "2. Sharpen weapons (Increase attack)",
        camp_3 = "3. Descend to Tier ",
        camp_4 = "4. Abandon the enterprise",

        victory = "YOU HAVE ESCAPED KHOROS!",
        defeat = "YOUR CORPSE LIES IN THE DEPTHS...",
        exit_prompt = "[ Tap to exit ]",

        already_rest = "You already rested at this camp.",
        ya_descansaste = "You already rested at this camp.",
        rested = "You rested. Recovered ",
        descansaste_recuperaste = "You rested. Recovered ",
        rested_full = "You rested, but your HP was already full.",
        descansaste_completo = "You rested, but your HP was already full.",
        sharpened = "You sharpened your weapon. Attack +",
        afilaste_arma = "You sharpened your weapon. Attack +",
        no_whetstones = "You have no whetstones.",
        no_piedras_afilar = "You have no whetstones.",
        fled = "You fled from the battle.",

        loot_potion = "Health Potion",
        loot_whetstone = "Whetstone",
        loot_rune = "Explosive Rune",

        no_loot = "You found no items.",

        boss_name = "THE CHAIN SORCERER",

        enemy_rat = "Sewage Rat",
        enemy_zombie = "Starving Zombie",
        enemy_kobold = "Sly Kobold",
        enemy_spider = "Cave Spider",
        enemy_skeleton = "Skeleton Warrior",
        enemy_goblin = "Goblin Looter",
        enemy_orc = "Furious Orc",
        enemy_jelly = "Ochre Jelly",
        enemy_mimic = "Treacherous Mimic",
        enemy_gargoyle = "Stone Gargoyle",
        enemy_cultist = "Death Cultist",
        enemy_ogre = "Crushing Ogre",
        enemy_shadow = "Stalking Shadow",
        enemy_minotaur = "Labyrinth Minotaur",
        enemy_wraith = "Undermountain Wraith",
        enemy_golem = "Iron Golem",
        enemy_mummy = "Mummy Lord",
        enemy_incubus = "Tormenting Incubus",
        enemy_succubus = "Seductive Succubus",
        enemy_vampire = "Thirsty Vampire",
        enemy_archmage = "Grand Archmage"
    },

    es = {
        -- ==========================================
        -- MENÚ DE PAUSA / OPCIONES GLOBALES
        -- ==========================================
        new_record = "¡Nuevo Récord!",
        enter_name = "Ingresa tu nombre (máx. 16 caracteres):",
        save_record = "Guardar Récord",
        cancel = "Cancelar",
        exit_game = "Salir del Juego",
        resume_game = "Volver al Juego",
        fullscreen_on = "Pantalla Completa: SÍ",
        fullscreen_off = "Pantalla Completa: NO",
        language_label = "Idioma: Español",
        menu = "Menú",

        -- ==========================================
        -- RESTO DEL JUEGO
        -- ==========================================
        play_btn = "JUGAR",
        records_btn = "VER RÉCORDS",
        records_title = "MEJORES RÉCORDS",
        no_records = "Aún no hay récords registrados.",
        back = "VOLVER",

        record_display = "Récord: Tier %d - Pelea %d/3",
        record_victory = "Récord: ¡Tier 7 (Jefe Final alcanzado/superado)!",

        loot_found = "Encontraste: ",

        title = "BAUTISMO PROFANO",
        press_enter = "[ Toca para Comenzar ]",

        arsenal = "MERCADO DE ACERO - Elige tu Clase:",

        class_1_name = "Guerrero",
        class_1_desc = "Combatiente equilibrado en acero pesado",

        class_2_name = "Explorador",
        class_2_desc = "Ágil rastreador de las ruinas",

        class_3_name = "Bárbaro",
        class_3_desc = "Fuerza bruta imparable",

        class_1 = "1. Guerrero (Combatiente equilibrado en acero pesado)",
        class_2 = "2. Explorador (Ágil rastreador de las ruinas)",
        class_3 = "3. Bárbaro (Fuerza bruta imparable)",

        supplies = "PREPARACIÓN PARA EL DESCENSO - Elige tus provisiones:",

        supply_1_name = "Runas Explosivas",
        supply_2_name = "Piedra de Afilar",
        supply_3_name = "Poción de Vida",

        supply_1 = "1. Runas Explosivas (Runas mágicas volátiles)",
        supply_2 = "2. Piedra de Afilar (Afila las armas)",
        supply_3 = "3. Poción de Vida (Restaura la salud)",

        attack = "Atacar",
        defend = "Defender",
        rune = "Runa",
        potion = "Poción",
        flee = "Huir",

        hp = "HP",
        atk = "ATQ",
        def = "DEF",
        tier = "NIVEL",

        defeated = "ENEMIGO DERROTADO",
        continue = "[ Continuar ]",

        camp = "CAMPAMENTO EN LAS PROFUNDIDADES - NIVEL ",
        camp_1 = "1. Descansar y curar heridas",
        camp_2 = "2. Afilar armas (Aumentar ataque)",
        camp_3 = "3. Descender al Nivel ",
        camp_4 = "4. Abandonar la empresa",

        victory = "¡HAS ESCAPADO DE KHOROS!",
        defeat = "TU CADÁVER YACE EN LAS PROFUNDIDADES...",
        exit_prompt = "[ Toca para salir ]",

        already_rest = "Ya has descansado en este campamento.",
        ya_descansaste = "Ya has descansado en este campamento.",
        rested = "Has descansado. Recuperaste ",
        descansaste_recuperaste = "Has descansado. Recuperaste ",
        rested_full = "Has descansado, pero ya tenías el HP completo.",
        descansaste_completo = "Has descansado, pero ya tenías el HP completo.",
        sharpened = "Has afilado tu arma. Ataque +",
        afilaste_arma = "Has afilado tu arma. Ataque +",
        no_whetstones = "No tienes piedras de afilar.",
        no_piedras_afilar = "No tienes piedras de afilar.",
        fled = "Huiste del combate.",

        loot_potion = "Poción de Vida",
        loot_whetstone = "Piedra de Afilar",
        loot_rune = "Runa Explosiva",

        no_loot = "No encontraste ningún objeto.",

        boss_name = "EL BRUJO DE LAS CADENAS",

        enemy_rat = "Rata de Alcantarilla",
        enemy_zombie = "Zombie Hambriento",
        enemy_kobold = "Kobold Astuto",
        enemy_spider = "Araña de Cueva",
        enemy_skeleton = "Guerrero Esqueleto",
        enemy_goblin = "Saqueador Goblin",
        enemy_orc = "Orco Furioso",
        enemy_jelly = "Gelatina Ocre",
        enemy_mimic = "Mímico Traicionero",
        enemy_gargoyle = "Gárgola de Piedra",
        enemy_cultist = "Cultista de la Muerte",
        enemy_ogre = "Ogro Aplastante",
        enemy_shadow = "Sombra Acechante",
        enemy_minotaur = "Minotauro del Laberinto",
        enemy_wraith = "Espectro de las Profundidades",
        enemy_golem = "Gólem de Hierro",
        enemy_mummy = "Señor de las Momias",
        enemy_incubus = "Íncubo Tormentoso",
        enemy_succubus = "Súcubo Seductor",
        enemy_vampire = "Vampiro Sediento",
        enemy_archmage = "Gran Archimago"
    },

    pt = {
        -- ==========================================
        -- MENÚ DE PAUSA / OPCIONES GLOBALES
        -- ==========================================
        exit_game = "Sair do Jogo",
        resume_game = "Voltar ao Jogo",
        fullscreen_on = "Tela Cheia: SIM",
        fullscreen_off = "Tela Cheia: NÃO",
        language_label = "Idioma: Português",
        menu = "Menu",

        -- ==========================================
        -- RESTO DEL JUEGO
        -- ==========================================
        new_record = "Novo Recorde!",
        enter_name = "Digite seu nome (máx. 16 caracteres):",
        save_record = "Salvar Recorde",
        cancel = "Cancelar",

        play_btn = "JOGAR",
        records_btn = "VER RECORDES",
        records_title = "MELHORES RECORDES",
        no_records = "Ainda não há recordes registrados.",
        back = "VOLTAR",

        record_display = "Recorde: Tier %d - Luta %d/3",
        record_victory = "Recorde: Tier 7 (Chefe Final alcançado/superado)!",

        loot_found = "Você encontrou: ",

        title = "BAUTISMO PROFANO",
        press_enter = "[ Toque para Começar ]",

        arsenal = "MERCADO DE AÇO - Escolha sua Classe:",

        class_1_name = "Guerreiro",
        class_1_desc = "Combatente equilibrado em aço pesado",

        class_2_name = "Explorador",
        class_2_desc = "Ágil rastreador das ruínas",

        class_3_name = "Bárbaro",
        class_3_desc = "Força bruta imparável",

        class_1 = "1. Guerreiro (Combatente equilibrado em aço pesado)",
        class_2 = "2. Explorador (Ágil rastreador das ruínas)",
        class_3 = "3. Bárbaro (Força bruta imparável)",

        supplies = "PREPARAÇÃO PARA A DESCIDA - Escolha seus suprimentos:",

        supply_1_name = "Runas Explosivas",
        supply_2_name = "Pedra de Amolar",
        supply_3_name = "Poção de Vida",

        supply_1 = "1. Runas Explosivas (Runas mágicas voláteis)",
        supply_2 = "2. Pedra de Amolar (Afia as armas)",
        supply_3 = "3. Poção de Vida (Restaura a saúde)",

        attack = "Atacar",
        defend = "Defender",
        rune = "Runa",
        potion = "Poção",
        flee = "Fugir",

        hp = "HP",
        atk = "ATQ",
        def = "DEF",
        tier = "NÍVEL",

        defeated = "INIMIGO DERROTADO",
        continue = "[ Continuar ]",

        camp = "ACAMPAMENTO NAS PROFUNDEZAS - NÍVEL ",
        camp_1 = "1. Descansar e curar ferimentos",
        camp_2 = "2. Amolar armas (Aumentar ataque)",
        camp_3 = "3. Descer para o Nível ",
        camp_4 = "4. Abandonar a empreitada",

        victory = "VOCÊ ESCAPOU DE KHOROS!",
        defeat = "SEU CADÁVER JAZ NAS PROFUNDEZAS...",
        exit_prompt = "[ Toque para sair ]",

        already_rest = "Você já descansou neste acampamento.",
        rested = "Você descansou. Recuperou ",
        rested_full = "Você descansou, mas seu HP já estava completo.",
        sharpened = "Você afiou sua arma. Ataque +",
        no_whetstones = "Você não possui pedras de amolar.",
        fled = "Você fugiu da batalha.",

        loot_potion = "Poção de Vida",
        loot_whetstone = "Pedra de Amolar",
        loot_rune = "Runa Explosiva",

        no_loot = "Você não encontrou nenhum item.",

        boss_name = "O BRUXO DAS CORRENTES",

        enemy_rat = "Rato de Esgoto",
        enemy_zombie = "Zumbi Faminto",
        enemy_kobold = "Kobold Astuto",
        enemy_spider = "Aranha da Caverna",
        enemy_skeleton = "Guerreiro Esqueleto",
        enemy_goblin = "Goblin Saqueador",
        enemy_orc = "Orc Furioso",
        enemy_jelly = "Geleia Ocre",
        enemy_mimic = "Mímico Traiçoeiro",
        enemy_gargoyle = "Gárgula de Pedra",
        enemy_cultist = "Cultista da Muerte",
        enemy_ogre = "Ogro Esmagador",
        enemy_shadow = "Sombra Perseguidora",
        enemy_minotaur = "Minotauro do Labirinto",
        enemy_wraith = "Espectro da Montanha",
        enemy_golem = "Golem de Ferro",
        enemy_mummy = "Senhor das Múmias",
        enemy_incubus = "Íncubo Tormentoso",
        enemy_succubus = "Súcuba Sedutora",
        enemy_vampire = "Vampiro Sedento",
        enemy_archmage = "Grande Arquimago"
    }
}

function i18n.get(key)
    if not key then
        return ""
    end

    local language = i18n.translations[i18n.current_lang]

    if not language then
        language = i18n.translations.es
    end

    local value = language[key]

    if value then
        return value
    end

    local fallback = i18n.translations.es[key]

    if fallback then
        return fallback
    end

    return ""
end

function i18n.toggle_lang()
    if i18n.current_lang == "en" then
        i18n.current_lang = "es"
    elseif i18n.current_lang == "es" then
        i18n.current_lang = "pt"
    else
        i18n.current_lang = "en"
    end
end

return i18n
