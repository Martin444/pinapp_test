# Testing

> [[04-platform-channels|← Platform Channels]] | [[docs/README|Índice]]

## Estrategia de Testing

El proyecto implementa tests en tres niveles:

### Unit Tests
- **BLoC**: Testear todos los eventos y estados
- **Repositories**: Testear con mocks de datasources
- **Models**: Testear serialización/deserialización

### Widget Tests
- **Átomos**: Testear renderizado y props
- **Moléculas**: Testear interacción de usuario
- **Organismos**: Testear integración de componentes
- **Páginas**: Testear flujo completo

### Integration Tests
- Testear flujo completo: Listado → Detalle → Like

## Herramientas

- `flutter_test`: Testing framework
- `bloc_test`: Testing de BLoC
- `mocktail`: Mocking

## Ejemplos de Tests

### BLoC Test

Ejemplo en `[[../test/presentation/bloc/post_bloc_test.dart|test/presentation/bloc/post_bloc_test.dart]]`:

```dart
blocTest<PostBloc, PostState>(
  'emits [PostLoading, PostLoaded] when PostFetched is added',
  build: () => PostBloc(repository: mockRepository),
  act: (bloc) => bloc.add(PostFetched()),
  expect: () => [
    PostLoading(),
    PostLoaded(posts: mockPosts),
  ],
);
```

### Widget Test

Ejemplo en `[[../test/presentation/widgets/post_card_test.dart|test/presentation/widgets/post_card_test.dart]]`:

```dart
testWidgets('PostCard renders correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PostCard(post: mockPost),
      ),
    ),
  );
  
  expect(find.text(mockPost.title), findsOneWidget);
  expect(find.text(mockPost.body), findsOneWidget);
});
```

### Repository Test

Ejemplo en `[[../test/data/post_repository_impl_test.dart|test/data/post_repository_impl_test.dart]]`:

```dart
test('debe retornar lista de posts con likes', () async {
  final mockPosts = [
    const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
  ];
  
  when(() => mockApi.getPosts()).thenAnswer((_) async => mockPosts);
  when(() => mockLikesLocal.getLikedPosts()).thenAnswer((_) async => {1});

  final result = await repository.getPosts();

  expect(result.length, 1);
  expect(result[0].isLiked, true);
});
```

## Ejecución

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/presentation/bloc/post_bloc_test.dart

# Con coverage
flutter test --coverage
```

## Cobertura Actual

- ✅ Unit Tests: Repositories
- ✅ BLoC Tests: PostBloc
- ✅ Widget Tests: PostCard, CommentTile

---

## Referencias

- [[01-setup|Setup del Proyecto]]
- [[02-architecture|Arquitectura]]
- [[03-atomic-design|Atomic Design]]
- [[04-platform-channels|Platform Channels]]
