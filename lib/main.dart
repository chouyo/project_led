import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_led/infrastructure/data/theme_model.dart';
import 'package:project_led/presentation/option/controllers/option.controller.dart';
import 'infrastructure/data/locale_model.dart';
import 'infrastructure/data/speed_adapter.dart';
import 'infrastructure/data/theme_adapter.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'presentation/shared/main_drawer.dart';
import 'infrastructure/data/led_model.dart';
import 'infrastructure/data/color_adapter.dart';
import 'translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(LedAdapter());
  Hive.registerAdapter(SpeedAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(ThemeModelAdapter());
  Hive.registerAdapter(LocaleModelAdapter());

  // Open the box
  await Hive.openBox<Led>('leds');

  var initialRoute = await Routes.initialRoute;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final optionController = Get.put(OptionController());
  await optionController.loadTheme();
  await optionController.loadLocale();

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main(this.initialRoute, {super.key});
  final OptionController controller = Get.find<OptionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        initialRoute: initialRoute,
        getPages: Nav.routes,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: controller.selectedThemeMode.value,
        translations: AppTranslations(),
        locale: controller.selectedLocale.value,
        fallbackLocale: controller.getFallbackLocale(),
        builder: (context, child) {
          return Scaffold(
            drawer: MainDrawer(),
            body: child!,
          );
        },
      ),
    );
  }
}
