import 'package:get/get.dart';

import '../../../../presentation/option/controllers/option.controller.dart';

class OptionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OptionController>(
      () => OptionController(),
    );
  }
}
