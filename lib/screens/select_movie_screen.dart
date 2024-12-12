import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../theme.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import 'welcome_screen.dart';
import '../shared/styled_text.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final List<Movie> movies = [];
  int currentIndex = 0;
  int currentPage = 1;
  bool isLoading = false;
  bool isVoting = false;
  bool hasShownSingleUserWarning = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _verifyIdsAndLoadMovies();
  }

  Future<void> _verifyIdsAndLoadMovies() async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.deviceId == null || appState.sessionId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing device ID or session ID')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
      return;
    }
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (isLoading || !mounted) return;
    setState(() => isLoading = true);

    try {
      final response = await HttpHelper.getMovies(currentPage);
      if (!mounted) return;

      final List<dynamic> results = response['results'] as List;
      final List<Movie> newMovies = results.map((movieJson) => Movie.fromJson(movieJson)).toList();

      setState(() {
        movies.addAll(newMovies);
        currentPage++;
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error loading movies: $error');
      }
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movies: $error')),
      );
    }
  }

  Future<void> _handleVote(bool vote) async {
    if (isVoting || currentIndex >= movies.length || !mounted) return;

    setState(() => isVoting = true);

    final appState = Provider.of<AppState>(context, listen: false);
    final movie = movies[currentIndex];

    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                vote ? Icons.thumb_up : Icons.thumb_down,
                color: vote ? AppColors.likeColor : AppColors.dislikeColor,
              ),
              const SizedBox(width: 8),
              StyledText(vote ? 'Liked!' : 'Passed'),
            ],
          ),
          duration: const Duration(milliseconds: 500),
          backgroundColor: AppColors.secondaryColor,
        ),
      );

      final response = await HttpHelper.voteMovie(
        appState.sessionId!,
        movie.id,
        vote,
      );

      if (!mounted) return;

      if (response['data']['num_devices'] == 1) {
        if (!hasShownSingleUserWarning) {
          setState(() {
            hasShownSingleUserWarning = true;
            isVoting = false;
          });

          if (!mounted) return;

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Waiting for Partner'),
              content: const Text(
                'Your friend hasn\'t joined the session yet. Matches can only occur when both users are voting on movies.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _moveToNextMovie();
                  },
                  child: const Text('Continue'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
          return;
        } else {
          _moveToNextMovie();
          return;
        }
      }

      bool isRealMatch = response['data']['match'] == true &&
          response['data']['num_devices'] > 1 &&
          response['data']['movie_id'] == response['data']['submitted_movie'];

      if (!mounted) return;

      if (isRealMatch) {
        setState(() => isVoting = false);
        await _showMatchDialog(movie);
      } else {
        _moveToNextMovie();
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error in vote handling');
        print('Error: $error');
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
      setState(() => isVoting = false);
    }
  }

  Future<void> _showMatchDialog(Movie movie) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const StyledHeading('It\'s a Match!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (movie.posterPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.png',
                      height: 200,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            StyledTitle(movie.title),
            const SizedBox(height: 8),
            StyledText(movie.overview),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                (route) => false,
              );
            },
            child: const StyledText('OK'),
          ),
        ],
      ),
    );
  }

  void _moveToNextMovie() {
    if (!mounted) return;

    setState(() {
      isVoting = false;
      currentIndex++;
      if (currentIndex >= movies.length - 5) {
        _loadMovies();
      }
    });
  }

  Widget _buildDismissBackground(bool isLike) {
    return Container(
      color: isLike ? AppColors.likeColor : AppColors.dislikeColor,
      alignment: isLike ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        isLike ? Icons.thumb_up : Icons.thumb_down,
        color: AppColors.titleColor,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty || currentIndex >= movies.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = movies[currentIndex];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const StyledTitle('Select Movie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: isVoting
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Dismissible(
                key: Key('movie_${movie.id}_$currentIndex'),
                onDismissed: (direction) {
                  _handleVote(direction == DismissDirection.startToEnd);
                },
                background: _buildDismissBackground(true),
                secondaryBackground: _buildDismissBackground(false),
                child: MovieCard(movie: movie),
              ),
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (movie.posterPath != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/dog.jpg',
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledHeading(movie.title),
                const SizedBox(height: 8),
                StyledText('Release Date: ${movie.releaseDate}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.highlightColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    StyledText('${movie.voteAverage.toStringAsFixed(1)}/10'),
                  ],
                ),
                const SizedBox(height: 12),
                StyledText(movie.overview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
