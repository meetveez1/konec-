import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const String kFlutterVersion = '3.35.x';
const String kDartVersion = '3.11.x';

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

  void _toggleTheme(bool useDark) {
    setState(() {
      _themeMode = useDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Школьное приложение',
      themeMode: _themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

ThemeData _buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF2F4F8),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C8C8)),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFE0E0E0)),
  );
}

ThemeData _buildDarkTheme() {
  const midnight = Color(0xFF0B0B0E);
  const header = Color(0xFF1A1C22);

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: midnight,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00D4C8),
      secondary: Color(0xFF3DDC84),
      surface: Color(0xFF14161B),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: header),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    setState(() => _currentPage = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _onMouseWheel(PointerSignalEvent signal) {
    if (signal is PointerScrollEvent) {
      final delta = signal.scrollDelta.dy;
      if (delta > 0 && _currentPage < 2) {
        _goToPage(_currentPage + 1);
      } else if (delta < 0 && _currentPage > 0) {
        _goToPage(_currentPage - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final pageBackground = isDark ? const Color(0xFF0B0B0E) : const Color(0xFFF2F4F8);
    final cardColor = isDark ? const Color(0xFF14161B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF121626);
    final secondaryText = isDark ? Colors.white70 : const Color(0xFF576074);

    return Scaffold(
      drawer: _AppDrawer(
        selectedIndex: _pageIndex,
        onSelect: (index) {
          Navigator.of(context).pop();
          _goToPage(index);
        },
      ),
      appBar: AppBar(
        title: const Text('Школьное\nприложение', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF00C8A8),
              child: const Icon(Icons.person_outline, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: _MenuDrawer(selectedPage: _currentPage, onTap: _goToPage),
      body: Listener(
        onPointerSignal: _onMouseWheel,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _SchedulePage(
              background: pageBackground,
              cardColor: cardColor,
              textColor: textColor,
              secondaryText: secondaryText,
            ),
            _NewsPage(
              background: pageBackground,
              cardColor: cardColor,
              textColor: textColor,
              secondaryText: secondaryText,
            ),
            _ThemePage(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,
              background: pageBackground,
              cardColor: cardColor,
              textColor: textColor,
              secondaryText: secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDrawer extends StatelessWidget {
  const _MenuDrawer({required this.selectedPage, required this.onTap});

  final int selectedPage;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2CB8D0), Color(0xFF00C86D)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Text('Меню', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
              ),
              _menuTile(context, Icons.home_outlined, 'Главное', 0),
              _menuTile(context, Icons.newspaper_outlined, 'Новости', 1),
              _menuTile(context, Icons.settings_outlined, 'Настройки', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String label, int index) {
    final selected = selectedPage == index;
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: selected ? Colors.white.withOpacity(0.2) : null,
      onTap: () {
        Navigator.pop(context);
        onTap(index);
      },
    );
  }
}

class _SchedulePage extends StatelessWidget {
  const _SchedulePage({
    required this.background,
    required this.cardColor,
    required this.textColor,
    required this.secondaryText,
  });

  final Color background;
  final Color cardColor;
  final Color textColor;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    final days = ['Понедельник', 'Вторник', 'Среда'];
    return Container(
      color: background,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Расписание уроков', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 8),
          Text('Класс 9Б', style: TextStyle(fontSize: 21, color: secondaryText)),
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == 0;
                return Chip(
                  label: Text(days[i], style: TextStyle(color: selected ? Colors.white : secondaryText, fontWeight: FontWeight.w600)),
                  backgroundColor: selected ? const Color(0xFF00C8A8) : cardColor,
                  side: BorderSide(color: selected ? Colors.transparent : secondaryText.withOpacity(0.2)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _lessonCard('Математика', 'Иванова А.П.', '08:30 - 09:15', 'Кабинет 204'),
          _lessonCard('Русский язык', 'Петрова С.В.', '09:25 - 10:10', 'Кабинет 301'),
        ],
      ),
    );
  }

  Widget _lessonCard(String title, String teacher, String time, String room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 30))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFCCF7EF), borderRadius: BorderRadius.circular(30)),
                child: const Text('Урок', style: TextStyle(color: Color(0xFF00A8C0), fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(teacher, style: TextStyle(color: secondaryText, fontSize: 20)),
          const SizedBox(height: 10),
          Divider(color: secondaryText.withOpacity(0.15)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🕘 $time', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
              Text('📍 $room', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewsPage extends StatelessWidget {
  const _NewsPage({
    required this.background,
    required this.cardColor,
    required this.textColor,
    required this.secondaryText,
  });

  final Color background;
  final Color cardColor;
  final Color textColor;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Новости школы', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 8),
          Text('Все актуальные события и объявления', style: TextStyle(fontSize: 20, color: secondaryText)),
          const SizedBox(height: 16),
          _newsCard(
            'Начало нового учебного года',
            '1 сентября 2026',
            '1 сентября наша школа открыла двери для всех учеников. Торжественная линейка прошла успешно...',
          ),
          _newsCard(
            'Спортивный турнир между классами',
            '14 февраля 2026',
            'Команды 8-11 классов встретились в дружеском соревновании. Победители получили кубок школы.',
          ),
        ],
      ),
    );
  }

  Widget _newsCard(String title, String date, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.transparent, width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xFF2CC7D0), Color(0xFF00CC77)],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 32)),
            const SizedBox(height: 6),
            Text('🕒 $date', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(body, style: TextStyle(color: secondaryText, fontSize: 20, height: 1.4)),
            const SizedBox(height: 12),
            Divider(color: secondaryText.withOpacity(0.15)),
            const SizedBox(height: 6),
            Text('♡ 124    💬 18', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ThemePage extends StatelessWidget {
  const _ThemePage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.background,
    required this.cardColor,
    required this.textColor,
    required this.secondaryText,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Color background;
  final Color cardColor;
  final Color textColor;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Тема оформления', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 8),
          Text('Выберите внешний вид приложения', style: TextStyle(fontSize: 20, color: secondaryText)),
          const SizedBox(height: 16),
          _themeTile(
            icon: Icons.sunny,
            title: 'Светлая тема',
            subtitle: 'Классический светлый дизайн',
            selected: !isDarkMode,
            onTap: () => onThemeChanged(false),
          ),
          const SizedBox(height: 12),
          _themeTile(
            icon: Icons.nightlight_round,
            title: 'Темная тема',
            subtitle: 'Полночный мрак для комфорта',
            selected: isDarkMode,
            onTap: () => onThemeChanged(true),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00C8A8).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Темная тема с полночным мраком (#0B0B0E) помогает снизить нагрузку на глаза в темное время суток.\n\nВерсии SDK:\nFlutter: $kFlutterVersion\nDart: $kDartVersion',
              style: TextStyle(color: textColor, height: 1.5, fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? const Color(0xFF00C8D4) : secondaryText.withOpacity(0.2), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selected
                      ? const [Color(0xFF2CC7D0), Color(0xFF00CC77)]
                      : [secondaryText.withOpacity(0.1), secondaryText.withOpacity(0.25)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: selected ? Colors.white : secondaryText),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 24)),
                  Text(subtitle, style: TextStyle(color: secondaryText, fontSize: 18)),
                ],
              ),
            ),
            if (selected)
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF00C8A8),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
