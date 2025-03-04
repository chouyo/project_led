import 'package:get/get.dart';

import '../../../../presentation/list/controllers/list.controller.dart';

class ListControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListController>(
      () => ListController(),
    );
  }
}
