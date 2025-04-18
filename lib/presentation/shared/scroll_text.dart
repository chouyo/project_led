import 'package:flutter/material.dart';

import '../../infrastructure/data/constants.dart';

class ScrollText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final bool isLandscape;
  final ESpeed speed;
  final Color backgroundColor;

  const ScrollText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.isLandscape,
    required this.speed,
    required this.backgroundColor,
  });
  @override
  State<ScrollText> createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  late Future<List<String>> words;
  late Duration _duration;
  late double _textWidth;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _duration = Duration(milliseconds: 500);
    _scrollController = ScrollController();
    words = parseText(widget.text);

    // Register observer to handle app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Start auto-scrolling after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: widget.text,
          style: widget.textStyle,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      _textWidth = textPainter.width + MediaQuery.of(context).size.width * 2;
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed from background
      if (_isAutoScrolling) {
        // Reattach controller and restart scrolling
        _restartScrolling();
      }
    } else if (state == AppLifecycleState.paused) {
      _stopAutoScroll();
    }
  }

  void _restartScrolling() {
    // Stop current scrolling
    _stopAutoScroll();

    // Reset controller position
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    // Restart scrolling after a short delay to ensure widget is properly built
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    if (!mounted) return;

    setState(() {
      _isAutoScrolling = true;
    });

    // Initial delay before starting the first animation
    Future.delayed(_duration).then((_) {
      if (!mounted) return;
      _startScrollingLoop();
    });
  }

  void _startScrollingLoop() async {
    if (!mounted || !_isAutoScrolling) return;

    _duration = Duration(
        seconds: await _calculateDuration(
      _textWidth,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    ));

    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController
        .animateTo(
      _textWidth,
      duration: _duration,
      curve: Curves.linear,
    )
        .then((_) {
      if (!mounted) return;
      _scrollController.jumpTo(0);

      // Continue the loop without additional delay
      if (_isAutoScrolling) {
        _startScrollingLoop();
      }
    });
  }

  void _stopAutoScroll() {
    setState(() {
      _isAutoScrolling = false;
    });
  }

  Future<int> _calculateDuration(
      double textWidth, double screenWidth, double screenHeight) async {
    double screenNum = (textWidth / screenWidth);
    switch (widget.speed) {
      case ESpeed.slow:
        screenNum *= 5;
        break;
      case ESpeed.normal:
        screenNum *= 3;
        break;
      case ESpeed.fast:
        screenNum *= 1;
        break;
    }

    double screenRatio = 1;
    if (widget.isLandscape) {
      screenRatio /= 1;
    } else {
      screenRatio /= (screenHeight / screenWidth);
    }

    int duration = (screenNum * screenRatio).toInt();

    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Center(
          child: FutureBuilder<List<String>>(
            future: words,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  cacheExtent: 1000,
                  controller: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width,
                      right: MediaQuery.of(context).size.width),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      child:
                          Text(snapshot.data![index], style: widget.textStyle),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('错误: ${snapshot.error}');
              }
              return CircularProgressIndicator(
                color: Colors.transparent,
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<String>> parseText(String text) async {
  List<String> result = [];
  StringBuffer currentSegment = StringBuffer();
  int i = 0;

  while (i < text.length) {
    final char = text[i];
    final rune = char.runes.first;

    // 检查是否是emoji开始
    /*
    if (_isEmojiStart(rune)) {
      // 处理当前累积的文本
      if (currentSegment.isNotEmpty) {
        _addSegment(currentSegment.toString(), result);
        currentSegment.clear();
      }

      // 获取完整的emoji（可能多个代码点）
      final emojiLength = _getEmojiLength(text, i);
      final emoji = text.substring(i, i + emojiLength);
      result.add(emoji);
      i += emojiLength;
    } else */
    if (_isPunctuation(char)) {
      // 处理标点符号
      if (currentSegment.isNotEmpty) {
        _addSegment(currentSegment.toString(), result);
        currentSegment.clear();
      }
      result.add(char);
      i++;
    } else if (char == ' ') {
      // 处理空格
      if (currentSegment.isNotEmpty) {
        _addSegment(currentSegment.toString(), result);
        currentSegment.clear();
      }
      result.add(char);
      i++;
    } else {
      // 普通字符
      final isCJK = _isChinese(rune) || _isJapanese(rune) || _isKorean(rune);

      if (isCJK) {
        // 中日韩文字：每个字符独立
        if (currentSegment.isNotEmpty &&
            !_isCJKText(currentSegment.toString())) {
          _addSegment(currentSegment.toString(), result);
          currentSegment.clear();
        }
        result.add(char);
      } else {
        // 其他语言字符：累积到当前段
        currentSegment.write(char);
      }
      i++;
    }
  }

  // 处理剩余的文本
  if (currentSegment.isNotEmpty) {
    _addSegment(currentSegment.toString(), result);
  }

  return result;
}

/*
int _getEmojiLength(String text, int startIndex) {
  // 获取emoji的完整长度（可能由多个代码点组成）
  if (startIndex >= text.length) return 0;

  final firstRune = text.runes.elementAt(startIndex);
  if (!_isEmojiStart(firstRune)) return 1;

  // 基本emoji长度
  int length = firstRune <= 0xFFFF ? 1 : 2;

  // 检查后续的修饰符
  int nextIndex = startIndex + length;
  while (nextIndex < text.length) {
    final nextRune = text.runes.elementAt(nextIndex);
    if (_isEmojiModifier(nextRune) || nextRune == 0x200D /* ZWJ */) {
      // 肤色修饰符或连接符
      length += nextRune <= 0xFFFF ? 1 : 2;
      nextIndex += nextRune <= 0xFFFF ? 1 : 2;
    } else {
      break;
    }
  }

  return length;
}
*/

void _addSegment(String segment, List<String> result) {
  if (_isCJKText(segment)) {
    result.add(segment);
  } else {
    // 非CJK文本按空格分割但保留空格
    List<String> parts = segment.split(' ');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        result.add(parts[i]);
      }
      if (i < parts.length - 1) {
        result.add(' ');
      }
    }
  }
}

/*
bool _isEmojiStart(int rune) {
  // 检查是否是emoji开始字符
  return rune >= 0x1F600 && rune <= 0x1F64F || // 表情符号
      rune >= 0x1F300 && rune <= 0x1F5FF || // 杂项符号和象形文字
      rune >= 0x1F680 && rune <= 0x1F6FF || // 交通和地图符号
      rune >= 0x2600 && rune <= 0x26FF || // 杂项符号
      rune >= 0x2700 && rune <= 0x27BF || // 装饰符号
      rune >= 0xFE00 && rune <= 0xFE0F || // 变体选择器
      rune >= 0x1F900 && rune <= 0x1F9FF; // 补充符号和象形文字
}

bool _isEmojiModifier(int rune) {
  // 检查是否是emoji修饰符（如肤色）
  return rune >= 0x1F3FB && rune <= 0x1F3FF || // 肤色修饰符
      rune >= 0xFE00 && rune <= 0xFE0F; // 变体选择器
}
*/

bool _isChinese(int rune) {
  // 中文Unicode范围
  return (rune >= 0x4E00 && rune <= 0x9FFF) ||
      (rune >= 0x3400 && rune <= 0x4DBF) ||
      (rune >= 0x20000 && rune <= 0x2A6DF) ||
      (rune >= 0x2A700 && rune <= 0x2B73F) ||
      (rune >= 0x2B740 && rune <= 0x2B81F) ||
      (rune >= 0x2B820 && rune <= 0x2CEAF) ||
      (rune >= 0xF900 && rune <= 0xFAFF) ||
      (rune >= 0x2F800 && rune <= 0x2FA1F);
}

bool _isJapanese(int rune) {
  // 日文假名和标点范围
  return (rune >= 0x3040 && rune <= 0x309F) || // 平假名
      (rune >= 0x30A0 && rune <= 0x30FF) || // 片假名
      (rune >= 0x31F0 && rune <= 0x31FF) || // 片假名扩展
      (rune >= 0xFF65 && rune <= 0xFF9F); // 半角片假名
}

bool _isKorean(int rune) {
  // 韩文范围
  return (rune >= 0xAC00 && rune <= 0xD7AF) || // 韩文字母
      (rune >= 0x1100 && rune <= 0x11FF) || // 韩文Jamo
      (rune >= 0x3130 && rune <= 0x318F); // 韩文兼容字母
}

bool _isPunctuation(String char) {
  // 全角和半角标点符号
  const punctuation = r'''.,;:!?(){}[]'"、。，；：！？（）｛｝【】《》「」『』"''';
  const fullWidthPunctuation = r'''．，；：！？（）｛｝【】《》「」『』＂＇''';

  return punctuation.contains(char) ||
      fullWidthPunctuation.contains(char) ||
      // Unicode标点范围
      (char.runes.first >= 0x2000 && char.runes.first <= 0x206F) || // 通用标点
      (char.runes.first >= 0x3000 && char.runes.first <= 0x303F); // CJK符号和标点
}

bool _isCJKText(String text) {
  // 检查文本是否全部由CJK字符组成
  for (final rune in text.runes) {
    if (!_isChinese(rune) &&
        !_isJapanese(rune) &&
        !_isKorean(rune) &&
        !_isPunctuation(String.fromCharCode(rune)) &&
        rune != ' '.codeUnitAt(0)) {
      return false;
    }
  }
  return text.isNotEmpty;
}
