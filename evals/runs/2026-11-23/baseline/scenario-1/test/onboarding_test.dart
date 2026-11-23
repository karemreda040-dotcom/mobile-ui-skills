import 'package:aman_onboarding/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('moves through Arabic steps and starts account creation', (
    tester,
  ) async {
    final service = _RecordingAccountService();
    await tester.pumpWidget(AmanAppForTest(service: service));

    expect(find.text('أهلاً بك في أمان'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('صورة أوضح لميزانيتك'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('إنشاء حساب'), findsOneWidget);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();
    expect(service.calls, 1);
    expect(find.text('هذه معاينة محلية لبدء إنشاء الحساب.'), findsOneWidget);
  });

  testWidgets('keeps its primary action on screen at larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      AmanAppForTest(service: _RecordingAccountService()),
    );
    expect(tester.takeException(), isNull);
    final button = tester.getRect(find.text('التالي'));
    expect(button.bottom, lessThanOrEqualTo(640));
  });
}

class _RecordingAccountService implements AccountCreationService {
  int calls = 0;

  @override
  Future<void> beginAccountCreation() async => calls++;
}

class AmanAppForTest extends StatelessWidget {
  const AmanAppForTest({required this.service, super.key});

  final AccountCreationService service;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('ar'),
    theme: ThemeData(fontFamily: 'Cairo', useMaterial3: true),
    home: OnboardingPage(service: service),
  );
}
