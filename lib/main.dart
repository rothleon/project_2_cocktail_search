//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ingredientlist.dart';
import 'searchbyingredient.dart';
import 'drinkdetails.dart';
import 'apifetchers.dart';
import 'dart:async';
import 'drinkdetailnullsafe.dart';

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
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, String?>> futureDrinkDetailNullSafe;
  late Future<List<String>> futureIngredientList;
  late Future<List<DrinkFromSearch>> futureSearchResult;
  late Future<DrinkFromDetail> futureDrinkDetail;
  Map<String, String?> drinkDetailNullSafe = new Map();

 /* DrinkFromDetail drinkDetail = DrinkFromDetail(
      strDrink: "strDrink",
      strDrinkThumb: "strDrinkThumb",
      idDrink: "idDrink",
      strInstructions: "strInstructions",
      strIngredient1: "strIngredient1",
      strIngredient2: "strIngredient2",
      strIngredient3: "strIngredient3",
      strIngredient4: "strIngredient4",
      strIngredient5: "strIngredient5",
      strIngredient6: "strIngredient6",
      strIngredient7: "strIngredient7",
      strIngredient8: "strIngredient8",
      strIngredient9: "strIngredient9",
      strIngredient10: "strIngredient10",
      strIngredient11: "strIngredient11",
      strIngredient12: "strIngredient12",
      strIngredient13: "strIngredient13",
      strIngredient14: "strIngredient14",
      strIngredient15: "strIngredient15");

  */
  List<DrinkFromSearch> drinkFromSearchList = [];
  List<String> ingredientList = [];
  String selectedIngredient = 'Vodka';
  ApiFetchers api = ApiFetchers();

  @override
  void initState() {
    super.initState();
    //ApiFetchers api = ApiFetchers();
    futureIngredientList = api.fetchIngredientList();
    fillIngredientList();
    print(ingredientList.length.toString() + "length");
  }

  Future<void> fillDrinksFromSearchList() async {
    drinkFromSearchList = await futureSearchResult;
    setState(() {});
    print(drinkFromSearchList.length.toString() + "length cocktail search");
  }

  void fillIngredientList() async {
    ingredientList = await futureIngredientList;
    print(ingredientList.length.toString() + "length ingredient list");
  }

  /*
  Future<void> fillDrinkDetail() async {
    drinkDetail = await futureDrinkDetail;
    setState(() {});
    print("drinkdetail populated");
  }
  */

  Future<void> fillDrinkDetailNullsafe() async {
    drinkDetailNullSafe = await futureDrinkDetailNullSafe;
    setState(() {});
    print("drinkdetail populated");
  }

  void showIngredientMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ingredientList.map((String ingredient) {
              return ListTile(
                title: Text(ingredient),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedIngredient = ingredient;
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
    ScrollController listScrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.liquor),
          tooltip: 'Select Ingredient',
          onPressed: () {
            showIngredientMenu(context);
            listScrollController
                .jumpTo(listScrollController.position.minScrollExtent);
          },
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
        controller: listScrollController,
        itemCount: drinkFromSearchList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(drinkFromSearchList[index].strDrink),
            subtitle: Text(drinkFromSearchList[index].idDrink),
            leading: Image.network(drinkFromSearchList[index].strDrinkThumb),
            onLongPress: () {
              futureDrinkDetailNullSafe = api.fetchDrinkDetailNullsafe(drinkFromSearchList[index].idDrink);

              drinkDetailDialog(context);
            },
            trailing: Text(index.toString()),
          );
        },
      ),
    );
  }

 Future<void> drinkDetailDialog(BuildContext context) async {

    await fillDrinkDetailNullsafe();

    drinkDetailNullSafe.forEach((key, value) {
      print('$key:$value');
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text(drinkDetailNullSafe['strDrink']!),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(drinkDetailNullSafe['strDrinkThumb']!),
                Text('Ingredients:'),

                /*
                if(drinkDetailNullSafe["strIngredient1"!] != null) {
                  Text(drinkDetailNullSafe[strIngredient1]!);
                }
                */


                /*
                for (int i = 1; i <= 15; i++) {
                  if (drinkDetailNullSafe['strIngredient$i'] != null
                      //&& drinkDetailNullSafe['strIngredient$i'].trim().isNotEmpty
                  ) {
                    Text('${drinkDetailNullSafe['strIngredient$i']} - ${drinkDetailNullSafe['strMeasure$i']}'),
                  }
                },
                */

                SizedBox(height: 10.0),
                Text('Instructions:'),
                Text(drinkDetailNullSafe['strInstructions']!),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        }
    );
  }
}
