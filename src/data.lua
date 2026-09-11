local Data = {}

-- ==========================================================
-- CLASES
-- ==========================================================

Data.classes = {
    warrior = {
        name_key = "class_1_name",
        description_key = "class_1_desc",
        hp = 150,
        ataque = 14,
        defensa = 13,
        afilado_bonus = 10
    },

    explorer = {
        name_key = "class_2_name",
        description_key = "class_2_desc",
        hp = 150,
        ataque = 20,
        defensa = 4,
        afilado_bonus = 10
    },

    barbarian = {
        name_key = "class_3_name",
        description_key = "class_3_desc",
        hp = 150,
        ataque = 34,
        defensa = 2,
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
-- ENEMIGOS
-- ==========================================================

Data.enemies = {

    [1] = {
        {
            name_key = "enemy_rat",
            sprite = "rat",
            hp = 25,
            atk = 8,
            def = 4
        },

        {
            name_key = "enemy_zombie",
            sprite = "zombie",
            hp = 40,
            atk = 10,
            def = 5
        },

        {
            name_key = "enemy_kobold",
            sprite = "kobold",
            hp = 20,
            atk = 12,
            def = 6
        }
    },

    [2] = {
        {
            name_key = "enemy_spider",
            sprite = "spider",
            hp = 50,
            atk = 14,
            def = 7
        },

        {
            name_key = "enemy_skeleton",
            sprite = "skeleton",
            hp = 60,
            atk = 16,
            def = 4
        },

        {
            name_key = "enemy_goblin",
            sprite = "goblin",
            hp = 45,
            atk = 18,
            def = 9
        }
    },

    [3] = {
        {
            name_key = "enemy_orc",
            sprite = "orc",
            hp = 80,
            atk = 22,
            def = 11
        },

        {
            name_key = "enemy_jelly",
            sprite = "jelly",
            hp = 100,
            atk = 20,
            def = 10
        },

        {
            name_key = "enemy_mimic",
            sprite = "mimic",
            hp = 85,
            atk = 24,
            def = 12
        }
    },

    [4] = {
        {
            name_key = "enemy_gargoyle",
            sprite = "gargoyle",
            hp = 110,
            atk = 28,
            def = 16
        },

        {
            name_key = "enemy_cultist",
            sprite = "cultist",
            hp = 90,
            atk = 32,
            def = 16
        },

        {
            name_key = "enemy_ogre",
            sprite = "ogre",
            hp = 140,
            atk = 30,
            def = 15
        }
    },

    [5] = {
        {
            name_key = "enemy_shadow",
            sprite = "wraith",
            hp = 130,
            atk = 40,
            def = 20
        },

        {
            name_key = "enemy_minotaur",
            sprite = "minotaur",
            hp = 200,
            atk = 45,
            def = 25
        },

        {
            name_key = "enemy_wraith",
            sprite = "wraith",
            hp = 140,
            atk = 48,
            def = 24
        }
    },

    [6] = {
        {
            name_key = "enemy_incubus",
            sprite = "incubus",
            hp = 280,
            atk = 55,
            def = 30
        },

        {
            name_key = "enemy_succubus",
            sprite = "succubus",
            hp = 230,
            atk = 60,
            def = 12
        },

        {
            name_key = "enemy_vampire",
            sprite = "vampire",
            hp = 250,
            atk = 65,
            def = 30
        }
    },

    [7] = {
        {
            name_key = "enemy_archmage",
            sprite = "archmage",
            hp = 550,
            atk = 85,
            def = 40,
            boss = true
        }
    }
}

return Data
