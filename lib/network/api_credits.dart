import 'package:dio/dio.dart';
import 'package:tap2025/models/actor_model.dart';

class ApiCredits {
  final Dio _dio = Dio();

  Future<List<Actor>> getMovieCredits(String movieId) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX',
      );

      final List<dynamic> cast = response.data['cast'];
      return cast.take(10).map((actor) => Actor.fromMap(actor)).toList();
    } catch (e) {
      throw Exception('Error al obtener el reparto: $e');
    }
  }
}