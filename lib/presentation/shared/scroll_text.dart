import 'package:flutter/material.dart';

class ScrollText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const ScrollText({super.key, required this.text, required this.textStyle});

  @override
  _ScrollTextState createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double _textWidth;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: widget.textStyle,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    _textWidth = textPainter.width;

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _screenWidth = MediaQuery.of(context).size.width;
      _updateAnimation();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _controller.reset();
          _controller.forward();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _updateAnimation();

    _controller.stop();
    _controller.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('Screen orientation changed - Width: $_screenWidth');
        print('Text width: $_textWidth');
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    });
  }

  void _updateAnimation() {
    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset(-(_textWidth + _screenWidth) / _screenWidth, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value.dx * _screenWidth, 0),
                  child: Text(
                    widget.text,
                    style: widget.textStyle,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
