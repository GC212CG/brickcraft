import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final double size;
  final double? height;
  final double borderRadius;
  final Widget child;
  final Function()? onPressed;
  final AlignmentGeometry alighment;
  final List<Color> color;
  final List<Color> colorTapDown;
  final Color borderColor;

  const CustomButton({
    Key? key,
    required this.child,
    this.size = 150,
    this.height,
    this.borderRadius = 30,
    this.onPressed,
    this.alighment = Alignment.center,
    this.borderColor = const Color.fromRGBO(230, 230, 230, 1),
    this.color = const [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(235, 235, 235, 1),
    ],
    this.colorTapDown = const [
      Color.fromRGBO(235, 235, 235, 1),
      Color.fromRGBO(255, 255, 255, 1),
    ],
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isTouched = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        isTouched = true;
        setState(() {});
      },
      onTapCancel: () {
        isTouched = false;
        setState(() {});
      },
      onTapUp: (_) {
        isTouched = false;
        if (widget.onPressed != null) widget.onPressed!();
        setState(() {});
      },
      child: Container(
        alignment: widget.alighment,
        width: widget.size,
        height: widget.height != null ? widget.height : widget.size,
        decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor, width: 1.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isTouched ? widget.colorTapDown : widget.color,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            isTouched
                ? BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    offset: Offset(0, 0.5),
                    spreadRadius: -1.0,
                    blurRadius: 4.0,
                  )
                : BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.30),
                    offset: Offset(0, 5),
                    spreadRadius: -1.0,
                    blurRadius: 4.5,
                  ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
