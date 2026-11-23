import 'dart:async';

import 'package:aman_onboarding/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('failed account creation restores an actionable retry state',
      (tester) async {
    final service = _ThrowingService();
    await tester.pumpWidget(_testApp(service));
    await _goToFinalStep(tester);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pump();

    expect(find.text('تعذر إنشاء الحساب. حاول مرة أخرى.'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(service.calls, 1);
  });

  testWidgets('a pending submission does not invoke the service twice',
      (tester) async {
    final service = _PendingService();
    await tester.pumpWidget(_testApp(service));
    await _goToFinalStep(tester);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(service.calls, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('320 by 568 at 2x text scale has no overflow on every step',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_testApp(_PendingService()));
    final failures = <String>[];
    for (var step = 0; step < 3; step++) {
      tester.view.platformDispatcher.textScaleFactorTestValue = 2;
      await tester.pump();
      final layoutError = tester.takeException();
      if (layoutError != null) {
        failures.add('step ${step + 1}: $layoutError');
      }
      final action = tester.getRect(find.byType(FilledButton));
      if (action.bottom > 568) {
        failures.add('step ${step + 1}: primary action bottom was ${action.bottom}');
      }
      if (step < 2) {
        // Restore a tappable control only to navigate to the next independently
        // measured step; each step above is measured at 2x scale.
        tester.view.platformDispatcher.textScaleFactorTestValue = 1;
        await tester.pump();
        await tester.tap(find.text('التالي'));
        await tester.pump();
      }
    }
    expect(failures, isEmpty, reason: 'overflow or off-screen primary action');
  });
}

Widget _testApp(AccountCreationService service) => MaterialApp(
      locale: const Locale('ar'),
      theme: ThemeData(fontFamily: 'Cairo', useMaterial3: true),
      home: OnboardingPage(service: service),
    );

Future<void> _goToFinalStep(WidgetTester tester) async {
  await tester.tap(find.text('التالي'));
  await tester.pump();
  await tester.tap(find.text('التالي'));
  await tester.pump();
}

class _ThrowingService implements AccountCreationService {
  int calls = 0;

  @override
  Future<void> beginAccountCreation() async {
    calls++;
    throw StateError('simulated service failure');
  }
}

class _PendingService implements AccountCreationService {
  int calls = 0;
  final completer = Completer<void>();

  @override
  Future<void> beginAccountCreation() {
    calls++;
    return completer.future;
  }
}
