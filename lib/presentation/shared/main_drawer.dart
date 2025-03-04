import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Fancy Led',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List'),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              if (currentRoute != Routes.LIST) {
                Get.offAllNamed(Routes.LIST);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Options'),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              if (currentRoute != Routes.OPTION) {
                Get.offAllNamed(Routes.OPTION);
              }
            },
          ),
        ],
      ),
    );
  }
}
