import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dmtools_styleguide.dart';
import 'styleguide_app.dart';
import 'theme/app_theme.dart';
import 'core/services/auth_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const StyleguideApp(),
    ),
  );
} 