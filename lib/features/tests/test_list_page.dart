import 'package:flutter/material.dart';
import 'test_page.dart';
import '../../widgets/test_card.dart';

class TestListPage extends StatelessWidget {
  const TestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tests = [
      {
        'title': "Входное тестирование",
        'subtitle': 'Оценка начальных знаний',
        'icon': Icons.assignment_ind,
        'color': Colors.blue,
        'questions': 10,
      },
      {
        'title': "Математика: Таблица умножения",
        'subtitle': 'Базовые навыки',
        'icon': Icons.calculate,
        'color': Colors.orange,
        'questions': 20,
      },
      {
        'title': "Русский язык: Типы текста",
        'subtitle': 'Знание текстовых форм',
        'icon': Icons.text_fields,
        'color': Colors.green,
        'questions': 15,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Тесты")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tests.length,
        itemBuilder: (_, index) {
          final test = tests[index];
          return AnimatedTestCard(
            title: test['title'] as String,
            subtitle: test['subtitle'] as String,
            icon: test['icon'] as IconData,
            accentColor: test['color'] as Color,
            questionCount: test['questions'] as int?,
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TestPage(
                  title: test['title'] as String,
                ),
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
          );
        },
      ),
    );
  }
}
