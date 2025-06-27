import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]);

    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6),
            Text('Tic Tac Toe Multiplayer', style: textStyle),
            SizedBox(height: 20),
            Text('How the App Works:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6),
            Text(
              '1. Splash Screen: Displays the app logo briefly.\n'
              '2. Welcome Pages: Guide new users with app features and usage.\n'
              '3. Guest & Game Mode: Users can choose to play as guests or sign in.\n'
              '4. Multiplayer Rooms: Users can create or join rooms to play Tic Tac Toe online.\n'
              '5. Profile: Users can view their profile, total wins, losses, draws, and points.\n'
              '6. Game Play: Play Tic Tac Toe online in real-time with friends or others.\n',
              style: textStyle,
            ),
            SizedBox(height: 20),
            Text('Features:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6),
            Text(
              '• Real-time online multiplayer gameplay.\n'
              '• Profile stats tracking (wins, losses, draws, points).\n'
              '• Clean and simple user interface.\n'
              '• Cross-platform support.\n',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
