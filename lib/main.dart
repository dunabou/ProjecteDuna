import 'car.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:projecte_dunabou/car.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'RestFast';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
          brightness: Brightness.dark,

          // Define the default font family.
          fontFamily: 'Arial'),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'RestFast',
                  style: TextStyle(
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 50),

                )),
            Container(
                child: Image.asset('assets/logo.png'
                  ,

                )

            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Inici'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> MyHomePage()),
                    );
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )
            ),

          ],
        ));
  }
}
//----------------------inserir,update-----------------------
void main() => runApp(MyApp());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  List<Car> cars = [];
  List<Car> carsByName = [];

  //controllers used in insert operation UI
  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();
  TextEditingController capacitatController = TextEditingController();


  //controllers used in update operation UI
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController milesUpdateController = TextEditingController();
  TextEditingController capacitatUpdateController = TextEditingController();

  //controllers used in delete operation UI
  TextEditingController idDeleteController = TextEditingController();

  //controllers used in query operation UI
  TextEditingController queryController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(

          bottom: TabBar(
            tabs: [
              Tab(
                text: "Inserir",
              ),
              Tab(
                text: "Llistar",
              ),
              Tab(
                text: "Buscar",
              ),
              Tab(
                text: "Actualitzar",
              ),
              Tab(
                text: "Esborrar",
              ),
            ],
          ),
          title: Text('RestFast'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nom Restaurant',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Estrelles',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: capacitatController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Capacitat',
                      ),
                    ),
                  ),

                  RaisedButton(
                    color: Colors.lightGreen,
                    child: Text('Inserir Restaurant'),
                    onPressed: () {
                      String nom = nameController.text;
                      int estrelles = int.parse(milesController.text);
                      int capacitat = int.parse(capacitatController.text);
                      _insert(nom, estrelles, capacitat);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cars.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == cars.length) {
                    return RaisedButton(
                      color: Colors.lightGreen,
                      child: Text('Refrescar'),
                      onPressed: () {
                        setState(() {
                          _queryAll();
                        });
                      },
                    );
                  }
                  return Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        '[${cars[index].id}] ${cars[index].nom} - ${cars[index].estrelles} estrelles',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: queryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nom Restaurant',
                      ),
                      onChanged: (text) {
                        if (text.length >= 2) {
                          setState(() {
                            _query(text);
                          });
                        } else {
                          setState(() {
                            carsByName.clear();
                          });
                        }
                      },
                    ),
                    height: 100,
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: carsByName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          child: Center(
                            child: Text(
                              '[${carsByName[index].id}] ${carsByName[index].nom} - ${carsByName[index].estrelles} estrelles',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: idUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'id Restaurant',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nom Restaurant',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Estrelles',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: capacitatUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Capacitat',
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.lightGreen,
                    child: Text('Actualitzar Restaurant'),
                    onPressed: () {
                      int id = int.parse(idUpdateController.text);
                      String nom = nameUpdateController.text;
                      int estrelles = int.parse(milesUpdateController.text);
                      int capacitat = int.parse(capacitatUpdateController.text);
                      _update(id, nom, estrelles, capacitat);
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: idDeleteController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'id Restaurant',
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text('Eliminar'),
                    onPressed: () {
                      int id = int.parse(idDeleteController.text);
                      _delete(id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insert(nom, estrelles, capacitat) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNom: nom,
      DatabaseHelper.columnEstrelles: estrelles,
      DatabaseHelper.columnCapacitat: capacitat,
    };
    Car car  = Car.fromMap(row);
    final id = await dbHelper.insert(car);
    _showMessageInScaffold('inserir fila id: $id');
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row) => cars.add(Car.fromMap(row)));
    _showMessageInScaffold('Busqueda feta.');
    setState(() {});
  }

  void _query(nom) async {
    final allRows = await dbHelper.queryRows(nom);
    carsByName.clear();
    allRows.forEach((row) => carsByName.add(Car.fromMap(row)));
  }

  void _update(id, nom, estrelles, capacitat) async {
    // row to update
    Car car = Car(id, nom, estrelles, capacitat);
    final rowsAffected = await dbHelper.update(car);
    _showMessageInScaffold('Actualitcació $rowsAffected fila(s)');
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('eliminat $rowsDeleted fila(s): fila $id');
  }
}