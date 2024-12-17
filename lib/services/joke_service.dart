import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../model/joke.dart';

class JokeService {
  final Dio _dio = Dio();
  final String _cacheKey = 'cached_jokes';
  final int _maxCachedJokes = 50;
  final int _displayCount = 5;

  Future<List<Joke>> getCachedJokes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        final allJokes = jsonList.map((json) => Joke.fromJson(json)).toList();

        // Return random subset of jokes
        if (allJokes.isNotEmpty) {
          allJokes.shuffle(Random());
          return allJokes.take(_displayCount).toList();
        }
      }
    } catch (e) {
      // if it is on debug mode, print the error
      if (kDebugMode) {
        print('Error loading cached jokes: $e');
      }
    }
    return [];
  }

  Future<List<Joke>> fetchJokes() async {
    try {
      final response =
          await _dio.get('https://official-joke-api.appspot.com/jokes/ten');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final newJokes = data.map((joke) => Joke.fromJson(joke)).toList();
        await _appendToCache(newJokes);
        return getCachedJokes();
      }
    } catch (e) {
      print('Error fetching jokes: $e');
      return getCachedJokes();
    }
    return [];
  }

  Future<void> _appendToCache(List<Joke> newJokes) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_cacheKey);
    List<Joke> allJokes = [];

    if (cachedData != null) {
      final List<dynamic> jsonList = json.decode(cachedData);
      allJokes = jsonList.map((json) => Joke.fromJson(json)).toList();
    }

    // Add new jokes
    allJokes.addAll(newJokes);

    // Keep only the most recent maxCachedJokes
    if (allJokes.length > _maxCachedJokes) {
      allJokes = allJokes.sublist(allJokes.length - _maxCachedJokes);
    }

    // Save back to cache
    final String jsonData =
        json.encode(allJokes.map((joke) => joke.toJson()).toList());
    await prefs.setString(_cacheKey, jsonData);
  }
}
