import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_flutter/pages/home_page.dart';
import 'package:riverpod_flutter/services/database_service.dart';
import 'package:riverpod_flutter/services/http_services.dart';

Future<void> main() async {
  await _setUpServices();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _setUpServices() async{
  GetIt.instance.registerSingleton<HttpServices>(
    HttpServices()
  );
  GetIt.instance.registerSingleton<DatabaseService>(
      DatabaseService()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

