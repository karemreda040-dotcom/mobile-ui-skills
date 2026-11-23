import 'package:aman_finance_onboarding/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingAccountService implements AccountCreationService {
  var calls = 0;
  @override
  Future<void> beginAccountCreation() async => calls++;
}

void main() {
  testWidgets('moves through Arabic steps and calls only the local boundary', (
    tester,
  ) async {
    final service = RecordingAccountService();
    await tester.pumpWidget(AmanApp(accountService: service));

    expect(find.text('أهلاً بك في أمان'), findsOneWidget);
    expect(find.text('تخطي'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('افهم مصروفاتك'), findsOneWidget);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    expect(find.text('إنشاء حساب'), findsOneWidget);

    await tester.tap(find.text('إنشاء حساب'));
    await tester.pumpAndSettle();
    expect(service.calls, 1);
  });
}
