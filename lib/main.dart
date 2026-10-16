import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/start/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Mapbox Access Token on mobile platforms
  if (!kIsWeb) {
    try {
      MapboxOptions.setAccessToken(
        'sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA',
      );
    } catch (_) {}
  }

  // Lock to landscape orientation matching original Android app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Hide system bars for immersive sticky fullscreen
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const OurResourcesApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class OurResourcesApp extends StatelessWidget {
  const OurResourcesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ثرواتنا من أرضنا',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.theme,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const StartScreen(),
    );
  }
}
