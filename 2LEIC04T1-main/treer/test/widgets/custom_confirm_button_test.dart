import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_confirm_button.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomConfirmButton - Display TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomConfirmButton(
          title: 'Test Title',
          content: 'Test Content',
          action: () {},
        )
      )
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('CustomConfirmButton - Call Confirm TEST', (WidgetTester tester) async {
    bool actionCalled = false;

    await tester.pumpWidget(createWidgetForTesting(
        child: CustomConfirmButton(
          title: 'Test Title',
          content: 'Test Content',
          action: () {
            actionCalled = true;
          },
        )
      )
    );

    await tester.tap(find.text('Confirm'));
    await tester.pump();

    expect(actionCalled, isTrue);
  });

  testWidgets('CustomConfirmButton - Call Cancel TEST', (WidgetTester tester) async {
    bool actionCalled = false;

    await tester.pumpWidget(createWidgetForTesting(
        child: CustomConfirmButton(
          title: 'Test Title',
          content: 'Test Content',
          action: () {
            actionCalled = true;
          },
        )
      )
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(actionCalled, isFalse);
  });
}
