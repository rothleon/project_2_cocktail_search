// Importing necessary packages and files
import 'package:http/http.dart' as http;
import 'ingredientlist.dart';
import 'searchbyingredient.dart';
import 'drinkdetail.dart';

// Class to handle API fetch operations
class ApiFetchers{
  // List to store ingredient names as strings
  List<String> ingredientListAsString = [];

  // Method to fetch the list of ingredients from the API
  Future<List<String>> fetchIngredientList() async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // Clearing the existing list of ingredient names
      ingredientListAsString.clear();

      // Converting JSON response to Dart object using generated code
      Ingredientlist list = ingredientlistFromJson(response.body);

      // Extracting ingredient names from the list of drinks and adding to the string list
      for (DrinkFromIngredientList drink in list.drinks) {
        ingredientListAsString.add(drink.strIngredient1);
        //print(drink.strIngredient1);
      }
      return ingredientListAsString;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ingredient list');
    }
  }

  // Method to search cocktails by ingredient
  Future<List<DrinkFromSearch>> searchByIngredient(String ingredient) async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // Converting JSON response to Dart object using generated code
      SearchByIngredient list = searchbyingredientFromJson(response.body);

      return list.drinks;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load search result');
    }
  }

  // Method to fetch detailed information about a drink by its ID
  Future<Map<String, String?>> fetchDrinkDetail(String idDrink) async {
    final response = await http
        .get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$idDrink'));

    //print(idDrink + " getting drink by id");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // Converting JSON response to Dart object using generated code
      List<Map<String, String?>>;
      DrinkDetail list = drinkDetailFromJson(response.body);

      // Returning the first item in the list (assuming it's the only one)
      return list.drinks[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load drink detail');
    }
  }
}