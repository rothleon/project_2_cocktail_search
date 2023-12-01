import 'package:flutter/material.dart';
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
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, String?>> futureDrinkDetailNullSafe;
  late Future<List<String>> futureIngredientList;
  late Future<List<DrinkFromSearch>> futureSearchResult;
  Map<String, String?> drinkDetailNullSafe = {};
  List<DrinkFromSearch> drinkFromSearchList = [];
  List<String> ingredientList = [];
  String selectedIngredient = 'None';
  ApiFetchers api = ApiFetchers();
  List<String> detailingredientsList = [];
  List<String> detailmeasuresList = [];

  @override
  void initState() {
    super.initState();
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

  Future<void> fillDrinkDetailNullsafe() async {
    drinkDetailNullSafe = await futureDrinkDetailNullSafe;
    setState(() {});
    detailingredientsList.clear();
    detailmeasuresList.clear();

    for (int i = 1; i <= 15; i++) {
      if (drinkDetailNullSafe['strIngredient$i'] != null) {
        detailingredientsList.add(drinkDetailNullSafe['strIngredient$i']!);
        if (drinkDetailNullSafe['strMeasure$i'] != null) {
          detailmeasuresList.add(drinkDetailNullSafe['strMeasure$i']!);
        } else {
          detailmeasuresList.add("");
        }
      }
    }

    print(detailingredientsList);
    print(detailmeasuresList);

    print("drinkdetail populated");
  }

  void showIngredientMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ingredientList.map((String ingredient) {
                return ListTile(
                  tileColor: Theme.of(context).colorScheme.tertiary,
                  textColor: Theme.of(context).colorScheme.onTertiary,
                  title: Text(ingredient),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedIngredient = ingredient;
                      futureSearchResult =
                          api.searchByIngredient(selectedIngredient);
                      fillDrinksFromSearchList();
                    });
                  },
                );
              }).toList(),
            ),
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
        leadingWidth: 75,
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
        title: GestureDetector(
            onTap: () {
              showIngredientMenu(context);
              listScrollController
                  .jumpTo(listScrollController.position.minScrollExtent);
            },
            child: Text(widget.title)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(
            padding: EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                showIngredientMenu(context);
                listScrollController
                    .jumpTo(listScrollController.position.minScrollExtent);
              },
              child: Text(
                'Ingredient: $selectedIngredient',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: ListView.builder(
          controller: listScrollController,
          itemCount: drinkFromSearchList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              minVerticalPadding: 20,
              tileColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              title: Text(drinkFromSearchList[index].strDrink),
              leading: Image.network(drinkFromSearchList[index].strDrinkThumb),
              onLongPress: () {
                futureDrinkDetailNullSafe = api
                    .fetchDrinkDetailNullsafe(drinkFromSearchList[index].idDrink);
        
                drinkDetailDialog(context);
              },
            );
          },
        ),
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
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            insetPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 5),
            titlePadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
            title: Text(
              drinkDetailNullSafe['strDrink']!,
              textAlign: TextAlign.center,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  drinkDetailNullSafe['strDrinkThumb']!,
                  height: 100,
                  width: 500,
                  alignment: Alignment.center,
                ),

                Text('Ingredients:',
                    style: Theme.of(context).textTheme.bodyLarge),

                SizedBox(
                  height: 290,
                  width: 250,
                  child: Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: detailingredientsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            dense: true,
                            title: Text(
                                "${detailingredientsList[index]} - ${detailmeasuresList[index]}",
                                style: Theme.of(context).textTheme.bodySmall),
                          );
                        }),
                  ),
                ),
                //SizedBox(height: 2.0),

                Text(
                  'Instructions:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(
                    height: 100,
                    width: 250,
                    child: SingleChildScrollView(
                      child: Text(drinkDetailNullSafe['strInstructions']!),
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
