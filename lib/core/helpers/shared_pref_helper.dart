// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // private constructor as I don't want to allow creating an instance of this class itself.

  SharedPrefHelper._();

  /// Removes a value from SharedPreferences with given [key].

  static removeData(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove(key);
  }

  /// Removes all keys and values in the SharedPreferences

  static clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in the SharedPreferences.

  static setData(String key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case String:
        await sharedPreferences.setString(key, value);

        break;

      case int:
        await sharedPreferences.setInt(key, value);

        break;

      case bool:
        await sharedPreferences.setBool(key, value);

        break;

      case double:
        await sharedPreferences.setDouble(key, value);

        break;

      default:
        return null;
    }
  }

  /// Gets a bool value from SharedPreferences with given [key].
  static getBool(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(key) ?? false;
  }

  /// Gets a double value from SharedPreferences with given [key].
  static getDouble(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  /// Gets an int value from SharedPreferences with given [key].
  static getInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getInt(key) ?? 0;
  }

  /// Gets an String value from SharedPreferences with given [key].
  static getString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(key) ?? '';
  }

  /// Saves a [value] with a [key] in the FlutterSecureStorage.
  static setSecuredString(String key, String value) async {
    // Create storage
    const flutterSecureStorage = FlutterSecureStorage();

    // Write value
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets an String value from SharedPreferences with given [key].
  static getSecuredString(String key) async {
    // Create storage
    const flutterSecureStorage = FlutterSecureStorage();

    // Read value
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  /// Removes all keys and values in the FlutterSecureStorage

  static clearAllSecuredData() async {
    const flutterSecureStorage = FlutterSecureStorage();
    // Delete all
    await flutterSecureStorage.deleteAll();
  }
}
