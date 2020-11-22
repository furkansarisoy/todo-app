import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/model/todos.dart';
import 'package:todo_app/utils/decoration.dart';

// ignore: must_be_immutable
class AddTodo extends StatefulWidget {
  AddTodo(this.todos, this.userId);
  final String userId;
  List<Todos> todos = List<Todos>();

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  var formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  Todos todo;

  _addNewTodo(String todoItem) {
    Todos todo = new Todos(todoItem.toString(), widget.userId, false);
    FirebaseDatabase.instance
        .reference()
        .child("todo")
        .push()
        .set(todo.toJson());
    print("Todo Item and userid${todoItem + widget.userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Yeni Kayıt",
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: Container(
          decoration: kBoxDecorationStyle(),
          child: Padding(
            padding: EdgeInsets.only(bottom: 100, left: 32, right: 32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textBuilder(),
                  submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textBuilder() {
    return TextFormField(
      controller: _textEditingController,
      validator: (value) {
        if (value.isNotEmpty) {
          return null;
        } else
          return 'Boş iş iş değildir !';
      },
      decoration: InputDecoration(
        hintText: 'Yapılacak bir şeyler yaz',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget submitButton() {
    return Container(
      padding: EdgeInsets.only(top: 32),
      child: RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            _addNewTodo(_textEditingController.text.toString());
            Navigator.pop(context);
          }
        },
        color: Theme.of(context).primaryColor,
        child: Text(
          "Kaydet",
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),
      ),
    );
  }
}
