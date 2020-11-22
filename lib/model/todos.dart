import 'package:firebase_database/firebase_database.dart';

class Todos {
  String key;
  String title;
  String userId;
  bool isDone = false;

  Todos(this.title, this.userId, this.isDone);
  Todos.fromSnapshpt(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        title = snapshot.value["title"],
        isDone = snapshot.value["isDone"];

  toJson() {
    return {"userId": userId, "title": title, "isDone": isDone};
  }
}
