import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'presentation/shared/main_drawer.dart';
import 'infrastructure/data/led_model.dart';
import 'infrastructure/data/color_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(LedAdapter());

  // Delete existing box if schema changed
  // await Hive.deleteBoxFromDisk('leds');

  // Open the box
  await Hive.openBox<Led>('leds');

  var initialRoute = await Routes.initialRoute;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: Nav.routes,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      builder: (context, child) {
        return Scaffold(
          drawer: MainDrawer(),
          body: child!,
        );
      },
    );
  }
}
