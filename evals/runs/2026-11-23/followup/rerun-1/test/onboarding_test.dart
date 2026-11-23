import 'package:aman_finance_onboarding/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingAccountService implements AccountCreationService {
  var calls = 0;
  @override
  Future<void> beginAccountCreation() async => calls++;
}

class ControlledAccountService implements AccountCreationService {
  ControlledAccountService(this.requests);

  final List<Completer<void>> requests;
  var calls = 0;

  @override
  Future<void> beginAccountCreation() => requests[calls++].future;
}

void main() {
  testWidgets('moves through Arabic steps and calls only the local boundary', (
    tester,
  ) async {
    final service = RecordingAccountService();
    await tester.pumpWidget(AmanApp(accountService: service));

    expect(find.text('مثال: أمان'), findsOneWidget);
    expect(find.text('تخطي'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('مثال: راجع مصروفاتك'), findsOneWidget);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    expect(find.text('إنشاء حساب'), findsOneWidget);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();
    expect(service.calls, 1);
  });

  testWidgets('a delayed failure keeps the final step and offers retry', (
    tester,
  ) async {
    final first = Completer<void>();
    final retry = Completer<void>();
    final service = ControlledAccountService([first, retry]);
    await tester.pumpWidget(AmanApp(accountService: service));
    await _goToFinalStep(tester);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(service.calls, 1);

    first.completeError(StateError('local test failure'));
    await tester.pump();
    expect(find.text('تعذر بدء إنشاء الحساب في هذه المعاينة. حاول مرة أخرى.'),
        findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsOneWidget);
    expect(find.text('مثال: جهّز حسابك'), findsOneWidget);

    await tester.tap(find.text('إعادة المحاولة'));
    await tester.pump();
    expect(service.calls, 2);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('a pending request prevents duplicate account-start calls', (
    tester,
  ) async {
    final pending = Completer<void>();
    final service = ControlledAccountService([pending]);
    await tester.pumpWidget(AmanApp(accountService: service));
    await _goToFinalStep(tester);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(service.calls, 1);
  });

  testWidgets('all steps retain a reachable CTA at 320x568 and 2x text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(AmanApp(accountService: RecordingAccountService()));

    expect(
      Theme.of(tester.element(find.byType(OnboardingFlow)))
          .textTheme
          .bodyLarge
          ?.fontFamily,
      'Cairo',
    );
    for (var step = 0; step < 3; step++) {
      tester.view.platformDispatcher.textScaleFactorTestValue = 2;
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pump();
      final button = tester.getRect(find.byType(FilledButton));
      expect(button.top, greaterThanOrEqualTo(0));
      expect(button.bottom, lessThanOrEqualTo(568));
      if (step < 2) {
        tester.view.platformDispatcher.textScaleFactorTestValue = 1;
        await tester.pump();
        await tester.tap(find.text('التالي'));
        await tester.pump();
      }
    }
  });
}

Future<void> _goToFinalStep(WidgetTester tester) async {
  await tester.tap(find.text('التالي'));
  await tester.pump();
  await tester.tap(find.text('التالي'));
  await tester.pump();
}
