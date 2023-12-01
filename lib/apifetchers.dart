import 'package:http/http.dart' as http;
import 'ingredientlist.dart';
import 'searchbyingredient.dart';
import 'drinkdetailnullsafe.dart';

class ApiFetchers{
  List<String> ingredientListAsString = [];

  Future<List<String>> fetchIngredientList() async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      ingredientListAsString.clear();

      Ingredientlist list = ingredientlistFromJson(response.body);

      for (DrinkFromIngredientList drink in list.drinks) {
        ingredientListAsString.add(drink.strIngredient1);
        print(drink.strIngredient1);
      }
      return ingredientListAsString;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ingredient list');
    }
  }

  Future<List<DrinkFromSearch>> searchByIngredient(String ingredient) async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=' + ingredient));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      SearchByIngredient list = searchbyingredientFromJson(response.body);

      return list.drinks;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load search result');
    }
  }

  Future<Map<String, String?>> fetchDrinkDetailNullsafe(String idDrink) async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=' + idDrink));

    print(idDrink + " getting drink by id");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<Map<String, String?>>;
      DrinkDetailNullsafe list = drinkDetailNullSafeFromJson(response.body);

      return list.drinks[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load drink detail');
    }
  }
}