import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'styleguide_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const StyleguideApp(),
    ),
  );
}
