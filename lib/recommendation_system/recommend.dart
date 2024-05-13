import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyAPI {
  final String clientId;
  final String clientSecret;

  SpotifyAPI(this.clientId, this.clientSecret);

  Future<List<String>> recommendSongsForMood(String mood) async {
    try {
      // Authenticate with Spotify API
      final token = await _authenticate();

      // Make request to Spotify API to get recommended songs based on mood
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/recommendations?seed_genres=$mood'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and extract song names
        final List<dynamic> data = jsonDecode(response.body)['tracks'];
        List<String> songNames = [];
        for (var track in data) {
          songNames.add(track['name']);
        }
        return songNames;
      } else {
        // If request fails, throw an error
        throw Exception(
            'Failed to load recommended songs: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw Exception('Failed to load recommended songs: $e');
    }
  }

  Future<String> _authenticate() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response and extract the access token
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data['access_token'];
    } else {
      // If authentication fails, throw an error
      throw Exception('Failed to authenticate with Spotify API');
    }
  }
}
