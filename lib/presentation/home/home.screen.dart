import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/home.controller.dart';
import '../../infrastructure/data/led_model.dart';
import '../../presentation/shared/marquee_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceJson = Get.arguments as Map<String, dynamic>?;
    final orientation = MediaQuery.of(context).orientation;

    // You can use these values or pass them to your controller
    if (deviceJson == null) {
      return const Center(
        child: Text(
          'Select a LED from the list',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    final led = Led.fromJson(deviceJson);

    return Stack(
      children: [
        // Bottom Layer - LED Type only
        Positioned.fill(
            child: Obx(
          () => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: controller.backgroundColor.value,
              alignment: Alignment.centerLeft,
              child: MarqueeWidget(
                key: key,
                text: led.type,
                style: TextStyle(
                  fontSize: 280,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                isLandscape: orientation == Orientation.landscape,
                speed: controller.speed.value,
                textColor: controller.textColor.value,
              )),
        )),

        // Top Layer - Interactive Overlay
        Stack(
          children: [
            // Overlay with animation
            Obx(
              () => AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: controller.showOverlay.value ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: () => controller.toggleOverlay(),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: controller.showOverlay.value
                              ? () => Get.back()
                              : null,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: Icon(Icons.aspect_ratio, color: Colors.white),
                          onPressed: () {
                            final size = MediaQuery.of(context).size;
                            print('Screen width: ${size.width}');
                            print('Screen height: ${size.height}');
                          },
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
                              width: 400,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Settings',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  // Speed Row
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Speed',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            valueIndicatorTextStyle:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          child: Slider(
                                            value: controller.speed.value,
                                            min: 1,
                                            max: 10,
                                            divisions: 2,
                                            label: controller.getSpeedLabel(
                                                controller.speed.value),
                                            secondaryActiveColor: Colors.white,
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
                                          'Text Color',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: HSVColor.fromColor(
                                                  controller.textColor.value)
                                              .hue,
                                          min: 0,
                                          max: 360,
                                          divisions: 36,
                                          activeColor:
                                              controller.textColor.value,
                                          inactiveColor: Colors.white24,
                                          onChanged: (value) {
                                            final color = HSVColor.fromAHSV(
                                                    1.0, value, 1.0, 1.0)
                                                .toColor();
                                            controller.updateTextColor(color);
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
                                          'Background',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: HSVColor.fromColor(controller
                                                  .backgroundColor.value)
                                              .hue,
                                          min: 0,
                                          max: 360,
                                          divisions: 36,
                                          activeColor:
                                              controller.backgroundColor.value,
                                          inactiveColor: Colors.white24,
                                          onChanged: (value) {
                                            final color = HSVColor.fromAHSV(
                                                    1.0, value, 1.0, 1.0)
                                                .toColor();
                                            controller
                                                .updateBackgroundColor(color);
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
    );
  }
}
