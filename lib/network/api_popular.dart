import 'package:dio/dio.dart';
import 'package:tap2025/models/popular_model.dart';

class ApiPopular {

  final URL = 'https://api.themoviedb.org/3/movie/popular?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1';

//Protocolo http, post, get, delete, put
//Inspecciónar-network-headers, corroboramos petición get en la web
//Diferencia entre http y dio, la libreria "dio" maneja cache y http no
  Future<List<PopularModel>> getPopularMovies() async{
    final dio = Dio();
    final response = await dio.get(URL);
    final res = response.data['results'] as List;
    //El map funciona como un foreach
    return res.map((movie) => PopularModel.fromMap(movie)).toList();
  }
}