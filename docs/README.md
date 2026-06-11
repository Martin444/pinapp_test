# PinApp Challenge - Documentación

> 📖 **Documentación completa del proyecto PinApp Posts**
> 
> Para volver al [README principal](../README.md), haz clic en el enlace.

## Índice

1. [Setup del Proyecto](01-setup.md) - Requisitos, instalación y dependencias
2. [Arquitectura](02-architecture.md) - Clean Architecture, BLoC y flujo de datos
3. [Atomic Design](03-atomic-design.md) - Metodología de diseño de componentes
4. [Platform Channels](04-platform-channels.md) - Comunicación con nativo (Swift/Kotlin)
5. [Testing](05-testing.md) - Estrategia y ejemplos de tests

## Obsidian

Si usas Obsidian, puedes navegar entre documentos usando los wikilinks:
- `[[01-setup]]` → Setup del Proyecto
- `[[02-architecture]]` → Arquitectura
- `[[03-atomic-design]]` → Atomic Design
- `[[04-platform-channels]]` → Platform Channels
- `[[05-testing]]` → Testing

## Overview

Aplicación Flutter que muestra un listado de posts con buscador, detalle de comentarios obtenidos desde nativo (Swift/Kotlin), y funcionalidad de likes.

La app sigue una arquitectura limpia (Clean Architecture) con tres capas principales: [Domain](02-architecture.md), [Data](02-architecture.md) y [Presentation](02-architecture.md), usando BLoC para la gestión de estado y [Atomic Design](03-atomic-design.md) para la organización de la UI.

## Tecnologías
- Flutter 3.x
- Dart 3.x
- BLoC (flutter_bloc)
- HTTP (http)
- SharedPreferences
- Platform Channels

## Estructura del Proyecto

```
lib/
├── core/          # Theme, constants, platform channels
├── data/          # Models, datasources, repositories
├── domain/        # Entities, repository abstractions
├── presentation/  # Blocs + Atomic Design UI
└── main.dart
```

## Recursos de API
- Posts: https://jsonplaceholder.typicode.com/posts
- Comments: https://jsonplaceholder.typicode.com/comments?postId={id}

---

> 💡 **Tip**: Navega entre documentos usando los enlaces de Markdown o los wikilinks de Obsidian.
