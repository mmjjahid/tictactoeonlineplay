import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIcons extends StatelessWidget {
  final String icon;
  final String? url;
  final VoidCallback? onTap;

  const SocialIcons({
    Key? key,
    required this.icon,
    this.url,
    this.onTap,
  }) : super(key: key);

  Future<void> _launchURL() async {
    if (url == null || url!.isEmpty) return;

    final Uri uri = Uri.parse(url!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? _launchURL,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: SvgPicture.asset(
          icon,
          color: Colors.white,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
