import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Configs/AssetsPath.dart';

class PriceArea extends StatelessWidget {
  final String entryPrice;
  final String winningPrice;
  const PriceArea(
      {super.key, required this.entryPrice, required this.winningPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Entry Fees
            Container(
              width: MediaQuery.of(context).size.width * 0.35, // Fixed width
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Text(
                  'Entry Fees',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            // Dots
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            // Coins Container (15 Coins)
            Container(
              width: MediaQuery.of(context).size.width * 0.35, // Fixed width
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align content to the left
                children: [
                  SvgPicture.asset(IconsPath.coinIcon),
                  SizedBox(width: 5),
                  Text(
                    '${entryPrice} Coins',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
// Winning Coins Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Winning Coins
            Container(
              width: MediaQuery.of(context).size.width * 0.35, // Fixed width
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Text(
                  'Winning Coins',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            // Dots
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            // Coins Container (30 Coins)
            Container(
              width: MediaQuery.of(context).size.width * 0.35, // Fixed width
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align content to the left
                children: [
                  SvgPicture.asset(IconsPath.coinIcon),
                  SizedBox(width: 5),
                  Text(
                    '${winningPrice} Coins',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
