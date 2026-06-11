# Setup del Proyecto

> [[docs/README|← Volver al índice]] | [[02-architecture|Siguiente: Arquitectura →]]

## Requisitos

- Flutter SDK ^3.6.1
- Dart SDK ^3.6.1
- Android Studio (para Android)
- Xcode (para iOS)

## Instalación

1. Clonar el repositorio
2. Ejecutar `flutter pub get` (resuelve workspace + package simultáneamente)
3. Ejecutar `flutter run` (Android o iOS)

## Pub Workspace

El proyecto usa un monorepo con Pub Workspace. El root y el package se declaran como workspace:

```yaml
# pubspec.yaml (root)
name: pinapp_test
workspace:
  - packages/pinapp_dart_api
dependencies:
  pinapp_dart_api:
    path: packages/pinapp_dart_api
```

El package `pinapp_dart_api` declara `resolution: workspace` en su `pubspec.yaml`.

## Dependencias

### Root (Presentación)

```yaml
dependencies:
  flutter_bloc: ^8.1.6  # [[02-architecture|State management con BLoC]]
  pinapp_dart_api:       # API client (path dependency)
```

### Package `pinapp_dart_api` (Data + Domain)

```yaml
dependencies:
  http: ^1.2.0           # HTTP client para posts
  shared_preferences: ^2.3.5 # Persistencia de likes
  equatable: ^2.0.7      # Equality utilities

dev_dependencies:
  mocktail: ^1.0.4       # Mocking para tests
```

## Configuración de Platform Channels

### iOS
- Archivo: `ios/Runner/AppDelegate.swift`
- Implementación: Swift con URLSession
- Ver detalles en [[04-platform-channels|Platform Channels]]

### Android
- Archivo: `android/app/src/main/.../MainActivity.kt`
- Implementación: Kotlin con HttpURLConnection
- Ver detalles en [[04-platform-channels|Platform Channels]]

## Ejecución de Tests

```bash
# Unit tests (root)
flutter test

# Package tests
cd packages/pinapp_dart_api && flutter test

# Coverage
flutter test --coverage
```

Para más información sobre testing, ver [[05-testing|Testing]].

---

## Referencias Rápidas

- [[02-architecture|Arquitectura del proyecto]]
- [[03-atomic-design|Organización de la UI (Atomic Design)]]
- [[04-platform-channels|Comunicación con nativo]]
- [[05-testing|Testing y calidad]]
