import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class HttpHelper {
  static const String movieNightBaseUrl = 'https://movie-night-api.onrender.com';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbApiKey = '46b6cbbb05b24260c75c6dea88aafc04';

  static Future<Map<String, dynamic>> startSession(String? deviceId) async {
    if (deviceId == null) throw Exception('Device ID is required');

    try {
      final response = await http
          .get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));


      if (response.statusCode != 200) {
        throw Exception('Failed to start session: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print('Error starting session: $error');
      }
      throw Exception('Failed to start session: $error');
    }
  }

  static Future<Map<String, dynamic>> joinSession(String? deviceId, String code) async {
    if (deviceId == null) throw Exception('Device id is required');

    try {
      final response = await http.get(
          Uri.parse('$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'));

      if (response.statusCode != 200) {
        throw Exception('Failed to join session: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print('Error joining session: $error');
      }
      throw Exception('Failed to join session: $error');
    }
  }

  static Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool vote) async {
    try {
      final response = await http.get(Uri.parse(
          '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'));

      if (response.statusCode != 200) {
        throw Exception('Failed to vote: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print('Error voting: $error');
      }
      throw Exception('Failed to vote: $error');
    }
  }


  static Future<Map<String, dynamic>> getMovies(int page) async {
    try {
      final response = await http.get(Uri.parse(
          '$tmdbBaseUrl/movie/popular?api_key=$tmdbApiKey&language=en-US&page=$page'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch movies: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching movies: $error');
      }
      throw Exception('Failed to fetch movies: $error');
    }
  }

  static String getImageUrl(String path, {bool isBackdrop = false}) {
    const baseUrl = 'https://image.tmdb.org/t/p/';
    final size = isBackdrop ? 'w1280' : 'w500';
    return '$baseUrl$size$path';
  }
}
