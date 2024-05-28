import 'package:flutter/material.dart';
import '../../../recommendation_system/recommend.dart';

class MoodSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child:const Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How are you feeling?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  MoodButton(
                    mood: 'Happy',
                    clientId: '83f0a4206f5944e7b9dcb8821a20f2f4',
                    clientSecret: '68c70b86eadf43e7a47a98bf041bd31b',
                  ),
                  SizedBox(height: 10),
                  MoodButton(
                    mood: 'Sad',
                    clientId: '83f0a4206f5944e7b9dcb8821a20f2f4',
                    clientSecret: '68c70b86eadf43e7a47a98bf041bd31b',
                  ),
                  SizedBox(height: 10),
                  MoodButton(
                    mood: 'Angry',
                    clientId: '83f0a4206f5944e7b9dcb8821a20f2f4',
                    clientSecret: '68c70b86eadf43e7a47a98bf041bd31b',
                  ),
                  SizedBox(height: 10),
                  MoodButton(
                    mood: 'Neutral',
                    clientId: '83f0a4206f5944e7b9dcb8821a20f2f4',
                    clientSecret: '68c70b86eadf43e7a47a98bf041bd31b',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoodButton extends StatelessWidget {
  final String mood;
  final String clientId;
  final String clientSecret;

  const MoodButton({
    required this.mood,
    required this.clientId,
    required this.clientSecret,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Fetch recommended songs for the selected mood
          List<String> songs = await SpotifyAPI(clientId, clientSecret)
              .recommendSongsForMood(mood);
          songs = songs.take(10).toList();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongsScreen(songs: songs),
            ),
          );
        } catch (e) {
          print('Error fetching recommended songs: $e');
          // Handle error
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 226, 218, 218),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            mood,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SongsScreen extends StatelessWidget {
  final List<String> songs;

  const SongsScreen({required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Songs'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index]),
          );
        },
      ),
    );
  }
}
