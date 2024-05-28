import 'package:flutter/material.dart';
import 'package:moodify/models/mood.dart';
import 'package:moodify/spotify_service.dart';
import 'package:moodify/ui/widgets/audio_player_popup.dart';

class Moods extends StatefulWidget {
  const Moods({super.key, required this.mood});

  final Mood mood;

  @override
  State<Moods> createState() => _MoodsState();
}

class _MoodsState extends State<Moods> {
  late Future<List<dynamic>> tracks;

  @override
  void initState() {
    super.initState();
    final spotifyService = SpotifyService('BQDRqsBTUgou8puoMbVCH_bCBn4d_KCSDByu1umDwLS-k95vhz__GYQUJBNPVaaYnycxD4vXhJvkFYFxY571Of8GJWZiWyDlpr_pJ3MOfXyxxMcitGBtV9sdwMcye0A4JAU9DKlHEe5sdJnvNPXxD7QvYR4T_lsPrH0TEl9Ft0Uog1W2YgO0Y24F26X0an7oPM-uWZnSPspt3oBRxdY'); // Replace with your token
    tracks = spotifyService.getTracksForMood(widget.mood.title.toLowerCase());
  }

  void _showAudioPlayerPopup(List<dynamic> tracks, int initialIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AudioPlayerPopup(tracks: tracks, initialIndex: initialIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mood.title),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: tracks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No data or empty list');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Oh.. no nothings here',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Try selecting a different category',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            );
          } else {
            print('Tracks found: ${snapshot.data!.length}');
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                var track = snapshot.data![index];
                print('Track: ${track['name']} by ${track['artists'][0]['name']}');
                return ListTile(
                  leading: Image.network(track['album']['images'][0]['url']),
                  title: Text(track['name']),
                  subtitle: Text(track['artists'][0]['name']),
                  onTap: () {
                    String? previewUrl = track['preview_url'];
                    if (previewUrl != null) {
                      _showAudioPlayerPopup(snapshot.data!, index);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Preview not available')),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
