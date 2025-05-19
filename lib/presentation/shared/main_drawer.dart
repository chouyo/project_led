import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../infrastructure/data/constants.dart';
import '../../infrastructure/navigation/routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0XFF2CD4FF),
                  Color(0XFFFC51FA),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 57,
                child: Image.asset(
                  "assets/Icon/Icon.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('ledList'.tr,
                style: TextStyle(fontFamily: notoSansRegular)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              if (currentRoute != Routes.LIST) {
                Get.offAllNamed(Routes.LIST);
              }
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('options'.tr,
                style: TextStyle(fontFamily: notoSansRegular)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              if (currentRoute != Routes.OPTION) {
                Get.offAllNamed(Routes.OPTION);
              }
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            },
          ),
        ],
      ),
    );
  }
}
