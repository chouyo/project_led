import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project_led/infrastructure/navigation/routes.dart';
import 'package:uuid/uuid.dart';

import '../../infrastructure/data/constants.dart';
import 'controllers/list.controller.dart';
import '../../infrastructure/data/led_model.dart';

class ListScreen extends GetView<ListController> {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title:
            Text('ledList'.tr, style: TextStyle(fontFamily: notoSansRegular)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Show dialog to add new LED
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final nameController = TextEditingController();

                  return AlertDialog(
                    title: Text('newLed'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'ledText'.tr,
                            hintText: 'inputLedText'.tr,
                          ),
                          style: TextStyle(fontFamily: notoSansRegular),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('cancel'.tr),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('add'.tr),
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            final newLed = Led(
                              id: Uuid().v4(),
                              name: nameController.text,
                              description: '',
                              lastUsed: DateTime.now().toIso8601String(),
                              speed: ESpeed.normal,
                              textColorIndex: getRandomTextColorIndex(),
                              backgroundColorIndex:
                                  getRandomBackgroundColorIndex(),
                            );
                            controller.addLed(newLed);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.leds.length,
          itemBuilder: (context, index) {
            final led = controller.leds[index];
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black, spreadRadius: 0, blurRadius: 4),
                ],
              ),
              margin: EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  child: Dismissible(
                    key: Key(led.id),
                    background: Container(
                      color: Colors.green[300],
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red[300],
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        // Delete action
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('deleteLed'.tr),
                              content: Text(
                                'deleteLedConfirm'.tr,
                                style: TextStyle(fontFamily: notoSansRegular),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('cancel'.tr),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('delete'.tr,
                                      style: TextStyle(
                                          fontFamily: notoSansRegular)),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );
                        if (shouldDelete ?? false) {
                          controller.deleteLed(index);
                          return true;
                        }
                        return false;
                      } else {
                        // Edit action
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final nameController =
                                TextEditingController(text: led.name);

                            return AlertDialog(
                              title: Text('editLed'.tr,
                                  style:
                                      TextStyle(fontFamily: notoSansRegular)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'ledText'.tr,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('cancel'.tr,
                                      style: TextStyle(
                                          fontFamily: notoSansRegular)),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text('save'.tr,
                                      style: TextStyle(
                                          fontFamily: notoSansRegular)),
                                  onPressed: () {
                                    if (nameController.text.isNotEmpty) {
                                      final updatedLed = Led(
                                        id: led.id,
                                        name: nameController.text,
                                        description: led.description,
                                        lastUsed: led.lastUsed,
                                        speed: led.speed,
                                        textColorIndex: led.textColorIndex,
                                        backgroundColorIndex:
                                            led.backgroundColorIndex,
                                      );
                                      controller.updateLed(index, updatedLed);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return false;
                      }
                    },
                    child: Container(
                      key: ValueKey('led_item_${led.id}'),
                      decoration: BoxDecoration(
                        color: getBackgroundColorFromIndex(
                            led.backgroundColorIndex),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          led.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: getTextColorFromIndex(led.textColorIndex),
                            fontFamily: notoSansRegular,
                          ),
                        ),
                        onTap: () {
                          Get.toNamed(Routes.HOME, arguments: led.toJson());
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
