import 'package:flutter/material.dart';
import 'package:go_together/helper/extensions/string_extension.dart';

enum Gender {
  male,
  female
}

extension GenderExtension on Gender{
  Icon getIcon() {
    switch (this) {
      case Gender.female:
        return Icon(Icons.female);
      case Gender.male:
        return Icon(Icons.male);
      default:
        return Icon(Icons.transgender_outlined);
    }
  }
  String toShortString() {
    return this.toString().enumValueToNormalCase();
  }

  String translate(){
    switch (this) {
      case Gender.female:
        return "Femmes";
      case Gender.male:
        return "Hommes";
      default:
        return "Tous";
    }
  }
}

/// Get gender from a string
Gender getGenderByString(String gender){
  return Gender.values.firstWhere((element) => element.toShortString() == gender || element.translate() == gender);
}
List<String> getAllGenderTranslate(){
  return Gender.values.map((el) => el.translate()).toList();
}