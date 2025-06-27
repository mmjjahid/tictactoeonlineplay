import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tictactoeonlineplay/Configs/AssetsPath.dart';

class SinglePlayerController extends GetxController {
  RxList playValue = ["", "", "", "", "", "", "", "", ""].obs;
  RxBool isXtime = true.obs;
  RxBool isWinner = false.obs;
  RxInt xScore = 0.obs;
  RxInt oScore = 0.obs;

  void onClick(int index) {
    if (playValue[index] == '') {
      if (isXtime.value) {
        playValue[index] = 'X';
        isXtime.value = !isXtime.value;
      } else {
        playValue[index] = 'O';
        isXtime.value = !isXtime.value;
      }
    } else {}
    checkWinner();
  }

  void checkWinner() {
    //vertical
    if (playValue[0] == playValue[1] &&
        playValue[0] == playValue[2] &&
        playValue[0].isNotEmpty) {
      WinnerDialogBox(playValue[0]);
    } else if (playValue[3] == playValue[4] &&
        playValue[3] == playValue[5] &&
        playValue[3].isNotEmpty) {
      WinnerDialogBox(playValue[3]);
    } else if (playValue[6] == playValue[7] &&
        playValue[6] == playValue[8] &&
        playValue[6].isNotEmpty) {
      WinnerDialogBox(playValue[6]);
    }
    // horizontal
    else if (playValue[0] == playValue[3] &&
        playValue[0] == playValue[6] &&
        playValue[0].isNotEmpty) {
      WinnerDialogBox(playValue[0]);
    } else if (playValue[1] == playValue[4] &&
        playValue[1] == playValue[7] &&
        playValue[1].isNotEmpty) {
      WinnerDialogBox(playValue[1]);
    } else if (playValue[2] == playValue[5] &&
        playValue[2] == playValue[8] &&
        playValue[2].isNotEmpty) {
      WinnerDialogBox(playValue[2]);
    }
    // Diagonal Conditions
    else if (playValue[0] == playValue[4] &&
        playValue[0] == playValue[8] &&
        playValue[0].isNotEmpty) {
      WinnerDialogBox(playValue[0]);
    } else if (playValue[2] == playValue[4] &&
        playValue[2] == playValue[6] &&
        playValue[2].isNotEmpty) {
      WinnerDialogBox(playValue[2]);
    } else {
      if (!playValue.contains('')) {
        WinnerDialogBox('noone');
      }
    }
  }

  Future<dynamic> WinnerDialogBox(String winner) {
    scoreCalculate(winner);
    return Get.defaultDialog(
        barrierDismissible: false,
        title: winner == 'noone' ? 'Match Draw' : 'Congratulations',
        backgroundColor: Colors.white,
        content: Padding(
          padding: EdgeInsets.all(10),
          child: winner == 'noone'
              ? Column(
                  children: [
                    Text(
                      'Match Draw',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'You both played well',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            resetGame();
                          },
                          child: Text('Play Again'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed('/home');
                          },
                          child: Text('Exit'),
                        ),
                      ],
                    )
                  ],
                )
              : Column(
                  children: [
                    SvgPicture.asset(
                      IconsPath.kingIcon,
                      width: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Congratulations',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '$winner won the match',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            resetGame();
                          },
                          child: Text('Play Again'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed('/home');
                          },
                          child: Text('Exit'),
                        ),
                      ],
                    )
                  ],
                ),
        ));
  }

  void resetGame() {
    playValue.value = ["", "", "", "", "", "", "", "", ""].obs;
    isXtime.value = !isXtime.value;
    Get.back();
  }

  void scoreCalculate(String winner) {
    if (winner == 'X') {
      xScore.value = xScore.value + 1;
    } else if (winner == 'O') {
      oScore.value = oScore.value + 1;
    }
  }

/*  void matchDrawMessage(click) {
    if (click == 9) {
      Get.defaultDialog(
        title: 'Match Draw',
        barrierDismissible: false, // Prevent dismissing without action
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your match is a draw. Do you want to play again or cancel?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Adjust color as per theme
              ),
            ),
            SizedBox(height: 20), // Spacing below the message
          ],
        ),
        cancel: TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red, // Button text color
            ),
          ),
        ),
        confirm: TextButton(
          onPressed: () {
            click.value = 0;
            gameValue.value = ["", "", "", "", "", "", "", "", ""];
            Get.back(); // Close the dialog
          },
          child: Text(
            'Play Again',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green, // Button text color
            ),
          ),
        ),
      );
    }
  }*/

  // void winnerDialogBox() {
  //   isWinner.value = true;
  //   Get.defaultDialog(
  //       title: '🥇 Winner 🥇',
  //       barrierDismissible: false,
  //       content: Column(
  //         children: [
  //           Icon(
  //             Icons.confirmation_num_rounded,
  //             size: 50,
  //             color: Colors.green,
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           isXtime.value
  //               ? Text(
  //                   'Player O Is Winner',
  //                   style: TextStyle(
  //                     fontSize: 30,
  //                   ),
  //                 )
  //               : Text(
  //                   'Player X Is Winner',
  //                   style: TextStyle(
  //                     fontSize: 30,
  //                   ),
  //                 ),
  //           Row(
  //             children: [
  //               ElevatedButton.icon(
  //                 onPressed: () {
  //                   Get.back();
  //                 },
  //                 icon: Icon(Icons.close),
  //                 label: Text('Close'),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               ElevatedButton.icon(
  //                 onPressed: () {
  //                   playValue.value = ["", "", "", "", "", "", "", "", ""];
  //                   isWinner.value = false;
  //                   click.value = 0;
  //                   Get.back();
  //                 },
  //                 icon: Icon(Icons.play_circle_fill_outlined),
  //                 label: Text('Play Again'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ));
  // }
}
