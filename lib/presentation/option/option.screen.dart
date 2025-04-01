import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project_led/infrastructure/data/constants.dart';
import 'package:project_led/infrastructure/data/mock_locales.dart';

import 'controllers/option.controller.dart';
import '../../infrastructure/data/mock_themes.dart';

class OptionScreen extends GetView<OptionController> {
  const OptionScreen({super.key});
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
            Text('options'.tr, style: TextStyle(fontFamily: notoSansRegular)),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.all(12),
          children: [
            _buildSection(
              'appearanceSettings'.tr,
              [
                _buildCard(
                  Icons.language,
                  'languageSettings'.tr,
                  controller.getLocaleString(controller.selectedLocale.value),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Text(
                                    'selectLanguage'.tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: notoSansRegular,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                            Flexible(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: MockLocales.locales.length,
                                separatorBuilder: (context, index) =>
                                    Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final locale = MockLocales.locales[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 4),
                                    title: Text(
                                      locale.tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontFamily: notoSansRegular,
                                      ),
                                    ),
                                    trailing: Obx(() => controller
                                                .selectedLocale.value
                                                .toString() ==
                                            locale
                                        ? Icon(Icons.check)
                                        : SizedBox(width: 24)),
                                    onTap: () {
                                      controller.setLocale(controller
                                          .parseLocaleByString(locale));
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8),
                _buildCard(
                  Icons.theater_comedy,
                  'themeSettings'.tr,
                  getThemeModeName(controller.selectedThemeMode.value).tr,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text(
                                    'selectTheme'.tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: notoSansRegular,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                            Flexible(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: MockThemes.themes.length,
                                separatorBuilder: (context, index) =>
                                    Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final theme = MockThemes.themes[index];
                                  return ListTile(
                                    title: Text(
                                      getThemeModeName(theme.themeMode).tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontFamily: notoSansRegular,
                                      ),
                                    ),
                                    trailing: Obx(() =>
                                        controller.selectedThemeMode.value ==
                                                theme.themeMode
                                            ? Icon(Icons.check)
                                            : SizedBox(width: 24)),
                                    onTap: () {
                                      controller.setTheme(theme.themeMode);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontFamily: notoSansRegular,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildCard(IconData icon, String title, String subtitle,
      {VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.blue),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: notoSansRegular,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: notoSansRegular,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
