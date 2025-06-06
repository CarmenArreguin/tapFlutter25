import 'package:dio/dio.dart';
import 'package:tap2025/models/favorite_model.dart';

class ApiFavorites {
  final Dio _dio = Dio();
  final String _apiKey = '953c56ba9510ee260002f989459f81a9';
  final String _sessionId = '8af913d50d532bfc7efaeac55ca817ae64a44752';
  final String _accountId = '22057059';
  //token: 1f06cff9e829a373423ad79415afbf92cbe71e95

  Future<List<FavoriteModel>> getFavorites() async {
    final url =
        'https://api.themoviedb.org/3/account/$_accountId/favorite/movies?api_key=$_apiKey&session_id=$_sessionId';
    try {
      final response = await _dio.get(url);
      final List<dynamic> results = response.data['results'];
      return results
          .map((item) => FavoriteModel.fromMap({
                'movieId': item['id'],
                'title': item['title'],
                'posterPath':
                    'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                'voteAverage': (item['vote_average'] as num).toDouble(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener favoritos: $e');
    }
  }

  //Para marcar o desmarcar una película como favorita
  Future<void> toggleFavorite(FavoriteModel favorite, bool isFavorite) async {
    final url =
        'https://api.themoviedb.org/3/account/$_accountId/favorite?api_key=$_apiKey&session_id=$_sessionId';
    try {
      await _dio.post(url, data: {
        'media_type': 'movie',
        'media_id': favorite.movieId,
        'favorite': isFavorite,
      });
    } catch (e) {
      throw Exception(
          'Error al ${isFavorite ? "agregar" : "eliminar"} favorito: $e');
    }
  }

  // Verifica si una película es favorita
  Future<bool> isFavorite(int movieId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((fav) => fav.movieId == movieId);
    } catch (e) {
      return false;
    }
  }
}