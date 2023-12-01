import 'dart:convert';

DrinkDetail drinkDetailFromJson(String str) => DrinkDetail.fromJson(json.decode(str));

String drinkDetailNullsafeToJson(DrinkDetail data) => json.encode(data.toJson());

class DrinkDetail {
  List<Map<String, String?>> drinks;

  DrinkDetail({
    required this.drinks,
  });

  factory DrinkDetail.fromJson(Map<String, dynamic> json) => DrinkDetail(
    drinks: List<Map<String, String?>>.from(json["drinks"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
