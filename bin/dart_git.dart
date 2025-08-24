// dart_application_1.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


// =================== Config ===================
const String baseUrl = 'http://localhost:3000';
const String baht = '฿';

//------ 1. register -------------------------------------------------
Future<void> register() async {




 }

//------ 2. login ----------------------------------------------------
Future<int?> login(String username, String password) async {
  



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
  




}

//------ 4. all ------------------------------------------------------
Future<void> showAllExpenses(int userId) async {
  



}

//------ 5. search ---------------------------------------------------
Future<void> searchExpenses(int userId) async {
 



}

//------ 7. add ------------------------------------------------------
Future<void> addExpense(int userId) async {
  




}

//------ 8. deleted --------------------------------------------------
Future<void> deleteExpense() async {
  






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
