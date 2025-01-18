import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_text_field.dart';

void main() {
  final TextEditingController controller = TextEditingController();

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomTextField - Type TEST 1', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextField(
            labelText: 'Test',
            controller: controller
        )
      )
    );

    expect(find.text('Test'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'input');
    await tester.pump();

    expect(find.text('input'), findsOneWidget);
  });

  testWidgets('CustomTextField - Type TEST 2', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextField(
            labelText: 'Test',
            controller: controller
        )
      )
    );

    expect(find.text('Test'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(find.text(''), findsOneWidget);
  });
}
