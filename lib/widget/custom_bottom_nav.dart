import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF256EFF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomIcon(Icons.home, 0),
            _bottomIcon(Icons.person_outline, 1),
            _bottomIcon(Icons.calendar_today, 2),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon, int index) {
    final bool active = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        color: active ? Colors.black : Colors.white,
        size: 28,
      ),
    );
  }
}
