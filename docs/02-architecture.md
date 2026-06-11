# Arquitectura

> [[01-setup|← Setup del Proyecto]] | [[docs/README|Índice]] | [[03-atomic-design|Siguiente: Atomic Design →]]

 ## Clean Architecture

El proyecto se organiza en un workspace Dart con tres módulos:

### `packages/pinapp_dart_api` (Data + Domain)

Sigue el patrón **by_feature**: cada feature (posts, comments, likes) agrupa su modelo, repositorio, provider y use cases.

```
lib/
└── by_feature/
    ├── posts/
    │   ├── models/post_model.dart         # PostModel (Equatable + fromJson/toJson)
    │   └── data/
    │       ├── repository/post_repository.dart  # Abstracción
    │       ├── provider/post_provider.dart      # Implementación (HTTP)
    │       └── usecase/get_posts_usecase.dart   # Orquesta PostRepository + LikeRepository
    ├── comments/
    │   ├── models/comment_model.dart
    │   └── data/
    │       ├── repository/comment_repository.dart
    │       ├── provider/comment_provider.dart   # Implementación (Platform Channel)
    │       └── usecase/get_comments_usecase.dart
    └── likes/
        └── data/
            ├── repository/like_repository.dart
            ├── provider/like_provider.dart      # Implementación (SharedPreferences)
            └── usecase/
                ├── get_liked_posts_usecase.dart
                └── toggle_like_usecase.dart
```

### `packages/pinapp_material_ui` (UI Kit)

Contiene colores, tema, componentes UI reutilizables organizados por Atomic Design:

```
lib/
├── constants/colors.dart       # Paleta de colores
├── theme/app_theme.dart        # ThemeData Material 3
├── models/
│   ├── post_item_data.dart     # Data class para PostList/PostCard
│   └── comment_item_data.dart  # Data class para PostDetail/CommentTile
├── ui/
│   ├── atoms/                  # Componentes básicos (Text, Button, Icon)
│   ├── molecules/              # Combinación de átomos (PostCard, SearchBar, CommentTile)
│   ├── organisms/              # Secciones de UI (PostList, PostDetail) — parametrizados
│   └── templates/              # Layouts de página (HomeTemplate, DetailTemplate) — parametrizados
└── pinapp_material_ui.dart     # Barrel export
```

Organisms y templates están completamente parametrizados (no dependen de BLoCs). Reciben datos y callbacks desde las Pages a través de Inversión de Dependencias.

### `lib/` (App Shell)

Solo contiene BLoCs y las Pages que conectan BLoCs con los templates/organisms del package:

```
lib/
├── presentation/
│   ├── blocs/        # PostBloc, CommentBloc, LikeCubit
│   └── ui/pages/     # HomePage, DetailPage (conectan BLoCs → templates)
└── main.dart
```

## Provider Pattern

Los providers son la implementación única de cada repositorio (fusionan datasource + repository_impl). Se instancian directamente en `main.dart`:

```dart
final postRepository = PostProvider();        // extends PostRepository
final commentRepository = CommentProvider();  // extends CommentRepository
final likeRepository = LikeProvider();        // extends LikeRepository
```

## UseCases

Cada UseCase ejecuta una operación de negocio. Los UseCases orquestan repositorios:

- **`GetPostsUseCase(postRepo, likeRepo)`** — Obtiene posts desde HTTP y mergea `isLiked` desde SharedPreferences vía `copyWith`
- **`GetCommentsUseCase(commentRepo)`** — Obtiene comentarios desde Platform Channel
- **`GetLikedPostsUseCase(likeRepo)`** — Obtiene set de IDs likeados
- **`ToggleLikeUseCase(likeRepo)`** — Togglea el like de un post

## Models como Objetos de Dominio

No hay separación Entity/Model. `PostModel` y `CommentModel` son Equatable con `fromJson`/`toJson` y se usan en toda la app. `PostModel` incluye `isLiked` y `copyWith` para el merge.

## Flujo de Datos

```
UI → BLoC → UseCase → Repository (abstraction) → Provider (implementation) → API/Local/Native
UI ← BLoC ← UseCase ← Repository (abstraction) ← Provider (implementation) ← API/Local/Native
```

### Ejemplo: Listado de Posts con Likes

```
1. HomePage → PostBloc.add(PostFetched)
2. PostBloc → GetPostsUseCase.execute()
3. GetPostsUseCase → PostRepository.getPosts() (HTTP)
4. GetPostsUseCase → LikeRepository.getLikedPosts() (SharedPreferences)
5. GetPostsUseCase → mergea isLiked vía copyWith → devuelve List<PostModel>
6. PostBloc → emite PostLoaded(posts, filteredPosts)
7. HomeTemplate → renderiza PostList → PostCard
```

## Diagrama de Capas

```
┌─────────────────────────────────────────────────────────┐
│                    PinApp (root)                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │                  Presentation                      │  │
│  │  ┌───────────┐  ┌────────────────────────┐        │  │
│  │  │   BLoC    │  │  Pages (Home/Detail)   │        │  │
│  │  └───────────┘  └──────────┬─────────────┘        │  │
│  │              │ injecta datos y callbacks           │  │
│  └──────────────┼──────────────────────────────────────┘  │
│                 │ depends on                              │
│  ┌──────────────┴──────────────────────────────────────┐  │
│  │              pinapp_material_ui (package)           │  │
│  │  ┌──────────┐  ┌────────────────────────────────┐  │  │
│  │  │ Constants│  │  UI (atoms → molecules →       │  │  │
│  │  │ Theme    │  │       organisms → templates)   │  │  │
│  │  │ Models   │  │  (parametrizados, sin BLoC)    │  │  │
│  │  └──────────┘  └────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────────────┘  │
│                 │ depends on                              │
│  ┌──────────────┴──────────────────────────────────────┐  │
│  │              pinapp_dart_api (package)              │  │
│  │  by_feature/posts/   by_feature/comments/          │  │
│  │  by_feature/likes/   Core (API/Channel)            │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Platform Channels

Los comentarios se obtienen a través de MethodChannel dentro del package `pinapp_dart_api`. Ver detalles en [[04-platform-channels|Platform Channels]].

- **Package**: `packages/pinapp_dart_api/lib/core/comments_channel.dart`
- **Channel**: `com.pinapp.comments`
- **Método**: `getComments`
- **iOS**: `AppDelegate.swift`
- **Android**: `MainActivity.kt`

---

## Referencias

- [[01-setup|Setup del Proyecto]]
- [[03-atomic-design|Atomic Design]]
- [[04-platform-channels|Platform Channels]]
- [[05-testing|Testing]]
