import 'package:dio/dio.dart';
import 'package:tap2025/models/video_model.dart';

class ApiVideos {
  final Dio _dio = Dio();

  Future<List<Video>> getMovieVideos(String movieId) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX',
      );
      
      final results = response.data['results'] as List;
      return results.map((video) => Video.fromMap(video)).toList();
    } catch (e) {
      throw Exception('Error al obtener videos: $e');
    }
  }

  Future<Video?> getFirstTrailer(String movieId) async {
    final videos = await getMovieVideos(movieId);
    //Intenta encontrar un tráiler de YouTube
  try {
    return videos.firstWhere(
      (video) =>
          video.type.toLowerCase() == 'trailer' &&
          video.site.toLowerCase() == 'youtube',
    );
  } catch (_) {
    //Si no hay tráiler, intenta encontrar cualquier video de YouTube
    try {
      return videos.firstWhere(
        (video) => video.site.toLowerCase() == 'youtube',
      );
    } catch (_) {
      //Si no hay nada, devuelve null
      return null;
    }
  }
  }
}