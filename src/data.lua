local Data = {}

-- ==========================================================
-- CLASES (Balanceadas con identidades de rol únicas)
-- ==========================================================

Data.classes = {
    warrior = {
        name_key = "class_1_name",
        description_key = "class_1_desc",
        hp = 140,
        ataque = 22,
        defensa = 28,
        afilado_bonus = 8
    },

    explorer = {
        name_key = "class_2_name",
        description_key = "class_2_desc",
        hp = 110,
        ataque = 26,
        defensa = 18,
        afilado_bonus = 12
    },

    barbarian = {
        name_key = "class_3_name",
        description_key = "class_3_desc",
        hp = 170,
        ataque = 32,
        defensa = 12,
        afilado_bonus = 15
    }
}

-- ==========================================================
-- PROVISIONES
-- ==========================================================

Data.supplies = {
    runes = {
        name_key = "supply_1_name"
    },

    whetstone = {
        name_key = "supply_2_name"
    },

    potion = {
        name_key = "supply_3_name"
    }
}

-- ==========================================================
-- ENEMIGOS (Progresión de poder equilibrada por pisos)
-- ==========================================================

Data.enemies = {

    [1] = {
        {
            name_key = "enemy_rat",
            sprite = "rat",
            hp = 25,
            atk = 9,
            def = 4
        },

        {
            name_key = "enemy_zombie",
            sprite = "zombie",
            hp = 38,
            atk = 11,
            def = 6
        },

        {
            name_key = "enemy_kobold",
            sprite = "kobold",
            hp = 22,
            atk = 13,
            def = 3
        }
    },

    [2] = {
        {
            name_key = "enemy_spider",
            sprite = "spider",
            hp = 45,
            atk = 16,
            def = 7
        },

        {
            name_key = "enemy_skeleton",
            sprite = "skeleton",
            hp = 52,
            atk = 18,
            def = 8
        },

        {
            name_key = "enemy_goblin",
            sprite = "goblin",
            hp = 40,
            atk = 20,
            def = 5
        }
    },

    [3] = {
        {
            name_key = "enemy_orc",
            sprite = "orc",
            hp = 75,
            atk = 25,
            def = 12
        },

        {
            name_key = "enemy_jelly",
            sprite = "jelly",
            hp = 90,
            atk = 22,
            def = 15
        },

        {
            name_key = "enemy_mimic",
            sprite = "mimic",
            hp = 68,
            atk = 28,
            def = 10
        }
    },

    [4] = {
        {
            name_key = "enemy_gargoyle",
            sprite = "gargoyle",
            hp = 100,
            atk = 32,
            def = 22
        },

        {
            name_key = "enemy_cultist",
            sprite = "cultist",
            hp = 82,
            atk = 36,
            def = 14
        },

        {
            name_key = "enemy_ogre",
            sprite = "ogre",
            hp = 125,
            atk = 34,
            def = 16
        }
    },

    [5] = {
        {
            name_key = "enemy_shadow",
            sprite = "wraith",
            hp = 115,
            atk = 42,
            def = 18
        },

        {
            name_key = "enemy_minotaur",
            sprite = "minotaur",
            hp = 160,
            atk = 46,
            def = 24
        },

        {
            name_key = "enemy_wraith",
            sprite = "wraith",
            hp = 120,
            atk = 50,
            def = 15
        }
    },

    [6] = {
        {
            name_key = "enemy_incubus",
            sprite = "incubus",
            hp = 210,
            atk = 58,
            def = 28
        },

        {
            name_key = "enemy_succubus",
            sprite = "succubus",
            hp = 185,
            atk = 64,
            def = 20
        },

        {
            name_key = "enemy_vampire",
            sprite = "vampire",
            hp = 200,
            atk = 68,
            def = 25
        }
    },

    [7] = {
        {
            name_key = "enemy_archmage",
            sprite = "archmage",
            hp = 420,
            atk = 80,
            def = 35,
            boss = true
        }
    }
}

return Data
