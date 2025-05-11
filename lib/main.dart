import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'ads/app_lifecycle_reactor.dart';
import 'ads/app_open_ad_manager.dart';
import 'ads/consent_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

class Main extends StatefulWidget {
  const Main(this.initialRoute, {super.key});

  final String initialRoute;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final OptionController controller = Get.find<OptionController>();
  late String initialRoute;

  final _appOpenAdManager = AppOpenAdManager();
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();

    removeFlutterNativeSplash();

    initialRoute = widget.initialRoute;

    _appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: _appOpenAdManager,
    );
    _appLifecycleReactor.listenToAppStateChanges();

    ConsentManager.instance.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint(
          "${consentGatheringError.errorCode}: ${consentGatheringError.message}",
        );
      }

      // Check if a privacy options entry point is required.
      _getIsPrivacyOptionsRequired();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
  }

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

  void _getIsPrivacyOptionsRequired() async {
    if (await ConsentManager.instance.isPrivacyOptionsRequired()) {
      setState(() {
        _isPrivacyOptionsRequired = true;
      });
    }
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await ConsentManager.instance.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();

      // Load an ad.
      _appOpenAdManager.loadAd();
    }
  }

  void removeFlutterNativeSplash() async {
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}
