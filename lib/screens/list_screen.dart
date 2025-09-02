import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import 'package:todo_app/screens/calendar_screen.dart';
import 'package:todo_app/services/todo_service.dart';
import '../widgets/todo_list.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key, required this.todoService});
  final TodoService todoService;

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'T',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 74, 2, 150),
                  ),
                ),
                TextSpan(
                  text: 'ODO ',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 65, 65, 65),
                  ),
                ),
                TextSpan(
                  text: 'L',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 74, 2, 150),
                  ),
                ),
                TextSpan(
                  text: 'IST',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 65, 65, 65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          TodoList(key: _listKey, todoService: widget.todoService),

          // 左下カレンダーボタン
          Positioned(
            left: 20,
            bottom: 40,
            child: SizedBox(
              width: 60, // 56 × 1.2
              height: 60,
              child: FloatingActionButton(
                heroTag: 'calendar',
                backgroundColor: const Color.fromARGB(255, 203, 199, 206),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 32, // アイコンも大きく（通常は24）
                ),
              ),
            ),
          ),
        ],
      ),

      // 右下タスク追加ボタン
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTodoScreen(todoService: widget.todoService),
            ),
          );
          if (updated == true) {
            setState(() {
              _listKey = UniqueKey();
            });
          }
        },
        backgroundColor: const Color.fromARGB(255, 74, 2, 150),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
