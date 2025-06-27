import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';

// Accept either image path or icon widget
class PrimaryButtonWithIcon extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final String? image; // SVG asset
  final Widget? imageWidget; // Icon widget

  const PrimaryButtonWithIcon({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.image,
    this.imageWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              SvgPicture.asset(image!, width: 24, height: 24)
            else if (imageWidget != null)
              imageWidget!,
            const SizedBox(width: 10),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
