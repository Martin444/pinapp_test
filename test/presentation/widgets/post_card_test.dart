import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinapp_test/presentation/ui/molecules/post_card.dart';

void main() {
  group('PostCard', () {
    testWidgets('renderiza título y body correctamente', (tester) async {
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
      expect(find.text('Body de prueba'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('muestra icono de like activo cuando isLiked es true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              id: 1,
              title: 'Título',
              body: 'Body',
              isLiked: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('llama onTap cuando se presiona', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              id: 1,
              title: 'Título',
              body: 'Body',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });
}
