import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/asset_page.dart';
import 'pages/home_page.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final defaultTheme = ref.read(themeProvider);

    return MaterialApp(
      theme: defaultTheme.theme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/asset': (context) => const AssetPage(),
      },
    );
  }
}
