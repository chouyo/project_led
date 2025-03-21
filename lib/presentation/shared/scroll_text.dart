import 'package:flutter/material.dart';

import '../../infrastructure/data/constants.dart';

class ScrollText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final bool isLandscape;
  final Color textColor;
  final ESpeed speed;

  const ScrollText({
    super.key,
    required this.text,
    required this.textStyle,
    this.isLandscape = false,
    this.textColor = Colors.white,
    this.speed = ESpeed.normal,
  });

  @override
  _ScrollTextState createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double _textWidth;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
      duration: const Duration(seconds: 10),
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

    _controller.addStatusListener(_onAnimationStatusChanged);
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
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.reset();
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else if (state == AppLifecycleState.paused) {
      _controller.reset();
    }
  }

  void _updateAnimation() {
    int speedBaseRate = ((_textWidth + _screenWidth) / _screenWidth).toInt();
    switch (widget.speed) {
      case ESpeed.slow:
        speedBaseRate *= 10;
        break;
      case ESpeed.normal:
        speedBaseRate *= 7;
        break;
      case ESpeed.fast:
        speedBaseRate *= 3;
        break;
    }
    _controller.duration = Duration(seconds: speedBaseRate);
    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset(-(_textWidth + _screenWidth) / _screenWidth, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.stop();
    _controller.dispose();
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_controller);
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() {
        _controller.reset();
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
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
          ),
        );
      },
    );
  }
}
