import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_alert_dialog.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomAlertDialog - Display TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomAlertDialog(
          title: 'Test Title',
          content: 'Test Content',
          action: () {},
        )
      )
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('CustomAlertDialog - Action TEST', (WidgetTester tester) async {
    bool actionTrigger = false;

    await tester.pumpWidget(createWidgetForTesting(
        child: CustomAlertDialog(
          title: 'Test Title',
          content: 'Test Content',
          action: () {
            actionTrigger = true;
          },
        )
      )
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(actionTrigger, isTrue);
  });
}
