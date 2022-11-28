import 'package:flutter/material.dart';
import 'package:maps_clean_app/presentation/core/app_widget.dart';

import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  runApp(const AppWidget());
}
