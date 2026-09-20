import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ad_manager.dart';
import 'app_scope.dart';
import 'l10n/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/setup_screen.dart';
import 'services/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // 광고 SDK 초기화는 앱 표시를 막지 않도록 기다리지 않는다.
  AdManager.instance.init(prefs);
  runApp(LadderApp(settings: AppSettings(prefs)));
}

const kSeedColor = Color(0xFF00897B);

class LadderApp extends StatelessWidget {
  final AppSettings settings;
  const LadderApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      settings: settings,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: kSeedColor, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: kSeedColor,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        onGenerateTitle: (context) => L10n.of(context).appTitle,
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        // 미지원 언어는 영어로
        localeResolutionCallback: (device, supported) {
          final code = device?.languageCode;
          for (final l in supported) {
            if (l.languageCode == code) return l;
          }
          return const Locale('en');
        },
        home: ListenableBuilder(
          listenable: settings,
          builder: (context, _) => settings.onboarded
              ? const SetupScreen()
              : const OnboardingScreen(),
        ),
      ),
    );
  }
}
