// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

// create CategoryModel class
// that contain a required
// List<Category> categories
// to call this class user
// must prepare a list of categories
class CategoryModel {
  CategoryModel({
    required this.categories,
  });
  List<Category> categories;
// create a factory that fetch
// data from json file as Map<String, dynamic< any type >>
// to place inside the CategoryModel where data
// is from "category" label
// inside the json file
  // CategoryModel are the main category
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );
}

// create Category class which
// will required "name" and "categories"
// tags in the json file as a String, a List<String>
class Category {
  Category({
    required this.name,
    required this.subcategory,
  });
  String name;
  List<String> subcategory;
  // create Map<String, dynamic> for
  // a Category class which will fetch
  // "name" and "subcategories" items inside json file
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subcategory: List<String>.from(json["subcategory"].map((x) => x)),
      );
}
