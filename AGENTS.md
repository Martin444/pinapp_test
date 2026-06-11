# AGENTS.md - PinApp Challenge

## Proyecto
**Nombre**: pinapp_test
**Descripción**: Prueba técnica para PinApp - Listado de posts con buscador, detalle de comentarios y likes.

## Arquitectura

### Pub Workspace (Monorepo)
```
PinApp/                          # Root (app shell)
├── packages/
│   ├── pinapp_dart_api/         # API client (data + domain layers)
│   └── pinapp_material_ui/     # UI components + theming
└── lib/                         # BLoCs + organisms/templates/pages
```

### Package `pinapp_dart_api` — by_feature
```
lib/
├── core/              # API constants, CommentsPlatformChannel
├── by_feature/
│   ├── posts/         # PostModel, PostRepository, PostProvider, GetPostsUseCase
│   ├── comments/      # CommentModel, CommentRepository, CommentProvider, GetCommentsUseCase
│   └── likes/         # LikeRepository, LikeProvider, GetLikedPostsUseCase, ToggleLikeUseCase
└── pinapp_dart_api.dart  # Barrel export
```

### Package `pinapp_material_ui` — UI Kit
```
lib/
├── constants/         # Colores PinApp
├── theme/             # ThemeData Material 3
├── models/            # Data classes para parámetros (PostItemData, CommentItemData)
├── ui/
│   ├── atoms/         # Componentes básicos (Text, Button, Icon)
│   ├── molecules/     # Combinación de átomos (PostCard, SearchBar, CommentTile)
│   ├── organisms/     # Secciones de UI (PostList, PostDetail) — parametrizados
│   └── templates/     # Layouts de página (HomeTemplate, DetailTemplate) — parametrizados
└── pinapp_material_ui.dart  # Barrel export
```

### Root — App Shell
```
lib/
├── presentation/  # BLoCs + Pages (conectan BLoCs → templates parametrizados)
└── main.dart
```

## Convenciones de Código

### Naming
- Archivos: `snake_case.dart`
- Clases: `PascalCase`
- Variables/métodos: `camelCase`
- Constantes: `UPPER_SNAKE_CASE`

### Imports
- Ordenar: Dart SDK → Flutter → Packages → Relativos
- Siempre usar `package:` imports, nunca relativos entre packages

### Testing
- Testear todos los blocs con `bloc_test`
- Testear repositories con `mocktail`
- Testear widgets con `WidgetTester`

## Dependencias Principales

### Root (pinapp_test)
- `flutter_bloc`: State management

### Package (pinapp_dart_api)
- `http`: HTTP client para posts
- `shared_preferences`: Persistencia de likes
- `equatable`: Equality para BLoC states

### Package (pinapp_material_ui)
- `flutter_bloc`: State management para UI components
- Organisms y templates son completamente parametrizados (sin dependencia directa a BLoCs)
- Reciben datos y callbacks desde las Pages a través del patrón de Inversión de Dependencias

### Dev (ambos)
- `mocktail`: Testing
- `bloc_test`: Testing de BLoC

## Platform Channels
- **Nombre**: `com.pinapp.comments`
- **Método**: `getComments`
- **Argumento**: `{"postId": int}`
- **Implementación nativa**: iOS (Swift) y Android (Kotlin)
- **Ubicación en Flutter**: `packages/pinapp_dart_api/lib/core/comments_channel.dart`

## Estilo Visual
- **Paleta**: Colores PinApp (azul marino, rojo, turquesa)
- **Theme**: Material 3 con colores custom
- **Tipografía**: Inter/Roboto, pesos regulares

## Notas de Implementación
- Posts se obtienen directamente desde Flutter (http)
- Comentarios se obtienen desde nativo (platform channels)
- Likes persisten en SharedPreferences
- La app debe funcionar en Android y iOS

## Documentación
Ver carpeta `docs/` para documentación detallada de cada parte del proyecto.
