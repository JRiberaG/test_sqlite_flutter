import 'package:flutter/material.dart';
import 'package:test_sqlite/models/dog.dart';
import 'package:test_sqlite/utils/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'Flutter SQLite demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        // Sets the decoration for the inputs
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          // Decoration for whenever it does not has the focus
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey[300]),
            gapPadding: 40,
          ),
          // Decoration for whenever it has the focus
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[600]),
              gapPadding: 8),
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              deleteAllTheDoggies();
            },
          ),
        ],
      ),
      body: MyBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.remove_red_eye),
        onPressed: () {
          printAllDogsInDatabase();
        },
      ),
    );
  }
}

class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  // Objects to get the values of the TextFields
  final _controllerId = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerAge = TextEditingController();

  // Object to select the focus
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextFormField(
              focusNode: focusNode,
              controller: _controllerId,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID',
//                  hintText: 'Dog's ID',
                prefixIcon: Icon(Icons.perm_identity),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _controllerName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Name',
//                  hintText: 'Dog's name',
                  prefixIcon: Icon(Icons.featured_video)),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _controllerAge,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Age',
//                  hintText: 'Dog\'s age'',
                  prefixIcon: Icon(Icons.confirmation_num_sharp)),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 260,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          // Clears the TextFormFields
                          _controllerId.clear();
                          _controllerName.clear();
                          _controllerAge.clear();

                          // Focuses the ID field
                          focusNode.requestFocus();
                        },
                        color: Colors.red,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 260,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          String id = _controllerId.text.trim();
                          String name = _controllerName.text.trim();
                          String age = _controllerAge.text.trim();
                          checkFields(id, name, age);
                        },
                        color: Colors.blue[400],
                        child: Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void insertIntoDB(String id, String name, String age) async {
    try {
      int idAsInt = int.parse(id);
      int ageAsInt = int.parse(age);

      Dog dog = new Dog(id: idAsInt, name: name, age: ageAsInt);
      await DbHelper.db.insertDog(dog);

      print('Dog was inserted successfully.');
    } on FormatException catch (e) {
      print(
          'There was an error trying to insert the dig into the database: $e.');
    }
  }

  void checkFields(String id, String name, String age) {
    bool idOk = false, nameOk = false, ageOk = false;

    if (id.isEmpty) {
      print('Error: ID cannot be empty');
    } else {
      idOk = true;
    }

    if (name.isEmpty) {
      print('Error: name cannot be empty');
    } else {
      nameOk = true;
    }

    if (age.isEmpty) {
      print('Error: age cannot be empty');
    } else {
      ageOk = true;
    }

    if (idOk && ageOk && nameOk) {
      insertIntoDB(id, name, age);
    }

  }
}

void deleteAllTheDoggies() async {
  print('Deleting all the stored dogs...');
  DbHelper.db.deleteDogs();
  print('All doggies have been removed.');
}

void printAllDogsInDatabase() async {
  print('Printing dogs...');
  int i = 0;

  List<Dog> dogs = await DbHelper.db.getDogs();
  dogs.forEach((dog) {
    print(dog.toString());
    i++;
  });

  print('$i dogs printed');
}
