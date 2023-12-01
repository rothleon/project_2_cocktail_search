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
  late Future<Map<String, String?>> futureDrinkDetail;
  late Future<List<String>> futureIngredientList;
  late Future<List<DrinkFromSearch>> futureSearchResult;
  Map<String, String?> drinkDetail = {};
  List<DrinkFromSearch> drinkFromSearchList = [];
  List<String> ingredientList = [];
  String selectedIngredient = 'None';
  ApiFetchers api = ApiFetchers();
  List<String> detailingredientsList = [];
  List<String> detailmeasuresList = [];
  ScrollController listScrollController = ScrollController();

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
                      listScrollController.jumpTo(
                          listScrollController.position.minScrollExtent);
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
        preferredSize: Size.fromHeight(30.0),
        child: Container(
          padding: EdgeInsets.only(bottom: 8.0),
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

  Container buildBody() {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Scrollbar(
        child: ListView.builder(
          controller: listScrollController,
          itemCount: drinkFromSearchList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              minVerticalPadding: 20,
              //tileColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              title: Text(drinkFromSearchList[index].strDrink),
              leading: Image.network(drinkFromSearchList[index].strDrinkThumb),
              onLongPress: () {
                futureDrinkDetail = api.fetchDrinkDetail(
                    drinkFromSearchList[index].idDrink);

                drinkDetailDialog(context);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: buildBody());
  }

  Future<void> drinkDetailDialog(BuildContext context) async {
    await fillDrinkDetail();

    drinkDetail.forEach((key, value) {
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
                  width: 250,
                  child: Scrollbar(
                    child: ListView.builder(
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
                Text(
                  'Instructions:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                    height: 100,
                    width: 250,
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
