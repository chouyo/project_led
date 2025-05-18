import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../infrastructure/data/mock_locales.dart';
import 'controllers/option.controller.dart';
import '../../infrastructure/data/mock_themes.dart';
import '../../infrastructure/data/constants.dart';

class OptionScreen extends GetView<OptionController> {
  const OptionScreen({super.key});

  void _showAboutMeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Image.asset('assets/logo.png'),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        'xyolstudio@gmail.com',
                        style: TextStyle(
                          fontFamily: notoSansRegular,
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: email),
                        );
                        Get.snackbar(
                          'success'.tr,
                          'copied'.tr,
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 2),
                          isDismissible: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ok'.tr),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.checkIsDataEmpty();
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
                _buildCard(
                  Icons.palette,
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
            SizedBox(height: 12),
            Obx(
              () => _buildSection(
                'dataSettings'.tr,
                [
                  _buildCardWithTitleOnly(
                    Icons.archive,
                    controller.isDataEmpty.value
                        ? 'loadDefaultData'.tr
                        : 'dataIsReady'.tr,
                    onTap: () async {
                      controller.loadDefaultData();
                      if (controller.isDataEmpty.value) {
                        Get.snackbar(
                          'success'.tr,
                          'loadDefaultDataSuccess'.tr,
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 2),
                          isDismissible: true,
                        );
                        await controller.checkIsDataEmpty();
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            _buildSection(
              'contactMethod'.tr,
              [
                _buildCardWithTitleOnly(
                  Icons.email,
                  'emailToMe'.tr,
                  onTap: () async {
                    controller.sendEmail();
                  },
                ),
                _buildCardWithTitleOnly(
                  Icons.face,
                  'aboutMe'.tr,
                  onTap: () => _showAboutMeDialog(context),
                ),
              ],
            )
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
      elevation: 1,
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

  Widget _buildCardWithTitleOnly(IconData icon, String title,
      {VoidCallback? onTap}) {
    return Card(
      elevation: 1,
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
                child: SizedBox(
                  // 添加 SizedBox 包裹 Column
                  height: 48, // 设置与图标相同的高度
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                    crossAxisAlignment: CrossAxisAlignment.start, // 保持文本左对齐
                    mainAxisSize: MainAxisSize.min, // 仅占用必要空间
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: notoSansRegular,
                        ),
                      ),
                    ],
                  ),
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
