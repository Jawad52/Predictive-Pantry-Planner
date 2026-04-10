import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/pantry/presentation/bloc/camera_bloc.dart';
import 'features/pantry/presentation/bloc/camera_event.dart';
import 'features/pantry/presentation/pages/pantry_dashboard_page.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Predictive Pantry Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        useMaterialDesign: true,
      ),
      home: BlocProvider(
        create: (context) => getIt<CameraBloc>()..add(InitializeCamera()),
        child: const PantryDashboardPage(),
      ),
    );
  }
}
