import 'package:flutter/material.dart';

class BodyWrapper extends StatelessWidget {
  const BodyWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
