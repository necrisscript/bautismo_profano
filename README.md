# 🩸 Bautismo Profano

> Un juego de combate táctico oscuro desarrollado con LÖVE2D y Lua, diseñado para jugarse en pantallas táctiles y con ratón.

![Gameplay de Bautismo Profano](https://raw.githubusercontent.com/necrisscript/bautismo_profano/main/docs/screenshot.png)

---

## 🚀 Descargas

Puedes descargar la última versión desde la sección de [Releases](https://github.com/necrisscript/bautismo_profano/releases/latest).

### v0.2.0

- **Linux:** `bautismo_profano-linux.AppImage`  
  Dale permisos de ejecución antes de iniciarlo:

  ```bash
  chmod +x bautismo_profano-linux.AppImage
  ./bautismo_profano-linux.AppImage
  ```

- **Windows:** `bautismo_profano.exe`  
  Ejecutable independiente, no requiere instalación.

- **LÖVE / Android:** `bautismo_profano.love`  
  Archivo compatible con aplicaciones que utilicen el framework LÖVE para Android.

---

## 📱 Ejecutar en Android

Para ejecutar el juego en Android:

1. Descarga el archivo `bautismo_profano.love` desde la sección de [Releases](https://github.com/necrisscript/bautismo_profano/releases/latest).
2. Instala una aplicación compatible con LÖVE para Android.
3. Abre el archivo `.love` con dicha aplicación.

El juego está diseñado para utilizar controles táctiles, por lo que no es necesario conectar un teclado o un ratón.

---

## ✨ Características

- Combate táctico por turnos.
- Enemigos con distintas intenciones y patrones de comportamiento.
- Sistema de ataque, defensa, pociones y runas.
- Progresión por plantas dentro de una mazmorra.
- Escalado dinámico de enemigos.
- Combate contra un jefe en la planta 7.
- Interfaz adaptada a pantallas táctiles.
- Soporte para español, inglés y portugués.
- Versiones disponibles para Linux, Windows y Android mediante LÖVE.

---

## ⚔️ Mecánicas principales

### Mitigación de defensa

El daño se calcula mediante una fórmula de reducción porcentual:

```text
daño = ataque × (100 / (100 + defensa))
```

Esta fórmula evita que los combates se alarguen indefinidamente a medida que aumenta la defensa.

### Intenciones enemigas

Los enemigos muestran su próximo movimiento, que puede ser:

- Ataque.
- Defensa.
- Uso de una poción.
- Activación de una runa.

Con esta información puedes anticiparte a sus acciones y planificar cada turno.

### Progresión de la mazmorra

Los enemigos se vuelven más fuertes a medida que avanzas por las plantas. Sus estadísticas se ajustan mediante multiplicadores de dificultad hasta llegar al combate contra el jefe de la planta 7.

---

## 🎮 Controles

| Acción | Entrada |
| --- | --- |
| Seleccionar o interactuar | Clic izquierdo / Toque |
| Atacar o usar una habilidad | Arrastrar y soltar / Clic |
| Abrir el menú o pausar | Botón en pantalla |

---

## 🛠️ Arquitectura del proyecto

El proyecto está organizado de forma modular utilizando LÖVE2D. La configuración global, el bucle principal, la lógica de combate, los datos estáticos, la gestión de entidades y la interfaz de usuario están separados en distintos módulos:

```text
.
├── assets/                  # Recursos visuales: sprites, iconos y fondos
├── conf.lua                 # Configuración de la ventana y del motor LÖVE2D
├── docs/
│   └── screenshot.png       # Captura de pantalla del juego
├── main.lua                 # Punto de entrada y bucle principal
└── src/
    ├── data.lua             # Clases, suministros y enemigos por planta
    ├── entities.lua         # Entidades base y metatablas
    ├── i18n.lua             # Sistema de internacionalización: ES / EN / PT
    ├── logic.lua            # Batallas, turnos, daño, IA y botín
    └── ui.lua               # Renderizado, menús e interfaz táctil
```

---

## ⚙️ Instalación y ejecución desde el código fuente

Si prefieres ejecutar el juego desde el código fuente:

1. Instala [LÖVE2D](https://love2d.org/).
2. Clona el repositorio:

   ```bash
   git clone https://github.com/necrisscript/bautismo_profano.git
   cd bautismo_profano
   ```

3. Ejecuta el juego arrastrando la carpeta raíz sobre el ejecutable de LÖVE o desde una terminal:

   ```bash
   love .
   ```

También puedes empaquetar el proyecto como un archivo `.love` desde la raíz del repositorio:

```bash
zip -9 -r bautismo_profano.love . -x "*.git*" "docs/*"
```

---

## 🌍 Localización

El juego está disponible en los siguientes idiomas:

- Español.
- Inglés.
- Portugués.

---

## 📜 Licencia

- **Código fuente:** [Licencia MIT](https://github.com/necrisscript/bautismo_profano/blob/main/LICENSE).
- **Recursos:** generados mediante IA y disponibles para su uso dentro de este proyecto.
```

Corregí también el enlace de la licencia: el original pasaba por una búsqueda de Google en lugar de enlazar directamente al archivo `LICENSE` del repositorio.
