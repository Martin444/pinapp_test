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

El proyecto sigue los principios de **Clean Architecture** con tres capas principales:

```
lib/
├── core/          # Theme, constants, platform channels
├── domain/        # Entities, repository abstractions
├── data/          # Models, datasources, repositories
├── presentation/  # Blocs + Atomic Design UI
└── main.dart
```

### State Management
- **BLoC** (flutter_bloc) para gestión compleja de estado
- **Cubit** para casos simples (likes)

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

```yaml
dependencies:
  flutter_bloc: ^8.1.6      # State management
  http: ^1.2.0               # HTTP client
  shared_preferences: ^2.3.5 # Local storage
  equatable: ^2.0.7          # Equality utilities
  cupertino_icons: ^1.0.8    # iOS style icons

dev_dependencies:
  bloc_test: ^9.1.7          # BLoC testing
  mocktail: ^1.0.4           # Mocking
  flutter_lints: ^5.0.0      # Linting
```

## 🌐 Recursos de API

- **Posts**: `https://jsonplaceholder.typicode.com/posts`
- **Comments**: `https://jsonplaceholder.typicode.com/comments?postId={id}`

## 🔧 Implementación

### Platform Channels

Los comentarios se obtienen desde código nativo usando Flutter Platform Channels:

- **Channel**: `com.pinapp.comments`
- **Method**: `getComments`
- **Arguments**: `{"postId": int}`
- **Return**: `JSON String` (List of comments)

### Flujo de Datos

```
Flutter App
  ├── HTTP Request → jsonplaceholder.typicode.com/posts (Posts)
  └── MethodChannel → com.pinapp.comments
       ├── iOS: Swift + URLSession
       └── Android: Kotlin + HttpURLConnection
            └── HTTP Request → jsonplaceholder.typicode.com/comments?postId={id}
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

- **Unit Tests**: Repositories, datasources
- **BLoC Tests**: PostBloc, CommentBloc, LikeCubit
- **Widget Tests**: PostCard, CommentTile, SearchBar

### Ejecución de Tests

```bash
# Todos los tests
flutter test

# Coverage
flutter test --coverage
```

## 📁 Estructura del Proyecto

```
pinapp_test/
├── android/
│   └── app/src/main/kotlin/.../MainActivity.kt
├── ios/
│   └── Runner/AppDelegate.swift
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── colors.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── platform/
│   │       └── comments_channel.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── post_model.dart
│   │   │   └── comment_model.dart
│   │   ├── datasources/
│   │   │   ├── posts_api.dart
│   │   │   ├── comments_channel.dart
│   │   │   └── likes_local.dart
│   │   └── repositories/
│   │       ├── post_repository_impl.dart
│   │       ├── comment_repository_impl.dart
│   │       └── like_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── post.dart
│   │   │   └── comment.dart
│   │   └── repositories/
│   │       ├── post_repository.dart
│   │       ├── comment_repository.dart
│   │       └── like_repository.dart
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
│   └── presentation/
│       ├── bloc/
│       │   └── post_bloc_test.dart
│       └── widgets/
│           ├── post_card_test.dart
│           └── comment_tile_test.dart
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
- **[docs/02-architecture.md](docs/02-architecture.md)** - Arquitectura Clean, BLoC, flujo de datos
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
2. Ejecutar `flutter pub get`
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
