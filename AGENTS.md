# AGENTS.md - PinApp Challenge

## Proyecto
**Nombre**: pinapp_test
**Descripción**: Prueba técnica para PinApp - Listado de posts con buscador, detalle de comentarios y likes.

## Arquitectura

### Clean Architecture
```
lib/
├── core/          # Theme, constants, platform channels, utilities
├── domain/        # Entities, repository abstractions
├── data/          # Models, datasources, repository implementations
├── presentation/  # Blocs + Atomic Design UI
└── main.dart
```

### State Management
- **BLoC** (flutter_bloc) para gestión de estado
- **Cubit** para casos simples (likes)

### UI Layer - Atomic Design
```
lib/presentation/ui/
├── atoms/         # Componentes más básicos (Text, Button, Icon)
├── molecules/     # Combinación de átomos (PostCard, SearchBar, CommentTile)
├── organisms/     # Secciones de UI (PostList, PostDetail)
├── templates/     # Layouts de página (HomeTemplate, DetailTemplate)
└── pages/         # Pantallas completas (HomePage, DetailPage)
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
- `flutter_bloc`: State management
- `http`: HTTP client para posts
- `shared_preferences`: Persistencia de likes
- `equatable`: Equality para BLoC states
- `mocktail`: Testing
- `bloc_test`: Testing de BLoC

## Platform Channels
- **Nombre**: `com.pinapp.comments`
- **Método**: `getComments`
- **Argumento**: `{"postId": int}`
- **Implementación nativa**: iOS (Swift) y Android (Kotlin)

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
