import 'package:flutter/material.dart';
import '../model/joke.dart';
import '../services/joke_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/joke_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final JokeService _jokeService = JokeService();
  List<Joke> jokes = [];
  bool _isLoading = false;
  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    _refreshIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    loadJokes();
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    super.dispose();
  }

  Future<void> loadJokes() async {
    setState(() => _isLoading = true);
    try {
      final loadedJokes = await _jokeService.getCachedJokes();
      if (mounted) {
        setState(() => jokes = loadedJokes);
      }
    } catch (e) {
      print('Error loading jokes: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchJokes() async {
    _refreshIconController.repeat();
    setState(() => _isLoading = true);
    try {
      final newJokes = await _jokeService.fetchJokes();
      if (mounted) {
        setState(() => jokes = newJokes);
      }
    } catch (e) {
      print('Error fetching jokes: $e');
      final cachedJokes = await _jokeService.getCachedJokes();
      if (mounted) {
        setState(() => jokes = cachedJokes);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _refreshIconController.stop();
      _refreshIconController.reset();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 64,
            color: Color.fromARGB(255, 0, 137, 123),
          ),
          const SizedBox(height: 16),
          const Text(
            'No jokes available',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: fetchJokes,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        onRefresh: fetchJokes,
        refreshController: _refreshIconController,
      ),
      body: RefreshIndicator(
        onRefresh: fetchJokes,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : jokes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: jokes.length,
                      itemBuilder: (context, index) {
                        return JokeCard(
                          key: ValueKey(jokes[index].hashCode),
                          joke: jokes[index],
                          index: index,
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
