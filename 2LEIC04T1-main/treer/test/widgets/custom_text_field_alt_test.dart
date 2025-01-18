import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_text_field_alt.dart';

void main() {
  final TextEditingController controller = TextEditingController();

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomTextFieldAlt - Display TEST 1', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextFieldAlt(
          hintText: 'Test Hint',
          obscureText: true,
          controller: controller,
        )
      )
    );

    expect(find.text('Test Hint'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('CustomTextFieldAlt - Display TEST 2', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextFieldAlt(
          hintText: 'Test Hint',
          obscureText: false,
          controller: controller,
        )
      )
    );

    expect(find.text('Test Hint'), findsOneWidget);
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('CustomTextFieldAlt - Type TEST 1', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextFieldAlt(
          hintText: 'Test Hint',
          obscureText: true,
          controller: controller,
        )
      )
    );

    await tester.enterText(find.byType(TextField), 'input');
    await tester.pump();

    expect(find.text('input'), findsOneWidget);
  });

  testWidgets('CustomTextFieldAlt - Type TEST 2', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextFieldAlt(
          hintText: 'Test Hint',
          obscureText: true,
          controller: controller,
        )
      )
    );

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(find.text(''), findsOneWidget);
  });

  testWidgets('CustomTextFieldAlt - Icon Toggle TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomTextFieldAlt(
          hintText: 'Test Hint',
          obscureText: true,
          controller: controller,
        )
      )
    );

    expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
  });
}
