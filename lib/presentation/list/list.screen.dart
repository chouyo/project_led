import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_led/infrastructure/navigation/routes.dart';

import 'controllers/list.controller.dart';
import '../../infrastructure/data/led_model.dart';

class ListScreen extends GetView<ListController> {
  const ListScreen({super.key});

  Color getRandomColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.red,
      Colors.cyan,
      Colors.amber,
    ];
    return colors[Random().nextInt(colors.length)];
  }

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
        title: Text('LEDs', style: GoogleFonts.lato()),
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
                  final typeController = TextEditingController();

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
                          style: GoogleFonts.lato(),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: typeController,
                          decoration: InputDecoration(
                            labelText: 'LED Type',
                            hintText: 'Enter LED type',
                          ),
                          style: GoogleFonts.lato(),
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
                          if (nameController.text.isNotEmpty &&
                              typeController.text.isNotEmpty) {
                            final newLed = Led(
                              name: nameController.text,
                              type: typeController.text,
                              status: 'Disconnected',
                              lastUsed: 'Never',
                              backgroundColor: getRandomColor(),
                              speed: 1.0,
                              textColor: Colors.white,
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
                  key: Key('${led.name}_${led.type}_${timestamp}_$index'),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
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
                              style: GoogleFonts.lato(),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child:
                                    Text('Delete', style: GoogleFonts.lato()),
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
                          final typeController =
                              TextEditingController(text: led.type);

                          return AlertDialog(
                            title: Text('Edit LED', style: GoogleFonts.lato()),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'LED Name',
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  controller: typeController,
                                  decoration: InputDecoration(
                                    labelText: 'LED Type',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child:
                                    Text('Cancel', style: GoogleFonts.lato()),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text('Save', style: GoogleFonts.lato()),
                                onPressed: () {
                                  if (nameController.text.isNotEmpty &&
                                      typeController.text.isNotEmpty) {
                                    final updatedLed = Led(
                                      name: nameController.text,
                                      type: typeController.text,
                                      status: led.status,
                                      lastUsed: led.lastUsed,
                                      backgroundColor: led.backgroundColor,
                                      speed: led.speed,
                                      textColor: led.textColor,
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
                      color: led.backgroundColor,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        led.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: led.textColor,
                          fontFamily: GoogleFonts.lato().fontFamily,
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
