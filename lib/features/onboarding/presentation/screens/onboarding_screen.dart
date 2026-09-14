import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/router/router.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../../settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingOnboardingEvent;
// import '../../../settings/privacy_setting/privacy_setting.dart'
//     show AnalyticsConsentModal;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (!mounted) return;

  //     final bloc = context.read<AppSettingBloc>();
  //     if (mounted && !bloc.stateValue.hasGivenConsent) {
  //       // avoid use of hasGivenConsent at multiple places
  //       await AnalyticsConsentModal.showIfNeeded(context); //whatever the cntext is i want to show the modal on top
  //     }
  //     if (mounted && !bloc.stateValue.hasCompletedOnboarding) {
  //       bloc.add(const AppSettingOnboardingEvent(isCompleted: false));
  //     }
  //   });
  // }

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: Icons.storefront_outlined,
      title: 'Welcome to BlogStore',
      description: 'Discover curated blog posts, articles, and products all in one seamless app.',
    ),
    _OnboardingPageData(
      icon: Icons.sync_outlined,
      title: 'Offline-First Experience',
      description: 'Access your favorite articles and store catalog anytime, even without an active internet connection.',
    ),
    _OnboardingPageData(
      icon: Icons.privacy_tip_outlined,
      title: 'Your Privacy Matters',
      description: 'Customize your app experience, locale, appearance, and privacy choices anytime in Settings.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.read<AppSettingBloc>().add(
      const AppSettingOnboardingEvent(isCompleted: true),
    );
    context.set(const [HomeRoot()]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 80,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(isLastPage ? 'Get Started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
