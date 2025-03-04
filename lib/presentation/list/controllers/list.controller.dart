import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../infrastructure/data/led_model.dart';
import '../../../infrastructure/data/mock_leds.dart';

class ListController extends GetxController {
  final RxList<Led> leds = <Led>[].obs;
  Box<Led>? ledBox;

  @override
  void onInit() async {
    super.onInit();
    await initBox();
    loadLeds();
  }

  Future<void> initBox() async {
    if (!Hive.isBoxOpen('leds')) {
      ledBox = await Hive.openBox<Led>('leds');
    } else {
      ledBox = Hive.box<Led>('leds');
    }
  }

  void loadLeds() {
    if (ledBox == null) return;

    if (ledBox!.isEmpty) {
      // Load mock data only if box is empty (first launch)
      ledBox!.addAll(MockLeds.leds);
    }
    leds.value = ledBox!.values.toList();
  }

  void addLed(Led led) {
    if (ledBox == null) return;
    ledBox!.add(led); // Store in Hive
    leds.value = ledBox!.values.toList(); // Update UI
  }

  void updateLed(int index, Led led) {
    if (ledBox == null) return;
    ledBox!.putAt(index, led); // Update in Hive
    leds.value = ledBox!.values.toList(); // Update UI
  }

  void deleteLed(int index) {
    if (ledBox == null) return;
    ledBox!.deleteAt(index); // Delete from Hive
    leds.value = ledBox!.values.toList(); // Update UI
  }

  @override
  void onClose() {
    if (ledBox != null) {
      ledBox!.close();
    }
    super.onClose();
  }
}
