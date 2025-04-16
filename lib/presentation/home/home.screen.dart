import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_led/infrastructure/data/constants.dart';

import '../shared/scroll_text.dart';
import 'controllers/home.controller.dart';
import '../../infrastructure/data/led_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {}); // Force rebuild
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceJson = Get.arguments as Map<String, dynamic>?;
    final orientation = MediaQuery.of(context).orientation;

    // You can use these values or pass them to your controller
    if (deviceJson == null) {
      return Center(
        child: Text(
          'Select a LED from the list',
          style: TextStyle(
            fontFamily: notoSansRegular,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    final led = Led.fromJson(deviceJson);
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        controller.goBack(); // Allow back navigation
      },
      child: Stack(
        key: UniqueKey(),
        children: [
          // Bottom Layer - LED Type only
          Positioned.fill(
            child: Obx(
              () => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.centerLeft,
                child: RepaintBoundary(
                  child: ScrollText(
                    key: UniqueKey(),
                    text: led.name,
                    textStyle: TextStyle(
                      fontSize: 280,
                      fontWeight: FontWeight.normal,
                      color: getTextColorFromIndex(
                          controller.textColorIndex.value),
                      fontFamily: notoSansRegular,
                    ),
                    isLandscape: orientation == Orientation.landscape,
                    speed: controller.speed.value,
                    backgroundColor: getBackgroundColorFromIndex(
                        controller.backgroundColorIndex.value),
                  ),
                ),
              ),
            ),
          ),

          // Top Layer - Interactive Overlay
          Stack(
            children: [
              // Overlay with animation
              Obx(
                () => AnimatedOpacity(
                  duration: Duration(milliseconds: 0),
                  curve: Curves.easeInOut,
                  opacity: controller.showOverlay.value ? 1.0 : 0.0,
                  child: GestureDetector(
                    onTap: () => controller.toggleOverlay(),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black.withAlpha(127),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: controller.showOverlay.value
                                ? () => controller.goBack()
                                : null,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: Icon(Icons.screen_rotation,
                                color: Colors.white),
                            onPressed: controller.showOverlay.value
                                ? () => controller.toggleOrientation()
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Visibility(
                            visible: controller.showOverlay.value,
                            child: Center(
                              child: Container(
                                width: controller.calculateOverlayWidth(
                                    context), // 90% of screen width
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'settings'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: notoSansRegular,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Speed Row
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'speed'.tr,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                fontFamily: notoSansRegular),
                                          ),
                                        ),
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              valueIndicatorTextStyle:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            child: Slider(
                                              value: controller
                                                  .speed.value.index
                                                  .toDouble(),
                                              min: 0,
                                              max: ESpeed.values.length - 1,
                                              divisions:
                                                  ESpeed.values.length - 1,
                                              label: controller
                                                  .getSpeedLabel(controller
                                                      .speed.value.index)
                                                  .tr,
                                              secondaryActiveColor:
                                                  Colors.white,
                                              activeColor: Colors.white,
                                              inactiveColor: Colors.white24,
                                              onChanged: controller.updateSpeed,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text Color Row
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'textColor'.tr,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                fontFamily: notoSansRegular),
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            value: controller
                                                .textColorIndex.value
                                                .toDouble(),
                                            min: 0,
                                            max: foregroundColors.length - 1,
                                            divisions:
                                                foregroundColors.length - 1,
                                            activeColor: getTextColorFromIndex(
                                                controller
                                                    .textColorIndex.value),
                                            inactiveColor: Colors.white24,
                                            onChanged: (value) {
                                              controller.updateTextColorIndex(
                                                  value.toInt());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Background Color Row
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'backgroundColor'.tr,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                fontFamily: notoSansRegular),
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            value: controller
                                                .backgroundColorIndex
                                                .toDouble(),
                                            min: 0,
                                            max: backgroudColors.length - 1,
                                            divisions:
                                                backgroudColors.length - 1,
                                            activeColor:
                                                getBackgroundColorFromIndex(
                                                    controller
                                                        .backgroundColorIndex
                                                        .value),
                                            inactiveColor: Colors.white24,
                                            onChanged: (value) {
                                              controller
                                                  .updateBackgroundColorIndex(
                                                      value.toInt());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
