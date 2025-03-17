import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List', style: GoogleFonts.lato()),
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
            title: Text('Options', style: GoogleFonts.lato()),
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
