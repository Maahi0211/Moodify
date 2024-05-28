import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String accessToken;

  SpotifyService(this.accessToken);

  Future<List<dynamic>> getTracksForMood(String mood) async {
    final url = 'https://api.spotify.com/v1/recommendations?limit=20&seed_genres=$mood';

    print('Fetching tracks for mood: $mood');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Tracks fetched: ${data['tracks']}');
      return data['tracks'];
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}
