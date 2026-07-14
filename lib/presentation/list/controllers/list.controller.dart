import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../infrastructure/data/led_model.dart';
import '../../../infrastructure/data/mock_leds.dart';

class ListController extends GetxController {
  final RxList<Led> leds = <Led>[].obs;
  final RxBool isLoading = true.obs;
  late final Box<Led> ledBox;
  int _operationCount = 0; // 操作计数器

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    ledBox = Get.find<Box<Led>>();
    leds.value = ledBox.values.toList();
    isLoading.value = false;
  }

  Future<void> loadLeds() async {
    if (ledBox.isEmpty) {
      await ledBox.addAll(MockLeds.leds);
      leds.value = ledBox.values.toList();
      ledBox.compact();
    }
  }

  void _maybeCompact() async {
    _operationCount++;
    if (_operationCount >= 5) {
      await ledBox.compact();
      _operationCount = 0;
    }
  }

  void addLed(Led led) async {
    await ledBox.add(led);
    leds.add(led);
    _maybeCompact();
  }

  void updateLed(int index, Led led) async {
    await ledBox.putAt(index, led);
    leds[index] = led;
    _maybeCompact();
  }

  void deleteLed(int index) async {
    await ledBox.deleteAt(index);
    leds.removeAt(index);
    _maybeCompact();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadDefaultData() async {
    await loadLeds();
  }
}
