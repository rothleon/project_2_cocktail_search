import 'package:flutter/material.dart';
import 'searchbyingredient.dart';
import 'apifetchers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// Root widget for the application
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

// Main page of the application, stateful widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  //Async loads from cocktaildb API
  late Future<Map<String, String?>> futureDrinkDetail;
  late Future<List<String>> futureIngredientList;
  late Future<List<DrinkFromSearch>> futureSearchResult;

  //Data from cocktaildb API stored locally
  Map<String, String?> drinkDetail = {};
  List<DrinkFromSearch> drinkFromSearchList = [];
  List<String> ingredientList = [];

  //Ingredients for cocktail details dialog stored in list form
  List<String> detailingredientsList = [];
  List<String> detailmeasuresList = [];

  //Currently selected ingredient
  String selectedIngredient = 'None';

  //Instanced class of fetcher methods from cocktaildb API
  ApiFetchers api = ApiFetchers();

  //Controller instance to return the cocktail list to the top when new ingredient search
  ScrollController listScrollController = ScrollController();

  //Popup instructional help snackbar for short taps on cocktails
  SnackBar snackBar = const SnackBar(
    padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
    content:
        Text('Touch and hold a cocktail for ingredients and instructions.'),
  );

  @override
  void initState() {
    super.initState();
    futureIngredientList = api.fetchIngredientList();
    fillIngredientList();
    //print(ingredientList.length.toString() + "length");
  }

  Future<void> fillDrinksFromSearchList() async {
    drinkFromSearchList = await futureSearchResult;
    setState(() {});
    //print(drinkFromSearchList.length.toString() + "length cocktail search");
  }

  void fillIngredientList() async {
    ingredientList = await futureIngredientList;
    //print(ingredientList.length.toString() + "length ingredient list");
  }

  Future<void> fillDrinkDetail() async {
    drinkDetail = await futureDrinkDetail;
    setState(() {});
    detailingredientsList.clear();
    detailmeasuresList.clear();

    for (int i = 1; i <= 15; i++) {
      if (drinkDetail['strIngredient$i'] != null) {
        detailingredientsList.add(drinkDetail['strIngredient$i']!);
        if (drinkDetail['strMeasure$i'] != null) {
          detailmeasuresList.add(drinkDetail['strMeasure$i']!);
        } else {
          detailmeasuresList.add("");
        }
      }
    }

    //print(detailingredientsList);
    //print(detailmeasuresList);

    //print("drinkdetail populated");
  }

  // Method to build the ingredient menu tile
  Widget buildIngredientMenuTile(String ingredient) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.tertiary,
      textColor: Theme.of(context).colorScheme.onTertiary,
      title: Text(ingredient),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          selectedIngredient = ingredient;
          futureSearchResult = api.searchByIngredient(selectedIngredient);
          fillDrinksFromSearchList();
          listScrollController
              .jumpTo(listScrollController.position.minScrollExtent);
        });
      },
    );
  }

  // Method to show the ingredient menu
  void showIngredientMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ingredientList.map((String ingredient) {
                return buildIngredientMenuTile(ingredient);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Method to build the app bar
  AppBar buildAppBar() {
    return AppBar(
      leadingWidth: 75,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      leading: IconButton(
        icon: const Icon(Icons.liquor),
        tooltip: 'Select Ingredient',
        onPressed: () {
          showIngredientMenu(context);
        },
      ),
      title: GestureDetector(
          onTap: () {
            showIngredientMenu(context);
          },
          child: Text(widget.title)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              showIngredientMenu(context);
            },
            child: Text(
              'Ingredient: $selectedIngredient',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build the body scroll
  Widget buildBodyScroll() {
    return Scrollbar(
      child: ListView.builder(
        controller: listScrollController,
        itemCount: drinkFromSearchList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            minVerticalPadding: 20,
            textColor: Theme.of(context).colorScheme.onSecondary,
            title: Text(drinkFromSearchList[index].strDrink),
            leading: Image.network(drinkFromSearchList[index].strDrinkThumb),
            onLongPress: () {
              futureDrinkDetail =
                  api.fetchDrinkDetail(drinkFromSearchList[index].idDrink);
              drinkDetailDialog(context);
            },
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        },
      ),
    );
  }

  // Method to build the body
  Widget buildBody() {
    return Container(
        color: Theme.of(context).colorScheme.secondary,
        child: buildBodyScroll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  // Method to display the detailed dialog for a selected drink
  Future<void> drinkDetailDialog(BuildContext context) async {
    await fillDrinkDetail();

    //drinkDetail.forEach((key, value) {
    //  print('$key:$value');
    //});

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            insetPadding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            contentPadding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
            titlePadding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
            title: Text(
              drinkDetail['strDrink']!,
              textAlign: TextAlign.center,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  drinkDetail['strDrinkThumb']!,
                  height: 100,
                  width: 500,
                  alignment: Alignment.center,
                ),
                Text('Ingredients:',
                    style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(
                  height: 290,
                  width: 500,
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: detailingredientsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            visualDensity: const VisualDensity(vertical: -4),
                            dense: true,
                            title: Text(
                                "${detailingredientsList[index]} - ${detailmeasuresList[index]}",
                                style: Theme.of(context).textTheme.bodySmall),
                          );
                        }),
                  ),
                ),
                Text(
                  'Instructions:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                    height: 100,
                    width: 500,
                    child: SingleChildScrollView(
                      child: Text(drinkDetail['strInstructions']!),
                    ))
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary)),
              ),
            ],
          );
        });
  }
}
