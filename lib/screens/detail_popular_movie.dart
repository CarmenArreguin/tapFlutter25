import 'package:flutter/material.dart';
import 'package:tap2025/models/favorite_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/models/actor_model.dart';
import 'package:tap2025/network/api_videos.dart';
import 'package:tap2025/network/api_credits.dart';
import 'package:tap2025/network/api_favorites.dart';
import 'package:flutter/foundation.dart'; // para kIsWeb
import 'package:tap2025/utils/open_link.dart';


class DetailPopularMovie extends StatefulWidget {
  final PopularModel movie;
  const DetailPopularMovie({super.key, required this.movie});

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  YoutubePlayerController? _controller;
  bool _isFavorite = false;
  List<Actor> _actors = [];
  bool _isLoading = true;
  late PopularModel _popular;
  final ApiFavorites _apiFavorites = ApiFavorites();

  @override
  void initState() {
    super.initState();
    _popular = widget.movie;
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await _apiFavorites.isFavorite(_popular.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
  try {
    final video = await ApiVideos().getFirstTrailer(_popular.id.toString());
    if (video != null && video.key.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: video.key,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }

    _actors = await ApiCredits().getMovieCredits(_popular.id.toString());

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar detalles: $e')),
      );
    }
  }
}

  Future<void> _toggleFavorite() async {
    try {
      final favorite = FavoriteModel(
        movieId: _popular.id,
        title: _popular.title,
        posterPath: _popular.posterPath,
        voteAverage: _popular.voteAverage,
      );

      await _apiFavorites.toggleFavorite(favorite, !_isFavorite);

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al ${_isFavorite ? 'eliminar' : 'agregar'} favorito: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${_popular.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: const BackButton(),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndRating(),
                  const SizedBox(height: 8),
                  _buildReleaseDate(),
                  const SizedBox(height: 16),
                  if (_controller != null) _buildTrailer(),
                  _buildSectionTitle('Sinopsis'),
                  const SizedBox(height: 8),
                  Text(
                    _popular.overview.isNotEmpty
                        ? _popular.overview
                        : 'No hay descripción disponible.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Reparto Principal'),
                  const SizedBox(height: 8),
                  _buildActors(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _popular.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              _popular.voteAverage.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReleaseDate() {
    return Text(
      'Estreno: ${_popular.releaseDate}',
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.grey),
    );
  }

  Widget _buildTrailer() {
    if (kIsWeb){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tráiler'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
            final url = 'https://www.youtube.com/watch?v=${_controller?.initialVideoId ?? ''}';
            openLink(url);
            },
            child: const Text('Ver Tráiler en Youtube'),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else if (_controller != null) {
      //En movil o en escritorio, usa el reproductor.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tráiler'),
          const SizedBox(height: 8),
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
            ), 
            builder: (context, player) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: player,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      //Si no hay tráiler entonces no se muestra nada.
      return const SizedBox.shrink();
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActors() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _actors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final actor = _actors[index];
          return SizedBox(
            width: 100,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: actor.profilePath,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  actor.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  actor.character,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
