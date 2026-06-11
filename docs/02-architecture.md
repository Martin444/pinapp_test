# Arquitectura

> [[01-setup|← Setup del Proyecto]] | [[docs/README|Índice]] | [[03-atomic-design|Siguiente: Atomic Design →]]

## Clean Architecture

El proyecto sigue los principios de Clean Architecture con tres capas principales:

### Domain (Centro)
- **Entities**: Modelos de negocio puros (`[[../lib/domain/entities/post.dart|Post]]`, `[[../lib/domain/entities/comment.dart|Comment]]`)
- **Repository Abstractions**: Interfaces que definen contratos
- Esta capa no depende de ninguna otra

### Data (Exterior)
- **Models**: DTOs para serialización/deserialización (`[[../lib/data/models/post_model.dart|PostModel]]`, `[[../lib/data/models/comment_model.dart|CommentModel]]`)
- **Datasources**: Fuentes de datos
  - `[[../lib/data/datasources/posts_api.dart|PostsApi]]` - HTTP desde Flutter
  - `[[../lib/data/datasources/comments_channel.dart|CommentsChannel]]` - Platform Channel
  - `[[../lib/data/datasources/likes_local.dart|LikesLocal]]` - SharedPreferences
- **Repositories**: Implementaciones de las abstracciones del dominio

### Presentation (UI)
- **BLoC**: Gestión de estado ([[../lib/presentation/blocs/post_bloc/post_bloc.dart|PostBloc]], [[../lib/presentation/blocs/comment_bloc/comment_bloc.dart|CommentBloc]])
- **UI**: [[03-atomic-design|Atomic Design]] components

## Flujo de Datos

```
UI → BLoC → Repository → Datasource → API/Local/Native
UI ← BLoC ← Repository ← Datasource ← API/Local/Native
```

## Diagrama de Capas

```
┌─────────────────────────────────────┐
│           Presentation              │
│  ┌─────────┐  ┌─────────────────┐ │
│  │   BLoC  │  │  Atomic Design  │ │
│  └─────────┘  └─────────────────┘ │
├─────────────────────────────────────┤
│             Domain                  │
│  ┌─────────┐  ┌─────────────────┐ │
│  │ Entities│  │  Repositories   │ │
│  └─────────┘  └─────────────────┘ │
├─────────────────────────────────────┤
│              Data                   │
│  ┌─────────┐  ┌─────────────────┐ │
│  │  Models │  │  Datasources    │ │
│  └─────────┘  └─────────────────┘ │
│  ┌─────────────────────────────┐    │
│  │      Repositories Impl    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

## Inversión de Dependencias

Las capas superiores no dependen de las inferiores. El dominio define interfaces y la data las implementa.

## Platform Channels

Los comentarios se obtienen a través de MethodChannel, invocando código nativo. Ver detalles en [[04-platform-channels|Platform Channels]].

- **Flutter**: `MethodChannel.invokeMethod('getComments', {'postId': id})`
- **iOS**: `AppDelegate.swift` recibe la llamada, hace HTTP, devuelve resultado
- **Android**: `MainActivity.kt` recibe la llamada, hace HTTP, devuelve resultado

---

## Referencias

- [[01-setup|Setup del Proyecto]]
- [[03-atomic-design|Atomic Design]]
- [[04-platform-channels|Platform Channels]]
- [[05-testing|Testing]]
