import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart'; // 日付フォーマット用パッケージ
import 'glitter_check_button.dart';

class TodoCard extends StatelessWidget {
  final Todo todo; // 表示する Todo データ
  final VoidCallback? onToggle; // 完了トグル用コールバック（任意）
  final VoidCallback? onDelete; // ←追加：削除ボタン用

  const TodoCard({super.key, required this.todo, this.onToggle, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      todo.dueDate.year,
      todo.dueDate.month,
      todo.dueDate.day,
    );

    // ===== カードの色を条件で決定 =====
    Color cardColor;
    if (todo.isCompleted) {
      cardColor = const Color.fromARGB(210, 158, 158, 158); // 完了済み
    } else if (dueDate.isBefore(today)) {
      cardColor = const Color.fromARGB(255, 0, 0, 0); // 期限切れ
    } else if (dueDate == today) {
      cardColor = const Color.fromARGB(255, 121, 0, 0); // 今日が期限
    } else if (dueDate.isBefore(today.add(const Duration(days: 4)))) {
      // 今日の翌日から3日以内
      cardColor = const Color.fromARGB(255, 178, 143, 4); // 3日以内（黄色など）
    } else {
      cardColor = const Color.fromARGB(255, 1, 94, 170); // 通常
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── 左端：チェックアイコン（タップでトグル）
            // IconButton(
            //   iconSize: 32,
            //   icon: Icon(
            //     todo.isCompleted
            //         ? Icons
            //               .check_circle // チェック済み
            //         : Icons.radio_button_unchecked, // 未チェック
            //     color: Colors.white,
            //   ),
            //   onPressed: onToggle,
            // ),
            GlitterCheckButton(
              isCompleted: todo.isCompleted,
              onToggle: onToggle,
            ),
            const SizedBox(width: 8),
            // ── テキスト群
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    todo.detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    DateFormat('M月d日(E)', 'ja').format(todo.dueDate),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // 右側：削除ボタン
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('削除の確認'),
                    content: const Text('本当にこのタスクを削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(false), // キャンセル
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true), // OK
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && onDelete != null) {
                  onDelete!(); // 実際に削除する
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
