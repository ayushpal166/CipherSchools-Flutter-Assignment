import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: CircularCutoutClipper(),
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: 'assets/home.svg',
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                ),
                _buildNavItem(
                  icon: 'assets/Transaction.svg',
                  label: 'Transaction',
                  isSelected: false,
                ),
                SizedBox(width: 48),
                _buildNavItem(
                  icon: 'assets/pie chart.svg',
                  label: 'Budget',
                  isSelected: false,
                ),
                _buildNavItem(
                  icon: 'assets/user.svg',
                  label: 'Profile',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTapped(4),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -32,
          child: InkWell(
            onTap: () => onItemTapped(2),
            child: Container(
              height: 64,
              width: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff7F3DFF),
              ),
              child: Center(
                child: Icon(Icons.add, size: 40, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 24,
            width: 24,

            color:
                isSelected ? const Color(0xff7F3DFF) : const Color(0xffC6C6C6),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isSelected
                      ? const Color(0xff7F3DFF)
                      : const Color(0xffC6C6C6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularCutoutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double centerX = size.width / 2;
    double radius = 36;

    Path path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(centerX - radius - 8, 0)
          ..arcToPoint(
            Offset(centerX + radius + 8, 0),
            radius: Radius.circular(radius),
            clockwise: false,
          )
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
