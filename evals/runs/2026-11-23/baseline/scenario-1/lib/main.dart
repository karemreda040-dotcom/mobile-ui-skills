import 'package:flutter/material.dart';

void main() => runApp(const AmanApp());

/// Boundary for a future account-creation flow. It has no network side effects.
abstract interface class AccountCreationService {
  Future<void> beginAccountCreation();
}

class LocalAccountCreationService implements AccountCreationService {
  const LocalAccountCreationService();

  @override
  Future<void> beginAccountCreation() async {}
}

class AmanApp extends StatelessWidget {
  const AmanApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF146C5A),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAF9),
    ),
    home: const OnboardingPage(service: LocalAccountCreationService()),
  );
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.service, super.key});

  final AccountCreationService service;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  bool _isStarting = false;

  static const _steps = <_OnboardingStep>[
    _OnboardingStep(
      icon: Icons.account_balance_wallet_outlined,
      title: 'أهلاً بك في أمان',
      body: 'رتّب أهدافك المالية في مكان واحد، بالوتيرة التي تناسبك.',
    ),
    _OnboardingStep(
      icon: Icons.visibility_outlined,
      title: 'صورة أوضح لميزانيتك',
      body: 'تابع ما تخطط له وما تنفقه من خلال ملخص بسيط وواضح.',
    ),
    _OnboardingStep(
      icon: Icons.lock_outline_rounded,
      title: 'بياناتك لك',
      body: 'نطلب فقط ما تحتاجه لإعداد حسابك. يمكنك مراجعة اختياراتك لاحقاً.',
    ),
  ];

  Future<void> _advance() async {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }
    setState(() => _isStarting = true);
    await widget.service.beginAccountCreation();
    if (!mounted) return;
    setState(() => _isStarting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('هذه معاينة محلية لبدء إنشاء الحساب.')),
    );
  }

  void _skip() => setState(() => _step = _steps.length - 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = _steps[_step];
    final isLast = _step == _steps.length - 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: 'الخطوة ${_step + 1} من ${_steps.length}',
                        child: LinearProgressIndicator(
                          value: (_step + 1) / _steps.length,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_step + 1}/${_steps.length}',
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: isLast ? null : _skip,
                    child: const Text('تخطي'),
                  ),
                ),
                const Spacer(),
                ExcludeSemantics(
                  child: Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 48,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.body,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4B5563),
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _isStarting ? null : _advance,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _isStarting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isLast ? 'إنشاء حساب' : 'التالي'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}
