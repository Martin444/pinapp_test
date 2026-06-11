import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinapp_material_ui/ui/molecules/comment_tile.dart';

void main() {
  group('CommentTile', () {
    testWidgets('renderiza nombre, email y body correctamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommentTile(
              name: 'John Doe',
              email: 'john@example.com',
              body: 'Este es un comentario de prueba',
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('Este es un comentario de prueba'), findsOneWidget);
    });
  });
}
