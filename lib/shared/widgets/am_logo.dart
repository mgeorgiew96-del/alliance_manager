import 'package:flutter/material.dart';

class AMLogo extends StatelessWidget {
  const AMLogo({
    super.key,
    this.size = 90,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF152238),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.shield,
        color: Color(0xFFD4AF37),
        size: 48,
      ),
    );
  }
}