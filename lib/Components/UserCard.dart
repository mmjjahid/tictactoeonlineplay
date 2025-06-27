import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Configs/AssetsPath.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String requiredCoins;
  final String status;
  final String? base64Image;

  const UserCard({
    super.key,
    required this.userName,
    required this.requiredCoins,
    this.status = '',
    this.base64Image,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card Background
        Container(
          width: width / 2.4,
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                userName.trim(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(IconsPath.coinIcon, width: 20),
                  const SizedBox(width: 10),
                  Text(
                    '$requiredCoins Coins',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 7),
              if (status.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      status == 'ready'
                          ? Icons.done
                          : Icons.watch_later_outlined,
                      color: status == 'ready'
                          ? Colors.green
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 5),
                    Text(status),
                  ],
                ),
            ],
          ),
        ),

        // Profile Image (Positioned)
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
      // Clean up common issues
      String cleaned = base64Str.trim();

      // Remove base64 prefix if exists
      if (cleaned.contains(',')) {
        cleaned = cleaned.split(',').last;
      }

      // Decode
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
