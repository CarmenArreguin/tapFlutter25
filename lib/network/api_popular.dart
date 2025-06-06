import 'package:dio/dio.dart';
import 'package:tap2025/models/popular_model.dart';

class ApiPopular {
  final String _url = 'https://api.themoviedb.org/3/movie/popular?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1';

//Protocolo http, post, get, delete, put
//Inspecciónar-network-headers, corroboramos petición get en la web
//Diferencia entre http y dio, la libreria "dio" maneja cache y http no
  Future<List<PopularModel>> getPopularMovies() async{
    try {
      final dio = Dio();
      final response = await dio.get(_url);
      final List results = response.data['results'];
      return results.map((movie) => PopularModel.fromMap(movie)).toList();
    } catch (e) {
      print('Error al obtener películas populares: $e');
      return [];
    }
  }
}