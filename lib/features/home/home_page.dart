import 'package:flutter/material.dart';
import '../tests/test_list_page.dart';
import '../chat/chat_page.dart';
import '../stars/star_field_page.dart';
import '../../widgets/test_card.dart';
import '../../widgets/app_button.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const HomePage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Обучающее приложение"),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: onThemeToggle,
            tooltip: 'Сменить тему',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Звёздное поле
          AnimatedTestCard(
            title: "Звёздное поле",
            subtitle: "Интерактивная анимация",
            icon: Icons.star,
            accentColor: Colors.amber,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const StarFieldPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            ),
          ),
          // Тесты
          AnimatedTestCard(
            title: "Тесты",
            subtitle: "Проверь свои знания",
            icon: Icons.assignment,
            accentColor: Colors.green,
            questionCount: 3,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const TestListPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            ),
          ),
          // AI ассистент
          AnimatedTestCard(
            title: "AI ассистент",
            subtitle: "Умный помощник",
            icon: Icons.smart_toy,
            accentColor: Colors.purple,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ChatPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Кнопка быстрого доступа
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              text: "Начать тест",
              icon: Icons.play_arrow,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestListPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
