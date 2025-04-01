import 'locales.dart';

Map<String, String> translations = {
  'appName': 'Fancy LED',
  'ledList': 'LED 목록',
  'options': '옵션',
  'myLeds': '내 LED',
  'newLed': '새 LED',
  'editLed': 'LED 편집',
  'deleteLed': 'LED 삭제',
  'deleteLedConfirm': '이 LED를 삭제하시겠습니까?',
  'ledText': 'LED 텍스트',
  'inputLedText': 'LED 텍스트 입력',
  'add': '추가',
  'edit': '편집',
  'delete': '삭제',
  'cancel': '취소',
  'save': '저장',
  'appearanceSettings': '화면 설정',
  'languageSettings': '언어 설정',
  'selectLanguage': '언어 선택',
  'selectTheme': '테마 선택',
  'themeSettings': '테마 설정',
  'lightTheme': '라이트 테마',
  'darkTheme': '다크 테마',
  'systemTheme': '시스템 테마',
  'settings': '설정',
  'speed': '속도',
  'textColor': '텍스트 색상',
  'backgroundColor': '배경 색상',
  'fast': '빠름',
  'normal': '보통',
  'slow': '느림',
};

final Map<String, String> ko = {
  ...translations,
  ...locales,
};
