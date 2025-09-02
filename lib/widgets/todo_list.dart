import 'package:flutter/material.dart';
import '../services/todo_service.dart';
// import 'package:intl/date_symbol_data_local.dart'; // 日本語などロケール情報を読み込む

import '../models/todo.dart'; // 作成したTodoクラス
import '../widgets/todo_card.dart'; // 作成したTodoCardウィジェット

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.todoService});
  final TodoService todoService;

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  // テスト用のTodoデータ（あとで追加画面から動的に増える想定）
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos(); // ←追加 SharedPreferences から読み込み
  }

  // データ読み込み処理関数を追加
  Future<void> _loadTodos() async {
    final todos = await widget.todoService.getTodos();
    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  // 追加画面から呼ばれる追加関数を追加
  void addTodo(Todo newTodo) async {
    setState(() => _todos.add(newTodo));
    await widget.todoService.saveTodos(_todos);
  }

  // チェックボタンから呼ばれる削除関数を追加
  Future<void> _deleteTodo(Todo todo) async {
    setState(() => _todos.removeWhere((t) => t.id == todo.id));
    await widget.todoService.saveTodos(_todos);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // 読込中はローディングインジケーターを表示
      return const Center(child: CircularProgressIndicator());
    }
    // 完了は後ろ、未完了は締め切り順にソート
    _todos.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) return 1;
      if (!a.isCompleted && b.isCompleted) return -1;
      return a.dueDate.compareTo(b.dueDate);
    });

    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TodoCard(
            todo: todo,
            onToggle: () async {
              setState(() {
                todo.isCompleted = !todo.isCompleted; // 完了トグル
              });
              await widget.todoService.saveTodos(_todos);
            },
            onDelete: () async {
              await _deleteTodo(todo); // 削除処理
            },
          ),
        );
      },
    );
  }
}
