import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tictactoeonlineplay/Controller/LobbyController.dart';
import '../Configs/AssetsPath.dart';
import '../Controller/RoomController.dart';

class RoomInfo extends StatelessWidget {
  final String roomCode;
  const RoomInfo({
    super.key,
    required this.roomCode,
  });

  @override
  Widget build(BuildContext context) {
    LobbyController lobbyController = Get.put(LobbyController());
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Generated Room Code'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 70,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            roomCode,
                            style: TextStyle(
                              letterSpacing: 2.2,
                              fontSize: 35,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        lobbyController.copyRoomCode(roomCode);
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: SvgPicture.asset(IconsPath.copyIcon),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Share This Private code with your Friends & Ask Theme To Join The Game',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
