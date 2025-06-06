import 'package:flutter/material.dart';
import 'package:tap2025/models/favorite_model.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_favorites.dart';
import 'package:tap2025/screens/detail_popular_movie.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiFavorites _apiFavorites = ApiFavorites();
  late Future<List<FavoriteModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = _apiFavorites.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Películas Favoritas'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshFavorites();
          return;
        },
        child: FutureBuilder<List<FavoriteModel>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshFavorites,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.movie_creation, size: 50, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No tienes películas favoritas aún'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/popular');
                      },
                      child: const Text('Explorar películas'),
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final favorite = snapshot.data![index];
                  return Card(
                    key: ValueKey(favorite.movieId),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          favorite.posterPath,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.movie, size: 50),
                        ),
                      ),
                      title: Text(favorite.title),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(favorite.voteAverage.toStringAsFixed(1)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          try {
                            await _apiFavorites.toggleFavorite(favorite, false);
                            _refreshFavorites();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${favorite.title} eliminada de favoritos'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al eliminar: $e'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        final popular = PopularModel(
                          backdropPath: '',
                          id: favorite.movieId,
                          originalLanguage: '',
                          originalTitle: favorite.title,
                          overview: '',
                          popularity: favorite.voteAverage,
                          posterPath: favorite.posterPath.isNotEmpty
                              ? favorite.posterPath
                              : 'https://via.placeholder.com/200x300?text=No+Image',
                          releaseDate: '',
                          title: favorite.title,
                          voteAverage: favorite.voteAverage,
                          voteCount: 0,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPopularMovie(movie: popular),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
