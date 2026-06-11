# PinApp Posts

> 📱 **Prueba Técnica - Mobile Developer Flutter**
> 
> Aplicación Flutter que muestra un listado de posts con buscador, detalle de comentarios obtenidos desde plataforma nativa (Swift/Kotlin), y funcionalidad de likes.

## 📋 Descripción del Proyecto

Desarrollar una aplicación Flutter que muestre un listado de posts con un buscador en la parte superior que permita filtrarlo. Al hacer tap en uno de los posts, se debe abrir una pantalla de detalle que muestre los comentarios asociados a ese post. Esta pantalla de detalle también permite al usuario darle like a un post, este valor se debe reflejar en cada ítem del listado de posts.

## ✨ Funcionalidades

- **Listado de Posts**: Muestra todos los posts obtenidos desde la API
- **Buscador**: Permite filtrar posts por título o contenido en tiempo real
- **Detalle de Post**: Muestra el contenido completo del post y sus comentarios
- **Comentarios**: Obtenidos desde plataforma nativa (iOS Swift / Android Kotlin)
- **Likes**: Persistencia local con SharedPreferences, se reflejan en tiempo real
- **Pull to Refresh**: Actualiza la lista de posts deslizando hacia abajo

## 🏗️ Arquitectura

Monorepo con **Pub Workspace** que separa data/domain en un package independiente:

```
PinApp/
├── packages/
│   └── pinapp_dart_api/    # API client (data + domain layers, by_feature)
├── lib/                     # UI + BLoCs (presentación solamente)
├── docs/                    # Documentación detallada
└── pubspec.yaml             # Root workspace
```

### Capas del Package (`pinapp_dart_api`)
- **Models**: `PostModel`, `CommentModel` (Equatable + fromJson/toJson)
- **Repositories**: Abstracciones con providers como implementación única
- **UseCases**: Orquestan repositorios (GetPostsUseCase, GetCommentsUseCase, ToggleLikeUseCase, GetLikedPostsUseCase)

### State Management
- **BLoC** (flutter_bloc) para gestión compleja de estado
- **Cubit** para casos simples (likes)
- **UseCases** para orquestar lógica de negocio

### UI Layer - Atomic Design
```
lib/presentation/ui/
├── atoms/         # Componentes básicos (Text, Button, Icon)
├── molecules/     # Combinación de átomos (PostCard, SearchBar, CommentTile)
├── organisms/     # Secciones de UI (PostList, PostDetail)
├── templates/     # Layouts de página (HomeTemplate, DetailTemplate)
└── pages/         # Pantallas completas (HomePage, DetailPage)
```

> 📚 **Documentación detallada**: Ver carpeta `docs/` para guías completas sobre cada parte del proyecto.

## 📦 Dependencias

### Root (Presentación)
```yaml
dependencies:
  flutter_bloc: ^8.1.6      # State management
  pinapp_dart_api:           # API client (path dependency)
  cupertino_icons: ^1.0.8   # iOS style icons
```

### Package `pinapp_dart_api` (Data + Domain)
```yaml
dependencies:
  http: ^1.2.0               # HTTP client para posts
  shared_preferences: ^2.3.5 # Local storage (likes)
  equatable: ^2.0.7          # Equality utilities

dev_dependencies:
  mocktail: ^1.0.4           # Mocking
  bloc_test: ^9.1.7          # BLoC testing
```

## 🌐 Recursos de API

- **Posts**: `https://jsonplaceholder.typicode.com/posts`
- **Comments**: `https://jsonplaceholder.typicode.com/comments?postId={id}`

## 🔧 Implementación

### Platform Channels

Los comentarios se obtienen desde código nativo usando Flutter Platform Channels, dentro del package `pinapp_dart_api`:

- **Channel**: `com.pinapp.comments`
- **Method**: `getComments`
- **Arguments**: `{"postId": int}`
- **Return**: `JSON String` (List of comments)

### Flujo de Datos

```
Flutter App (root)
  → BLoC
    → UseCase (orquesta repositorios)
      → Provider (implementación)
        → PostProvider: HTTP → jsonplaceholder (posts)
        → CommentProvider: MethodChannel → Swift/Kotlin → jsonplaceholder (comments)
        → LikeProvider: SharedPreferences (likes)
```

## 🎨 Estilo Visual

- **Paleta**: Colores PinApp (azul marino, rojo, turquesa)
- **Theme**: Material 3 con colores custom
- **Tipografía**: Inter/Roboto, pesos regulares
- **Cards**: Con sombra suave, bordes redondeados
- **AppBar**: Azul marino con texto blanco
- **Estados**: Iconos y colores intuitivos

## 🧪 Testing

### Tests Implementados

- **UseCase Tests**: GetPostsUseCase
- **BLoC Tests**: PostBloc (con mocks de UseCases)
- **Widget Tests**: PostCard, CommentTile
- **Smoke Test**: App renders HomePage

### Ejecución de Tests

```bash
# Todos los tests (root + package)
flutter test

# Tests específicos
flutter test test/presentation/bloc/post_bloc_test.dart

# Tests del package
cd packages/pinapp_dart_api && flutter test

# Coverage
flutter test --coverage
```

## 📁 Estructura del Proyecto

```
PinApp/
├── packages/
│   └── pinapp_dart_api/
│       ├── lib/
│       │   ├── core/
│       │   │   ├── api_constants.dart
│       │   │   └── comments_channel.dart
│       │   ├── by_feature/
│       │   │   ├── posts/
│       │   │   │   ├── models/post_model.dart
│       │   │   │   └── data/
│       │   │   │       ├── repository/post_repository.dart
│       │   │   │       ├── provider/post_provider.dart
│       │   │   │       └── usecase/get_posts_usecase.dart
│       │   │   ├── comments/
│       │   │   │   ├── models/comment_model.dart
│       │   │   │   └── data/
│       │   │   │       ├── repository/comment_repository.dart
│       │   │   │       ├── provider/comment_provider.dart
│       │   │   │       └── usecase/get_comments_usecase.dart
│       │   │   └── likes/
│       │   │       └── data/
│       │   │           ├── repository/like_repository.dart
│       │   │           ├── provider/like_provider.dart
│       │   │           ├── usecase/get_liked_posts_usecase.dart
│       │   │           └── usecase/toggle_like_usecase.dart
│       │   └── pinapp_dart_api.dart
│       └── pubspec.yaml
├── android/
│   └── app/src/main/kotlin/.../MainActivity.kt
├── ios/
│   └── Runner/AppDelegate.swift
├── lib/
│   ├── core/
│   │   ├── constants/colors.dart
│   │   └── theme/app_theme.dart
│   ├── presentation/
│   │   ├── blocs/
│   │   │   ├── post_bloc/
│   │   │   │   ├── post_bloc.dart
│   │   │   │   ├── post_event.dart
│   │   │   │   └── post_state.dart
│   │   │   ├── comment_bloc/
│   │   │   │   ├── comment_bloc.dart
│   │   │   │   ├── comment_event.dart
│   │   │   │   └── comment_state.dart
│   │   │   └── like_cubit/
│   │   │       ├── like_cubit.dart
│   │   │       └── like_state.dart
│   │   └── ui/
│   │       ├── atoms/
│   │       │   ├── pin_app_text.dart
│   │       │   ├── pin_app_button.dart
│   │       │   ├── like_icon.dart
│   │       │   ├── search_input.dart
│   │       │   └── badge_count.dart
│   │       ├── molecules/
│   │       │   ├── post_card.dart
│   │       │   ├── search_bar.dart
│   │       │   ├── comment_tile.dart
│   │       │   └── like_button.dart
│   │       ├── organisms/
│   │       │   ├── post_list.dart
│   │       │   └── post_detail.dart
│   │       ├── templates/
│   │       │   ├── home_template.dart
│   │       │   └── detail_template.dart
│   │       └── pages/
│   │           ├── home_page.dart
│   │           └── detail_page.dart
│   └── main.dart
├── test/
│   ├── data/
│   │   └── post_repository_impl_test.dart
│   ├── presentation/
│   │   ├── bloc/
│   │   │   └── post_bloc_test.dart
│   │   └── widgets/
│   │       ├── post_card_test.dart
│   │       └── comment_tile_test.dart
│   └── widget_test.dart
├── docs/
│   ├── README.md
│   ├── 01-setup.md
│   ├── 02-architecture.md
│   ├── 03-atomic-design.md
│   ├── 04-platform-channels.md
│   └── 05-testing.md
├── AGENTS.md
├── pubspec.yaml
└── README.md
```

## 📚 Documentación

La documentación completa se encuentra en la carpeta `docs/`:

- **[docs/README.md](docs/README.md)** - Índice y overview de la documentación
- **[docs/01-setup.md](docs/01-setup.md)** - Requisitos, instalación y dependencias
- **[docs/02-architecture.md](docs/02-architecture.md)** - Arquitectura Clean, BLoC, UseCases, flujo de datos
- **[docs/03-atomic-design.md](docs/03-atomic-design.md)** - Metodología Atomic Design
- **[docs/04-platform-channels.md](docs/04-platform-channels.md)** - Comunicación nativa Swift/Kotlin
- **[docs/05-testing.md](docs/05-testing.md)** - Estrategia y ejemplos de testing

> 💡 **Tip**: Si usas Obsidian, abre la carpeta `docs/` como vault para navegar con wikilinks.

## ⚙️ Requisitos

- Flutter SDK ^3.6.1
- Dart SDK ^3.6.1
- Android Studio (para Android)
- Xcode (para iOS)

## 🚀 Instalación

1. Clonar el repositorio
2. Ejecutar `flutter pub get` (resuelve workspace + package simultáneamente)
3. Ejecutar `flutter run` (Android o iOS)

## ✅ Entregables

- ✅ Código fuente completo
- ✅ Implementación de platform channels (iOS Swift + Android Kotlin)
- ✅ Tests unitarios y de widgets
- ✅ README detallado
- ✅ Documentación en carpeta `docs/`

## 📝 Notas

- Si el candidato no cuenta con las herramientas para compilar la app en alguna de las plataformas, puede igualmente implementar la funcionalidad y dejarla disponible en el código del repositorio.
- El objetivo es evaluar cómo resuelve el desafío y cómo se maneja aplicando cambios en los proyectos nativos.
- Se valora la elección de patrones de diseño apropiados y la implementación de tests.

## 👨‍💻 Desarrollado por

**PinApp Challenge** - Mobile Developer Flutter

---

© 2026 PinApp. Todos los derechos reservados.
