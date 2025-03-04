import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool isLandscape;
  final double speed;
  final Color textColor;

  const MarqueeWidget({
    super.key,
    required this.text,
    required this.style,
    required this.isLandscape,
    this.speed = 1.0,
    this.textColor = Colors.white,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;
  double? textWidth;
  double? screenWidth;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Measure text width after layout
      final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      textWidth = textPainter.width;
      screenWidth = MediaQuery.of(context).size.height;

      // Calculate total distance to travel
      final distance = textWidth! + screenWidth!;

      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: (distance * widget.speed).toInt(),
        ),
      );

      _animation = Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset(-textWidth! / screenWidth!, 0.0), // Normalized offset
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ));

      _controller?.addStatusListener(_onAnimationStatusChanged); // Add listener

      if (widget.isLandscape) {
        _controller?.forward();
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.speed != oldWidget.speed) {
      // Recalculate duration with new speed
      final distance = textWidth! + screenWidth!;
      _controller?.duration = Duration(
        milliseconds: (distance * widget.speed).toInt(),
      );

      if (widget.isLandscape) {
        _controller?.forward(from: 0.0); // Restart animation
      }
    } else if (widget.isLandscape != oldWidget.isLandscape) {
      if (widget.isLandscape) {
        _controller?.forward();
      } else {
        _controller?.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(
        _onAnimationStatusChanged); // Remove listener first
    _controller?.stop(); // Stop animation
    _controller?.dispose(); // Dispose controller
    _animation = null; // Clear animation reference
    super.dispose();
  }

  // Move the status listener to a separate method
  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && widget.isLandscape) {
      _controller?.reset();
      _controller?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      key: widget.key,
      animation: _animation!,
      builder: (context, child) {
        return ClipRect(
          child: Transform.translate(
            offset: Offset(
              _animation!.value.dx * screenWidth!,
              0.0,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
        );
      },
      child: Text(
        widget.text,
        style: widget.style.copyWith(color: widget.textColor),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.visible,
        softWrap: false,
      ),
    );
  }
}
