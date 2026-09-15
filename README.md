# 🩸 Bautismo Profano

> Un juego de combate táctico y oscuro desarrollado con LÖVE2D y Lua, diseñado para pantallas táctiles y controles con ratón.

![Gameplay de Bautismo Profano](https://raw.githubusercontent.com/necrisscript/bautismo_profano/main/docs/screenshot.png)

---

## 🚀 Descargas (v0.2.0)

Descarga los binarios listos para usar desde [Releases](https://github.com/necrisscript/bautismo_profano/releases/latest):

* **Linux:** `bautismo_profano-linux.AppImage` — portable; dale permisos de ejecución para iniciarlo.
* **Windows:** `bautismo_profano.exe` — ejecutable independiente.

---

## 🛠️ Arquitectura del proyecto

El proyecto está estructurado de forma modular usando LÖVE2D. La configuración global, el bucle principal del juego, la lógica de combate, los datos estáticos, la gestión de entidades y la interfaz de usuario están claramente separados:

```text
.
├── assets/                  # Recursos visuales: sprites, iconos y fondos
├── conf.lua                 # Configuración de la ventana y del motor LÖVE2D
├── docs/
│   └── screenshot.png       # Captura de pantalla del juego
├── main.lua                 # Punto de entrada y bucle principal del juego
└── src/
    ├── data.lua             # Catálogo de clases, suministros y enemigos por planta
    ├── entities.lua         # Definiciones base de entidades y metatablas
    ├── i18n.lua             # Sistema de internacionalización: ES / EN / PT
    ├── logic.lua            # Gestión de batallas, turnos, fórmulas de daño, IA y botín
    └── ui.lua               # Renderizado, menús y diseño de interfaz táctil
```

---

## ⚔️ Mecánicas principales

* **Mitigación de defensa:** el daño se calcula mediante una fórmula de reducción porcentual (`ataque * (100 / (100 + defensa))`) para evitar que los combates se estanquen.
* **Intenciones enemigas:** los enemigos muestran su próximo movimiento —ataque, defensa, poción o runa— para que puedas planificar tus tácticas.
* **Progresión de la mazmorra:** los enemigos escalan dinámicamente según la planta mediante multiplicadores, hasta llegar a un combate contra un jefe en la planta 7.

---

## 🎮 Controles

| Acción | Entrada |
| --- | --- |
| **Seleccionar / interactuar** | `Clic izquierdo` / `Toque` |
| **Atacar / usar habilidad** | `Arrastrar y soltar` / `Clic` |
| **Menú / pausa** | Botón en pantalla |

---

## ⚙️ Instalación y ejecución

Si prefieres ejecutar el juego desde el código fuente en lugar de utilizar los binarios precompilados:

1. Instala el framework [LÖVE (Love2D)](https://love2d.org/).
2. Clona el repositorio:

```bash
git clone https://github.com/necrisscript/bautismo_profano.git
```

3. Ejecuta el juego arrastrando la carpeta raíz sobre el ejecutable de LÖVE o desde la terminal:

```bash
love .
```

---

## 📜 Licencia

* **Código fuente:** [Licencia MIT](https://www.google.com/search?q=https://github.com/necrisscript/bautismo_profano/blob/main/LICENSE).
* **Recursos:** generados mediante IA y disponibles para usarse en este proyecto.
