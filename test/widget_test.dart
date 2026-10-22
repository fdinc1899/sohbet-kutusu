import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohbet_kutusu/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Ana ekranda dört oyun modu görünür', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SohbetKutusuApp());
    await tester.pumpAndSettle();
    expect(find.text('SOHBET KUTUSU'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('İkilem'), 200, scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('İkilem'), findsOneWidget);
    expect(find.text('Kim Daha Olası?'), findsOneWidget);
    expect(find.text('5 Saniyede Söyle'), findsOneWidget);
    expect(find.text('Eğlenceli Görevler'), findsOneWidget);
  });

  testWidgets('İkilem kartı açılır ve seçilebilir', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SohbetKutusuApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('İkilem'), 200, scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('İkilem'));
    await tester.pumpAndSettle();
    expect(find.text('Hangisini seçerdin?'), findsOneWidget);
    expect(find.text('KART 1 / 32'), findsOneWidget);
  });
}
