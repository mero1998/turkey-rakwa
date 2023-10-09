import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static final locale = Locale('ar');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('ar');

   Map<String, String> ar = {
    'مرحبا': 'مرحبا!',
  };
  // Supported languages
  // Needs to be same order with locales
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': ar, // lang/en_us.dart
  };

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('ar'),

  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file

}