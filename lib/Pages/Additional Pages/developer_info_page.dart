import 'package:flutter/material.dart';

class DeveloperInfoPage extends StatelessWidget {
  const DeveloperInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[800]);

    final List<String> skills = [
      'Flutter',
      'Dart',
      'Firebase',
      'MongoDB',
      'REST API',
      'Python',
      'Git & GitHub',
      'C',
      ' Wordpress ',
      ' Java ',
      ' UI / UX Design ',
      ' State Management ',
      ' C++ ',
      'Pandas',
      ' Machine Learning (Beginner) ',
      ' Numpy ',
      'Motivational Speaker',
      'JavaScript',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images/developersajid.jpg'),
            ),
            const SizedBox(height: 18),
            const Text(
              'Md Sajedur Rahman (Sajid)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 6),
            const Text(
              'Email: developersajid.net@gmail.com',
              style: TextStyle(color: Colors.blueAccent, fontSize: 15),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Skills',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About the Developer',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Md Sajedur Rahman is a passionate and highly motivated software developer with a strong foundation in '
              'mobile app development, particularly using Flutter. With a keen interest in creating meaningful and '
              'user-friendly applications, he consistently aims for clean architecture, elegant UI, and seamless UX. '
              'His work reflects a balance of technical precision and user empathy, ensuring functionality with an '
              'aesthetic touch. Sajid is also enthusiastic about AI, machine learning, and backend technologies like '
              'Firebase and MongoDB, which further enhance the intelligence and scalability of his apps. '
              'This Tic Tac Toe multiplayer app is a testament to his vision of building real-time, interactive, and well-polished '
              'experiences for users across platforms.',
              style: textStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
