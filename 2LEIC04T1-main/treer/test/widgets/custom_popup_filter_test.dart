import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treer/widgets/custom_popup_filter.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomMaterialFilter - Display TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const CustomPopUpFilter(
        title: 'Material',
        currentFilter: 'Wood',
        materials: ['Wood', 'Metal', 'Plastic'],
      ),
    ));

    expect(find.text('Wood'), findsOneWidget);
    expect(find.text('Metal'), findsOneWidget);
    expect(find.text('Plastic'), findsOneWidget);
    expect(find.text('Save Filter'), findsOneWidget);
  });

  testWidgets('CustomMaterialFilter - Select TEST', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const CustomPopUpFilter(
        title: 'Material',
        currentFilter: 'Wood',
        key: ValueKey('CustomMaterialFilter'),
        materials: ['Wood', 'Metal', 'Plastic'],
      ),
    ));

    final Text plasticTileTitle = tester.widget(find.text('Plastic')) as Text;

    expect(plasticTileTitle.style!.color, Colors.black);

    await tester.tap(find.text('Plastic'));
    await tester.pumpAndSettle();

    final Text updatedPlasticTileTitle = tester.widget(find.text('Plastic')) as Text;

    expect(updatedPlasticTileTitle.style!.color, AppColors.darkGreen);
  });
}
