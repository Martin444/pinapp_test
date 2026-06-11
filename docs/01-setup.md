# Setup del Proyecto

> [[docs/README|← Volver al índice]] | [[02-architecture|Siguiente: Arquitectura →]]

## Requisitos

- Flutter SDK ^3.6.1
- Dart SDK ^3.6.1
- Android Studio (para Android)
- Xcode (para iOS)

## Instalación

1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Ejecutar `flutter run` (Android o iOS)

## Dependencias

```yaml
dependencies:
  flutter_bloc: ^8.1.6  # [[02-architecture|State management con BLoC]]
  http: ^1.2.0           # HTTP client para posts
  shared_preferences: ^2.3.5 # Persistencia de likes
  equatable: ^2.0.7      # Equality utilities
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
# Unit tests
flutter test

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
