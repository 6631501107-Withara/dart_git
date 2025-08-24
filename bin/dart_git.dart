// dart_application_1.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


// =================== Config ===================
const String baseUrl = 'http://localhost:3000';
const String baht = '฿';

//------ 1. register -------------------------------------------------
Future<void> register() async {
 stdout.writeln('===== Register =====');
  final username = _readLine('Username: ');
  final password = _readLine('Password: ');
  if (username.isEmpty || password.isEmpty) {
    stdout.writeln('Invalid input.\n');
    return;
  }

  final uri = Uri.parse('$baseUrl/register');
  final res = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (res.statusCode == 200) {
    stdout.writeln('Register success!\n');
  } else {
    stdout.writeln('Register failed: ${res.body}\n');
  }




 }

//------ 2. login ----------------------------------------------------
Future<int?> login(String username, String password) async {
   final uri = Uri.parse('$baseUrl/login');
  final res = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    stdout.writeln(data['message']);
    return data['userId'];
  } else {
    stdout.writeln('Login failed: ${res.body}');
    return null;
  }




}

// ================= Utilities ==================
void _line([String title = '']) {
  if (title.isEmpty) {
    stdout.writeln('------------------------------------------');
  } else {
    stdout.writeln('------------ $title ------------');
  }
}

String _readLine(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync() ?? '';
}

int? _readInt(String prompt) {
  final s = _readLine(prompt);
  return int.tryParse(s);
}

void _printExpenses(List<dynamic> items, {required String header}) {
  _line(header);
  int total = 0;
  for (final exp in items) {
    final id = exp['id'] ?? '';
    final item = exp['item'];
    final paid = int.tryParse(exp['paid'].toString()) ?? 0;
    final date = exp['date'];
    stdout.writeln('$id. $item : $paid$baht : $date');
    total += paid;
  }
  stdout.writeln('Total expenses = $total$baht\n');
}

//------ 3. today ----------------------------------------------------
Future<void> showTodayExpenses(int userId) async {
   final uri = Uri.parse('$baseUrl/expenses/today/$userId');
  final res = await http.get(uri);

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    if (data.isEmpty) {
      _line("Today's expenses");
      stdout.writeln('No item.\n');
    } else {
      _printExpenses(data, header: "Today's expenses");
    }
  } else {
    stdout.writeln('Error: ${res.body}');
  }





}

//------ 4. all ------------------------------------------------------
Future<void> showAllExpenses(int userId) async {
   final uri = Uri.parse('$baseUrl/expenses/$userId');
  final res = await http.get(uri);

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    if (data.isEmpty) {
      _line('All expenses');
      stdout.writeln('No item.\n');
    } else {
      _printExpenses(data, header: 'All expenses');
    }
  } else {
    stdout.writeln('Error: ${res.body}');
  }




}

//------ 5. search ---------------------------------------------------
Future<void> searchExpenses(int userId) async {
  final keyword = _readLine('Item to search: ');
  final uri = Uri.parse('$baseUrl/expenses/search')
      .replace(queryParameters: {'userId': userId.toString(), 'q': keyword});
  final res = await http.get(uri);

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as List<dynamic>;
    if (data.isEmpty) {
      stdout.writeln('No item: $keyword\n');
    } else {
      _printExpenses(data, header: 'Search result');
    }
  } else {
    stdout.writeln('Error: ${res.body}');
  }



}

//------ 7. add ------------------------------------------------------
Future<void> addExpense(int userId) async {
  stdout.writeln('===== Add new item =====');
  final item = _readLine('Item: ');
  final paid = _readInt('Paid: ');

  if (item.isEmpty || paid == null) {
    stdout.writeln('Invalid input.\n');
    return;
  }

  final uri = Uri.parse('$baseUrl/expenses');
  final res = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': userId, 'item': item, 'paid': paid}),
  );

  if (res.statusCode == 201 || res.statusCode == 200) {
    stdout.writeln('Inserted!\n');
    await showAllExpenses(userId); 
  } else {
    stdout.writeln('Insert failed: ${res.body}\n');
  }





}

//------ 8. deleted --------------------------------------------------
Future<void> deleteExpense() async {
  stdout.writeln('===== Delete an item =====');
  final id = _readInt('Item id: ');
  if (id == null) {
    stdout.writeln('Invalid id.\n');
    return;
  }

  final uri = Uri.parse('$baseUrl/expenses/$id');
  final res = await http.delete(uri);

  if (res.statusCode == 200) {
    stdout.writeln('Deleted!\n');
  } else if (res.statusCode == 404) {
    stdout.writeln('Not found.\n');
  } else {
    stdout.writeln('Delete failed: ${res.body}\n');
  }







}

//------ 6. app (menu & loop) ---------------------------------------
void main() async {
  // ถ้าอยากเปิดให้สมัครสมาชิกก่อนล็อกอิน ให้ย้าย register ไปไว้ในเมนูด้านล่าง
  final username = _readLine('Username: ');
  final password = _readLine('Password: ');
  if (username.isEmpty || password.isEmpty) return;

  final userId = await login(username, password);
  if (userId == null) return;

  while (true) {
    stdout.writeln('======== Expense Tracking App ========');
    stdout.writeln('Welcome $username');
    stdout.writeln('0. Register (optional)');
    stdout.writeln('1. All expenses');
    stdout.writeln("2. Today's expense");
    stdout.writeln('3. Search expense');
    stdout.writeln('4. Add new expense');
    stdout.writeln('5. Delete an expense');
    stdout.writeln('6. Exit');
    final choice = _readLine('Choose... ');

    if (choice == '0') {
      await register();
    } else if (choice == '1') {
      await showAllExpenses(userId);
    } else if (choice == '2') {
      await showTodayExpenses(userId);
    } else if (choice == '3') {
      await searchExpenses(userId);
    } else if (choice == '4') {
      await addExpense(userId);
    } else if (choice == '5') {
      await deleteExpense();
    } else if (choice == '6') {
      stdout.writeln('----- Bye -------');
      break;
    } else {
      stdout.writeln('Invalid choice\n');
    }
  }
}
//