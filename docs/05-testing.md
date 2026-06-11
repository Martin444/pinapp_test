# Testing

> [[04-platform-channels|← Platform Channels]] | [[docs/README|Índice]]

## Estrategia de Testing

El proyecto implementa tests en tres niveles:

### Unit Tests (Package)
- **UseCases**: Testear con mocks de repositorios
- **Providers**: Testear integración con datasources
- **Models**: Testear serialización/deserialización

### BLoC Tests (Root)
- **Blocs**: Testear eventos y estados
- **Cubits**: Testear lógica de negocio
- Usan mocks de UseCases

### Widget Tests (Root)
- **Átomos**: Testear renderizado y props
- **Moléculas**: Testear interacción de usuario
- **Páginas**: Testear flujo completo con providers mockeados

## Herramientas

- `flutter_test`: Testing framework
- `bloc_test`: Testing de BLoC
- `mocktail`: Mocking

## Organización de Tests

```
PinApp/
├── test/                              # Tests de presentación
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── post_bloc_test.dart    # PostBloc con mocks de UseCases
│   │   │   ├── comment_bloc_test.dart
│   │   │   └── like_cubit_test.dart
│   │   └── widgets/
│   │       ├── post_card_test.dart
│   │       └── comment_tile_test.dart
│   ├── data/
│   │   └── post_repository_impl_test.dart  # Tests de GetPostsUseCase
│   └── widget_test.dart
└── packages/
    └── pinapp_dart_api/
        └── test/                      # Tests del package
            ├── post_provider_test.dart
            ├── comment_provider_test.dart
            └── like_provider_test.dart
```

## Ejemplos de Tests

### BLoC Test (con UseCase mocks)

Ejemplo en `test/presentation/bloc/post_bloc_test.dart`:

```dart
class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}
class MockToggleLikeUseCase extends Mock implements ToggleLikeUseCase {}

blocTest<PostBloc, PostState>(
  'emite [PostLoading, PostLoaded] cuando PostFetched es exitoso',
  build: () {
    when(() => mockGetPostsUseCase.execute()).thenAnswer((_) async => mockPosts);
    return PostBloc(
      getPostsUseCase: mockGetPostsUseCase,
      toggleLikeUseCase: mockToggleLikeUseCase,
    );
  },
  act: (bloc) => bloc.add(const PostFetched()),
  expect: () => [
    isA<PostLoading>(),
    isA<PostLoaded>(),
  ],
);
```

### UseCase Test

Ejemplo en `test/data/post_repository_impl_test.dart`:

```dart
final mockPosts = [
  const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
];

when(() => mockPostRepo.getPosts()).thenAnswer((_) async => mockPosts);
when(() => mockLikeRepo.getLikedPosts()).thenAnswer((_) async => {1});

final result = await useCase.execute();

expect(result[0].isLiked, true);
```

### Widget Test

Ejemplo en `test/presentation/widgets/post_card_test.dart`:

```dart
testWidgets('PostCard renders correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PostCard(
          id: 1,
          title: 'Título de prueba',
          body: 'Body de prueba',
          isLiked: false,
        ),
      ),
    ),
  );
  
  expect(find.text('Título de prueba'), findsOneWidget);
  expect(find.byIcon(Icons.favorite_border), findsOneWidget);
});
```

## Ejecución

```bash
# Todos los tests (root + package)
flutter test

# Tests específicos
flutter test test/presentation/bloc/post_bloc_test.dart

# Tests del package
cd packages/pinapp_dart_api && flutter test

# Con coverage
flutter test --coverage
```

## Cobertura Actual

- ✅ UseCase Tests: GetPostsUseCase
- ✅ BLoC Tests: PostBloc
- ✅ Widget Tests: PostCard, CommentTile
- ✅ Smoke Test: App renders HomePage
- ⬜ Package provider tests (pendientes)
- ⬜ CommentBloc tests (pendientes)
- ⬜ LikeCubit tests (pendientes)

---

## Referencias

- [[01-setup|Setup del Proyecto]]
- [[02-architecture|Arquitectura]]
- [[03-atomic-design|Atomic Design]]
- [[04-platform-channels|Platform Channels]]
