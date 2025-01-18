import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_bottom_navigation_bar.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomBottomNavigationBar - Display TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
        child: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: (int int) {},
        )
      )
    );

    expect(find.text('Reduce'), findsOneWidget);
    expect(find.text('Reuse'), findsOneWidget);
    expect(find.text('Recycle'), findsOneWidget);
  });

  testWidgets('CustomBottomNavigationBar - Action TEST', (WidgetTester tester) async {
    bool actionTrigger = false;

    await tester.pumpWidget(createWidgetForTesting(
        child: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: (int int) { actionTrigger = true; },
        )
    )
    );

    await tester.tap(find.text('Reuse'));
    await tester.pumpAndSettle();

    expect(actionTrigger, isTrue);
  });
}
