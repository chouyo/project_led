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
        title: Text('LEDs', style: TextStyle(fontFamily: nexaRegular)),
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
                    title: Text('Add New LED'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'LED Name',
                            hintText: 'Enter LED name',
                          ),
                          style: TextStyle(fontFamily: nexaRegular),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Add'),
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Dismissible(
                  key: Key(led.id),
                  background: Container(
                    color: Colors.green[300],
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
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
                            title: Text('Delete LED'),
                            content: Text(
                              'Are you sure you want to delete ${led.name}?',
                              style: TextStyle(fontFamily: nexaRegular),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Delete',
                                    style: TextStyle(fontFamily: nexaRegular)),
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
                            title: Text('Edit LED',
                                style: TextStyle(fontFamily: nexaRegular)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'LED Name',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel',
                                    style: TextStyle(fontFamily: nexaRegular)),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text('Save',
                                    style: TextStyle(fontFamily: nexaRegular)),
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
                    key: ValueKey('led_item_${led.name}_${timestamp}_$index'),
                    decoration: BoxDecoration(
                      color:
                          getBackgroundColorFromIndex(led.backgroundColorIndex),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        led.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: getTextColorFromIndex(led.textColorIndex),
                          fontFamily: nexaRegular,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed(Routes.HOME, arguments: led.toJson());
                      },
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
