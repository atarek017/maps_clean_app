import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_clean_app/application/app_life_cycle/application_life_cycle_cubit.dart';
import 'package:maps_clean_app/application/permission/permission_cubit.dart';
import 'package:maps_clean_app/injection.dart';

import '../map/map_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => getIt<PermissionCubit>(),
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Map Tutorial Template',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MapPage(),
      ),
    );
  }
}
