import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ingredientlist.dart';
import 'searchbyingredient.dart';
import 'apifetchers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Search',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cocktail Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late Future<List<String>> futureIngredientList;
  late Future<List<DrinkFromSearch>> futureSearchResult;
  List<DrinkFromSearch> drinkFromSearchList = [];
  List<String> ingredientList = [];
  String selectedIngredient = 'Vodka';

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }




  @override
  void initState(){
    super.initState();
    ApiFetchers api = ApiFetchers();
    futureIngredientList = api.fetchIngredientList();
    fillIngredientList();
    print(ingredientList.length.toString() + "length");
  }

  void fillDrinksFromSearchList() async {
    drinkFromSearchList = await futureSearchResult;
    print(drinkFromSearchList.length.toString() + "length");
  }

  void fillIngredientList() async {
    ingredientList = await futureIngredientList;
    print(ingredientList.length.toString() + "length");
  }

  void showIngredientMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
            ingredientList.map((String ingredient) {
              return ListTile(
                title: Text(ingredient),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIngredient = ingredient;

                  ApiFetchers api = ApiFetchers();
                  futureSearchResult = api.searchByIngredient(selectedIngredient);
                  fillDrinksFromSearchList();

                  });

                },
            );
          }).toList(),
        ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,

        leading: IconButton(
          icon: const Icon(Icons.liquor),
          tooltip: 'Select Ingredient',
          onPressed: () { showIngredientMenu(context); },
        ),

        title: Text(widget.title),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Ingredient: $selectedIngredient',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),

      ),



      body: ListView.builder(
        itemCount: drinkFromSearchList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(drinkFromSearchList[index].strDrink),
            subtitle: Text(drinkFromSearchList[index].idDrink),
            leading: Image.network(drinkFromSearchList[index].strDrinkThumb),
            onLongPress: () {

            },
          );
        },
      ),


    /*
    floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    */

    );
  }
}
