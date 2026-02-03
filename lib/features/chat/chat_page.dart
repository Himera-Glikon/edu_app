import 'package:flutter/material.dart';
import '../../widgets/app_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final messages = <Map<String, dynamic>>[];

  void _sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'text': controller.text,
        'isUser': true,
        'time': DateTime.now(),
      });
    });

    // Симуляция ответа AI
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        messages.add({
          'text': 'Это тестовый ответ AI. Здесь будет подключение к AI сервису.',
          'isUser': false,
          'time': DateTime.now(),
        });
      });
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("AI ассистент")),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smart_toy,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Начните разговор с AI',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final message = messages[i];
                      final isUser = message['isUser'] as bool;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? (isDark ? Colors.blue.shade700 : Colors.blue)
                                : (isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomLeft: isUser
                                  ? const Radius.circular(16)
                                  : const Radius.circular(4),
                              bottomRight: isUser
                                  ? const Radius.circular(4)
                                  : const Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            message['text'] as String,
                            style: TextStyle(
                              color: isUser ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Ввод сообщения
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: controller,
                    hintText: 'Введите сообщение...',
                    prefixIcon: Icons.message,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  backgroundColor: isDark ? Colors.blue.shade400 : Colors.blue,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
