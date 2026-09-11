# 🩸 Bautismo Profano

> A dark, tactical combat game developed using LÖVE2D and Lua, designed for touch screens and mouse controls.

![Bautismo Profano Gameplay](https://raw.githubusercontent.com/necrisscript/bautismo_profano/main/docs/screenshot.png)

---

## 🚀 Downloads (v0.1.0)

Grab ready-to-run binaries from [Releases](https://github.com/necrisscript/bautismo_profano/releases/latest):

* **Linux:** `bautismo_profano-linux.AppImage` (portable, grant execute permission to run)
* **Windows:** `bautismo_profano.exe` (standalone executable)

---

## 🛠️ Project Architecture

The project is modularly structured using LÖVE2D, clearly separating global configuration, the main game loop, combat logic, static data, entity management, and the user interface:

```text
.
├── assets/                  # Visual assets (sprites, icons, and backgrounds)
├── conf.lua                 # LÖVE2D window and engine configuration
├── docs/
│   └── screenshot.png       # Game preview screenshot
├── main.lua                 # Entry point and main game loop
└── src/
    ├── data.lua             # Catalog of player classes, supplies, and floor-based enemies
    ├── entities.lua         # Base class definitions (Entity, Player, Enemy) and metatables
    ├── i18n.lua             # Internationalization system (ES / EN / PT)
    ├── logic.lua            # BattleManager, turn loops, damage formulas, AI intent, and loot
    └── ui.lua               # Screen rendering, menus, and touch-friendly UI layout
```

---

## ⚔️ Key Mechanics

* **Defense Mitigation:** Damage scales smoothly using a percentage reduction formula (attack * (100 / (100 + defense))) to prevent combat stagnation.
* **Enemy Intent:** Enemies telegraph their next move (attack, defend, potion, or rune) so players can plan tactics.
* **Dungeon Progression:** Enemies scale dynamically by floor using multipliers, culminating in a boss battle on floor 7.

---

## 🎮 Controls

| Action | Input |
| --- | --- |
| **Select / Interact** | `Left Click` / `Tap` |
| **Attack / Use Skill** | `Drag & Release` / `Click` |
| **Menu / Pause** | On-screen Button |

---

## ⚙️ Installation & Execution

If you prefer running from source instead of using the precompiled binaries:

1. Install the [LÖVE (Love2D)](https://love2d.org/) framework.
2. Clone the repository:

```bash
git clone [https://github.com/necrisscript/bautismo_profano.git](https://github.com/necrisscript/bautismo_profano.git)
```

3. Run the game by dragging the root folder onto the LÖVE executable or via terminal:

```bash
love .
```

---

## 📜 License

* **Source Code:** [MIT License](https://www.google.com/search?q=https://github.com/necrisscript/bautismo_profano/blob/main/LICENSE).
* **Assets:** Generated via AI and free to use for this project.
