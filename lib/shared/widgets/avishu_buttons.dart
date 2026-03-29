import 'package:flutter/material.dart';

class AvishuButtonLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AvishuButtonLabel({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
