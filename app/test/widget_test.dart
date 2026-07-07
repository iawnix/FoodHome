import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodhome_app/app.dart';

void main() {
  testWidgets('renders FoodHome shell and submits a local order', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: FoodHomeApp()));
    await tester.pumpAndSettle();

    expect(find.text('FoodHome'), findsOneWidget);
    expect(find.text('今晚吃什么'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('点菜'));
    await tester.pumpAndSettle();

    expect(find.textContaining('已发给厨房'), findsOneWidget);
  });
}
