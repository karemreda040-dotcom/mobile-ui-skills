import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const AmanApp());

/// Explicit local boundary for the final CTA. It intentionally does not
/// authenticate, collect payment data, or make a network request.
abstract interface class AccountCreationService {
  Future<void> beginAccountCreation();
}

class LocalAccountCreationService implements AccountCreationService {
  const LocalAccountCreationService();

  @override
  Future<void> beginAccountCreation() async {
    // Replace at composition root when a real, authorized account flow exists.
  }
}

class AmanApp extends StatelessWidget {
  const AmanApp({
    super.key,
    this.accountService = const LocalAccountCreationService(),
  });

  final AccountCreationService accountService;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'مثال أمان',
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Cairo',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: OnboardingFlow(accountService: accountService),
        ),
      );
}

class OnboardingStep {
  const OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.accountService});

  final AccountCreationService accountService;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  static const _steps = <OnboardingStep>[
    OnboardingStep(
      icon: Icons.account_balance_outlined,
      title: 'مثال: أمان',
      description: 'مثال توضيحي لتنظيم الأهداف المالية في تجربة محلية.',
    ),
    OnboardingStep(
      icon: Icons.pie_chart_outline,
      title: 'مثال: راجع مصروفاتك',
      description: 'مثال توضيحي لمراجعة الفئات قبل إعداد تجربة الحساب.',
    ),
    OnboardingStep(
      icon: Icons.verified_user_outlined,
      title: 'مثال: جهّز حسابك',
      description: 'معاينة تعليمية فقط؛ لا يتم إنشاء حساب أو إرسال بيانات.',
    ),
  ];

  int _index = 0;
  bool _isStartingAccount = false;
  String? _accountStartError;

  bool get _isLastStep => _index == _steps.length - 1;

  Future<void> _primaryAction() async {
    if (_isStartingAccount) return;
    if (!_isLastStep) {
      setState(() => _index += 1);
      return;
    }
    setState(() {
      _isStartingAccount = true;
      _accountStartError = null;
    });
    try {
      await widget.accountService.beginAccountCreation();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('معاينة تعليمية: تم استدعاء خطوة الحساب المحلية.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isStartingAccount = false;
        _accountStartError =
            'تعذر بدء إنشاء الحساب في هذه المعاينة. حاول مرة أخرى.';
      });
      return;
    }
    if (mounted) setState(() => _isStartingAccount = false);
  }

  void _skip() {
    if (_isLastStep) return;
    setState(() => _index = _steps.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_index];
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 32)
                    .clamp(0, double.infinity)
                    .toDouble(),
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: _isLastStep ? null : _skip,
                        style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        child: const Text('تخطي'),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'مثال تعليمي — لا يتم إنشاء حساب فعلي',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF5F6368),
                          ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      label: 'الخطوة ${_index + 1} من ${_steps.length}',
                      child: ExcludeSemantics(
                        child: LinearProgressIndicator(
                          value: (_index + 1) / _steps.length,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Icon(step.icon, size: 64, color: colors.primary),
                    const SizedBox(height: 32),
                    Text(
                      step.title,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF171717),
                              ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color: const Color(0xFF5F6368),
                          ),
                    ),
                    const Spacer(flex: 2),
                    if (_accountStartError != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _accountStartError!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colors.error,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isStartingAccount ? null : _primaryAction,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                        child: _isStartingAccount
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                _isLastStep && _accountStartError != null
                                    ? 'إعادة المحاولة'
                                    : _isLastStep
                                        ? 'إنشاء حساب'
                                        : 'التالي',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
