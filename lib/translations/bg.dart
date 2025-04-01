import 'locales.dart';

Map<String, String> translations = {
  'appName': 'Елегантен LED',
  'ledList': 'Списък с LED',
  'options': 'Опции',
  'myLeds': 'Моите LED',
  'newLed': 'Нов LED',
  'editLed': 'Редактиране на LED',
  'deleteLed': 'Изтриване на LED',
  'deleteLedConfirm': 'Сигурни ли сте, че искате да изтриете този LED?',
  'ledText': 'LED текст',
  'inputLedText': 'Въведете LED текст',
  'add': 'Добавяне',
  'edit': 'Редактиране',
  'delete': 'Изтриване',
  'cancel': 'Отказ',
  'save': 'Запазване',
  'appearanceSettings': 'Настройки на външния вид',
  'languageSettings': 'Настройки на езика',
  'selectLanguage': 'Избор на език',
  'selectTheme': 'Избор на тема',
  'themeSettings': 'Настройки на темата',
  'lightTheme': 'Светла тема',
  'darkTheme': 'Тъмна тема',
  'systemTheme': 'Системна тема',
  'settings': 'Настройки',
  'speed': 'Скорост',
  'textColor': 'Цвят на текста',
  'backgroundColor': 'Цвят на фона',
  'fast': 'Бързо',
  'normal': 'Нормално',
  'slow': 'Бавно',
};

final Map<String, String> bg = {
  ...translations,
  ...locales,
};
