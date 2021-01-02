import 'package:flutter/widgets.dart';

class BouncingButton extends StatefulWidget {
  BouncingButton({
    @required this.onTap,
    @required this.child,
    @required this.onLongPress,
  });

  Function onTap;
  Function onLongPress;
  Widget child;

  @override
  _BouncingButtonState createState() {
    return _BouncingButtonState(
      onLongPress: onLongPress,
      onTap: onTap,
    );
  }
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  _BouncingButtonState({
    this.onTap,
    this.onLongPress,
  });

  Function onTap;
  Function onLongPress;

  AnimationController _controller;
  double _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress();
        }
        _controller.reverse();
      },
      onTap: onTap,
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
