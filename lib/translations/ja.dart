import 'locales.dart';

Map<String, String> translations = {
  'appName': 'Fancy LED',
  'ledList': 'LED一覧',
  'options': 'オプション',
  'myLeds': 'マイLED',
  'newLed': '新規LED',
  'editLed': 'LED編集',
  'deleteLed': 'LED削除',
  'deleteLedConfirm': 'このLEDを削除してもよろしいですか？',
  'ledText': 'LEDテキスト',
  'inputLedText': 'LEDテキストを入力',
  'add': '追加',
  'edit': '編集',
  'delete': '削除',
  'cancel': 'キャンセル',
  'save': '保存',
  'appearanceSettings': '表示設定',
  'languageSettings': '言語設定',
  'selectLanguage': '言語を選択',
  'selectTheme': 'テーマを選択',
  'themeSettings': 'テーマ設定',
  'lightTheme': 'ライトテーマ',
  'darkTheme': 'ダークテーマ',
  'systemTheme': 'システムテーマ',
  'settings': '設定',
  'speed': '速度',
  'textColor': 'テキスト色',
  'backgroundColor': '背景色',
  'fast': '速い',
  'normal': '通常',
  'slow': '遅い',
};

final Map<String, String> ja = {
  ...translations,
  ...locales,
};
