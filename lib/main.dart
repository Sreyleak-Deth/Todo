import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_list/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await GetStorage.init();
  } catch (e) {
    print('Error initializing Firebase or GetStorage: $e');
  }

  runApp(const App());
}
