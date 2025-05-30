import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tasknavigation/main.dart'; // Verifique o caminho correto

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Substitua 'TaskNavigationApp' pelo nome correto do seu widget principal
    await tester.pumpWidget(const TaskNavigationApp());

    // Verifica se o contador inicia em 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Clica no botão de incrementar
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica se o contador foi para 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}


