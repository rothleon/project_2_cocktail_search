import 'dart:convert';

DrinkDetailNullsafe drinkDetailNullSafeFromJson(String str) => DrinkDetailNullsafe.fromJson(json.decode(str));

String drinkDetailNullsafeToJson(DrinkDetailNullsafe data) => json.encode(data.toJson());

class DrinkDetailNullsafe {
  List<Map<String, String?>> drinks;

  DrinkDetailNullsafe({
    required this.drinks,
  });

  factory DrinkDetailNullsafe.fromJson(Map<String, dynamic> json) => DrinkDetailNullsafe(
    drinks: List<Map<String, String?>>.from(json["drinks"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
