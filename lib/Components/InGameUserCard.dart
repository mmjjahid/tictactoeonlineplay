import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Configs/AssetsPath.dart';

class InGameUserCard extends StatelessWidget {
  final String userName;
  final String? icon;
  final String? base64Image;

  const InGameUserCard({
    super.key,
    required this.userName,
    this.icon,
    this.base64Image,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: Container(
            width: width / 2.4,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  textAlign: TextAlign.center,
                  userName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: icon != null
                          ? SvgPicture.asset(
                              alignment: Alignment.center,
                              icon!,
                              width: 30,
                              color: Colors.white,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -50,
          left: width / 2.4 / 2 - 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _buildImageFromBase64(base64Image),
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ Base64 image decoding
  Widget _buildImageFromBase64(String? base64Str) {
    if (base64Str == null || base64Str.trim().isEmpty) {
      return const Icon(Icons.person, size: 50, color: Colors.white);
    }

    try {
      String cleaned = base64Str.trim();
      if (cleaned.contains(',')) {
        cleaned = cleaned.split(',').last;
      }

      Uint8List imageBytes = base64Decode(cleaned);
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) {
          print("🧨 Image render error: $error");
          return const Icon(Icons.person, size: 50, color: Colors.white);
        },
      );
    } catch (e) {
      print("🧨 Base64 decode error: $e");
      return const Icon(Icons.person, size: 50, color: Colors.white);
    }
  }
}
