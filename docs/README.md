# PinApp Challenge - Documentación

> 📖 **Documentación completa del proyecto PinApp Posts**
> 
> Para volver al [README principal](../README.md), haz clic en el enlace.

## Índice

1. [Setup del Proyecto](01-setup.md) - Requisitos, instalación y dependencias
2. [Arquitectura](02-architecture.md) - Clean Architecture, BLoC, UseCases y flujo de datos
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

La app sigue Clean Architecture con un workspace Dart que separa data/domain en `pinapp_dart_api` y UI components en `pinapp_material_ui`, usando BLoC para la gestión de estado, UseCases para orquestar repositorios, y Atomic Design para la organización de la UI.

## Tecnologías
- Flutter 3.x / Dart 3.x
- Pub Workspace (monorepo)
- BLoC (flutter_bloc)
- HTTP (http)
- SharedPreferences
- Platform Channels (MethodChannel)

## Estructura del Proyecto

```
PinApp/
├── packages/
│   ├── pinapp_dart_api/      # API client (data + domain layers)
│   │   ├── lib/
│   │   │   ├── core/                    # API constants, CommentsChannel
│   │   │   ├── by_feature/
│   │   │   │   ├── posts/               # PostModel, PostRepository, PostProvider, GetPostsUseCase
│   │   │   │   ├── comments/            # CommentModel, CommentRepository, CommentProvider, GetCommentsUseCase
│   │   │   │   └── likes/               # LikeRepository, LikeProvider, GetLikedPostsUseCase, ToggleLikeUseCase
│   │   │   └── pinapp_dart_api.dart     # Barrel export
│   │   └── pubspec.yaml
│   └── pinapp_material_ui/  # UI components + theming
│       ├── lib/
│       │   ├── constants/               # Colores PinApp
│       │   ├── theme/                   # ThemeData Material 3
│       │   ├── models/                  # Data classes (PostItemData, CommentItemData)
│       │   ├── ui/atoms/                # Componentes básicos
│       │   ├── ui/molecules/            # Combinación de átomos
│       │   ├── ui/organisms/            # Secciones de UI parametrizadas
│       │   ├── ui/templates/            # Layouts de página parametrizados
│       │   └── pinapp_material_ui.dart  # Barrel export
│       └── pubspec.yaml
├── lib/
│   ├── presentation/blocs/   # BLoCs
│   ├── presentation/ui/pages/# Pages (conectan BLoCs → templates)
│   └── main.dart
├── pubspec.yaml              # Root workspace
└── docs/                     # Documentación
```

## Recursos de API
- Posts: https://jsonplaceholder.typicode.com/posts
- Comments: https://jsonplaceholder.typicode.com/comments?postId={id}

---

> 💡 **Tip**: Navega entre documentos usando los enlaces de Markdown o los wikilinks de Obsidian.
