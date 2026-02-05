import 'dart:io' show Platform;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// =====================
/// ENUMS
/// =====================
enum DeviceMode { auto, phone, desktop }
enum AppThemeMode { system, dark, light }

/// =====================
/// LOCALIZATION
/// =====================
const supportedLanguages = {
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'it': 'Italiano',
  'ru': 'Русский',
  'uk': 'Українська',
};

const strings = {
  'title': {
    'en': 'TeitConnect',
    'es': 'TeitConnect',
    'fr': 'TeitConnect',
    'it': 'TeitConnect',
    'ru': 'TeitConnect',
    'uk': 'TeitConnect',
  },
  'screen': {
    'en': 'Screen control',
    'es': 'Screen control',
    'fr': 'Contrôle écran',
    'it': 'Controllo schermo',
    'ru': 'Экран',
    'uk': 'Екран',
  },
  'files': {
    'en': 'File transfer',
    'es': 'Archivos',
    'fr': 'Fichiers',
    'it': 'File',
    'ru': 'Файлы',
    'uk': 'Файли',
  },
  'storage': {
    'en': 'Storage access',
    'es': 'Almacenamiento',
    'fr': 'Stockage',
    'it': 'Archivio',
    'ru': 'Хранилище',
    'uk': 'Сховище',
  },
  'audio': {
    'en': 'Audio devices',
    'es': 'Audio',
    'fr': 'Audio',
    'it': 'Audio',
    'ru': 'Аудио',
    'uk': 'Аудіо',
  },
  'calls': {
    'en': 'Messages & calls',
    'es': 'Messages',
    'fr': 'Messages',
    'it': 'Messaggi',
    'ru': 'Сообщения',
    'uk': 'Повідомлення',
  },
  'stats': {
    'en': 'Device statistics',
    'es': 'Statistics',
    'fr': 'Statistiques',
    'it': 'Statistiche',
    'ru': 'Статистика',
    'uk': 'Статистика',
  },
  'settings': {
    'en': 'Settings',
    'es': 'Settings',
    'fr': 'Settings',
    'it': 'Settings',
    'ru': 'Настройки',
    'uk': 'Налаштування',
  },
};

String tr(String key, String lang) => strings[key]?[lang] ?? key;

/// =====================
/// SETTINGS STATE
/// =====================
class AppSettings extends ChangeNotifier {
  DeviceMode deviceMode = DeviceMode.auto;
  AppThemeMode themeMode = AppThemeMode.system;
  String language = 'en';

  bool isDesktopByWidth(double width) {
    if (deviceMode == DeviceMode.desktop) return true;
    if (deviceMode == DeviceMode.phone) return false;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    }

    if (width >= 900) {
      return true;
    }

    return false;
  }

  ThemeMode get theme {
    if (themeMode == AppThemeMode.dark) return ThemeMode.dark;
    if (themeMode == AppThemeMode.light) return ThemeMode.light;
    return ThemeMode.system;
  }

  void setDeviceMode(DeviceMode v) {
    deviceMode = v;
    notifyListeners();
  }

  void setTheme(AppThemeMode v) {
    themeMode = v;
    notifyListeners();
  }

  void setLanguage(String v) {
    language = v;
    notifyListeners();
  }
}

/// =====================
/// APP ROOT
/// =====================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: settings.theme,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          home: Home(settings: settings),
        );
      },
    );
  }
}

/// =====================
/// THEMES
/// =====================
final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B0614),
  colorScheme: const ColorScheme.dark(
    primary: Colors.orange,
    onPrimary: Colors.white,
  ),
);

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF5E2B97),
    onPrimary: Colors.black,
  ),
);

/// =====================
/// HOME
/// =====================
class Home extends StatelessWidget {
  final AppSettings settings;
  const Home({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            settings.isDesktopByWidth(constraints.maxWidth);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              tr('title', settings.language),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SettingsScreen(settings: settings),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: isDesktop ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    FeatureBlock(Icons.cast,
                        tr('screen', settings.language)),
                    FeatureBlock(Icons.folder,
                        tr('files', settings.language)),
                    FeatureBlock(Icons.storage,
                        tr('storage', settings.language)),
                    FeatureBlock(Icons.headphones,
                        tr('audio', settings.language)),
                    FeatureBlock(Icons.call,
                        tr('calls', settings.language)),
                    FeatureBlock(Icons.analytics,
                        tr('stats', settings.language)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// =====================
/// FEATURE BLOCK
/// =====================
class FeatureBlock extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureBlock(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// SETTINGS
/// =====================
class SettingsScreen extends StatelessWidget {
  final AppSettings settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(tr('settings', settings.language)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Theme'),
          DropdownButton<AppThemeMode>(
            value: settings.themeMode,
            onChanged: (v) {
              if (v != null) settings.setTheme(v);
            },
            items: const [
              DropdownMenuItem(
                value: AppThemeMode.system,
                child: Text('System'),
              ),
              DropdownMenuItem(
                value: AppThemeMode.dark,
                child: Text('Dark'),
              ),
              DropdownMenuItem(
                value: AppThemeMode.light,
                child: Text('Light'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Language'),
          DropdownButton<String>(
            value: settings.language,
            onChanged: (v) {
              if (v != null) settings.setLanguage(v);
            },
            items: supportedLanguages.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
