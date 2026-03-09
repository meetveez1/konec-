import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SchoolApp());
}

class SchoolApp extends StatefulWidget {
  const SchoolApp({super.key});

  @override
  State<SchoolApp> createState() => _SchoolAppState();
}

class _SchoolAppState extends State<SchoolApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _updateTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Школьное приложение',
      themeMode: _themeMode,
      scrollBehavior: const _AppScrollBehavior(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: SchoolHomePage(
        themeMode: _themeMode,
        onThemeChanged: _updateTheme,
      ),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

class AppThemes {
  static const Color midnightBlack = Color(0xFF0B0B0E);
  static const LinearGradient cyanGreenGradient = LinearGradient(
    colors: [Color(0xFF1EB7DA), Color(0xFF08CB61)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF16D6C8),
      brightness: Brightness.dark,
    );
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: midnightBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1B20),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: const Color(0xFF17181D),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF16D6C8),
      brightness: Brightness.light,
    );
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF3F5F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3A3D45),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: Colors.white,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFF131B2F),
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF131B2F),
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF131B2F),
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: Color(0xFF2C3954)),
        bodyMedium: TextStyle(color: Color(0xFF5E6A81)),
      ),
      useMaterial3: true,
    );
  }
}

class SchoolHomePage extends StatefulWidget {
  const SchoolHomePage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<SchoolHomePage> createState() => _SchoolHomePageState();
}

class _SchoolHomePageState extends State<SchoolHomePage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    setState(() => _pageIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentLabel = isDark ? const Color(0xFF5BE7C8) : const Color(0xFF00B993);

    return Scaffold(
      drawer: _AppDrawer(
        selectedIndex: _pageIndex,
        onSelect: (index) {
          Navigator.of(context).pop();
          _goToPage(index);
        },
      ),
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Школьное\nприложение'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF00C9A7),
              child: Icon(
                Icons.person_outline,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _TopChip(
                  text: 'Расписание',
                  active: _pageIndex == 0,
                  accentColor: accentLabel,
                  onTap: () => _goToPage(0),
                ),
                const SizedBox(width: 8),
                _TopChip(
                  text: 'Новости',
                  active: _pageIndex == 1,
                  accentColor: accentLabel,
                  onTap: () => _goToPage(1),
                ),
                const SizedBox(width: 8),
                _TopChip(
                  text: 'Тема',
                  active: _pageIndex == 2,
                  accentColor: accentLabel,
                  onTap: () => _goToPage(2),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              children: [
                const SchedulePage(),
                const NewsPage(),
                ThemeSettingsPage(
                  themeMode: widget.themeMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopChip extends StatelessWidget {
  const _TopChip({
    required this.text,
    required this.active,
    required this.accentColor,
    required this.onTap,
  });

  final String text;
  final bool active;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: active ? accentColor.withValues(alpha: 0.25) : Colors.transparent,
            border: Border.all(
              color: active ? accentColor : Theme.of(context).dividerColor,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? accentColor : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static const lessons = [
    ('Математика', 'Иванова А.П.', '08:30 - 09:15', 'Кабинет 204'),
    ('Русский язык', 'Петрова С.В.', '09:25 - 10:10', 'Кабинет 301'),
    ('История', 'Сидоров И.И.', '10:20 - 11:05', 'Кабинет 108'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      children: [
        Text('Расписание уроков', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Класс 9Б', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _dayPill(context, 'Понедельник', true),
              _dayPill(context, 'Вторник', false),
              _dayPill(context, 'Среда', false),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...lessons.asMap().entries.map(
          (entry) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF2B2E35) : const Color(0xFFE2E5EC),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.value.$1,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8F0EA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Урок ${entry.key + 1}'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(entry.value.$2, style: Theme.of(context).textTheme.bodyMedium),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metaRow(icon: Icons.schedule, text: entry.value.$3),
                    _metaRow(icon: Icons.location_pin, text: entry.value.$4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dayPill(BuildContext context, String label, bool selected) {
    final bg = selected
        ? const LinearGradient(colors: [Color(0xFF23C2E7), Color(0xFF00CA70)])
        : null;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        gradient: bg,
        color: selected ? null : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _metaRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFB14D6A)),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        Text('Новости школы', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'Все актуальные события и объявления',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        ...List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              gradient: AppThemes.cyanGreenGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          index == 0
                              ? 'Начало нового учебного года'
                              : 'Спортивный турнир между классами',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 4),
                      Text(index == 0 ? '1 сентября 2026' : '14 февраля 2026'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '1 сентября наша школа открыла двери для всех учеников. '
                    'Торжественная линейка прошла успешно, все ученики получили... ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(height: 22),
                  const Row(
                    children: [
                      Icon(Icons.favorite_border),
                      SizedBox(width: 6),
                      Text('124'),
                      SizedBox(width: 24),
                      Icon(Icons.mode_comment_outlined),
                      SizedBox(width: 6),
                      Text('18'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkActive = themeMode == ThemeMode.dark;
    final isLightActive = themeMode == ThemeMode.light;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        Text('Тема оформления', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'Выберите внешний вид приложения',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 14),
        _themeCard(
          context,
          cardKey: const Key('light-theme-card'),
          icon: Icons.wb_sunny_outlined,
          title: 'Светлая тема',
          subtitle: 'Классический светлый дизайн',
          active: isLightActive,
          onTap: () => onThemeChanged(ThemeMode.light),
          iconBackground: const Color(0xFFF5EAB9),
        ),
        const SizedBox(height: 12),
        _themeCard(
          context,
          cardKey: const Key('dark-theme-card'),
          icon: Icons.dark_mode_outlined,
          title: 'Тёмная тема',
          subtitle: 'Полночный мрак для комфорта',
          active: isDarkActive,
          onTap: () => onThemeChanged(ThemeMode.dark),
          iconBackground: const Color(0xFF2B3D63),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFCBEDED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF85DCD8)),
          ),
          child: const Text(
            'Тёмная тема с полночным мраком (#0B0B0E) помогает снизить '
            'нагрузку на глаза при использовании приложения в тёмное время суток.',
            style: TextStyle(color: Color(0xFF1D3154), fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _themeCard(
    BuildContext context, {
    required Key cardKey,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool active,
    required VoidCallback onTap,
    required Color iconBackground,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        key: cardKey,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFF09C1EC) : Theme.of(context).dividerColor,
            width: active ? 2 : 1,
          ),
          color: Theme.of(context).cardColor,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: const Color(0xFF03C7BA).withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: iconBackground,
              ),
              child: Icon(icon, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            if (active)
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF00BA8F),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.home_outlined, 'Главное', 0),
      (Icons.calendar_today_outlined, 'Расписание', 0),
      (Icons.info_outline, 'Доп информация', 1),
      (Icons.settings_outlined, 'Настройки', 2),
    ];

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(34)),
      ),
      child: Container(
        decoration: const BoxDecoration(gradient: AppThemes.cyanGreenGradient),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Меню',
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              const Divider(color: Colors.white54),
              ...items.map((item) {
                final active = item.$3 == selectedIndex;
                return ListTile(
                  onTap: () => onSelect(item.$3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  tileColor: active ? Colors.white.withValues(alpha: 0.92) : null,
                  leading: Icon(
                    item.$1,
                    color: active ? const Color(0xFF059FC8) : Colors.white,
                  ),
                  title: Text(
                    item.$2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: active ? const Color(0xFF0582B4) : Colors.white,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
