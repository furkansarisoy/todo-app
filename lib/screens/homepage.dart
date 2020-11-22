import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/addTodo.dart';
import 'package:todo_app/services/auth.dart';
import '../model/todos.dart';
import 'package:todo_app/utils/decoration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Query _todoQuery;
  List<Todos> todos;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    todos = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _todoQuery.onChildAdded.listen(onEntryAdded);
  }

  onEntryAdded(Event event) {
    setState(() {
      todos.add(Todos.fromSnapshpt(event.snapshot));
    });
  }

  int _selectedIndex = 0;
  Widget _widgetOptions(int index) {
    if (index == 0) {
      return _todosArea();
    }
    if (index == 1) {
      return Text("asd");
    }
    if (index == 2) {
      return Text("qwe");
    }
    return null;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () => context.read<AuthenticationService>().signOut()),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: floatingActionButtonBuilder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("todo'",
                style: GoogleFonts.secularOne(
                  color: Theme.of(context).primaryColor,
                  fontSize: 60,
                )),
            _widgetOptions(_selectedIndex)
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBuilder(),
    );
  }

  Widget floatingActionButtonBuilder() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTodo(todos, widget.userId)))
            .then((value) => setState(() {}));
      },
      child: Icon(Icons.add),
    );
  }

  Widget _todosArea() {
    if (todos.isEmpty) {
      return Container();
    } else {
      return Expanded(
        child: Container(
          decoration: kBoxDecorationStyle(),
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final item = todos[index].key;
              return Dismissible(
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Icon(Icons.delete, color: Colors.white),
                        ]),
                  ),
                  key: Key(item),
                  onDismissed: (direction) {
                    _database
                        .reference()
                        .child("todo")
                        .child(item)
                        .remove()
                        .then((value) => Scaffold.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("${todos[index].title} Silindi."))));
                    setState(() {
                      todos.removeAt(index);
                    });
                  },
                  child: listofItems(index));
            },
          ),
        ),
      );
    }
  }

  Widget listofItems(index) {
    return ListTile(
      title: Text(todos[index].title,
          style: GoogleFonts.sourceSansPro(fontSize: 20)),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            todos[index].isDone = !todos[index].isDone;
            if (todos[index] != null) {
              _database
                  .reference()
                  .child("todo")
                  .child(todos[index].key)
                  .set(todos[index].toJson());
            }
          });
        },
        icon: todos[index].isDone
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              )
            : Icon(Icons.radio_button_unchecked),
      ),
    );
  }

  Widget bottomNavigationBuilder() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.done_all), title: Text("Tümü")),
        BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty), title: Text("Devam Edenler")),
        BottomNavigationBarItem(icon: Icon(Icons.done), title: Text("Bitenler"))
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
