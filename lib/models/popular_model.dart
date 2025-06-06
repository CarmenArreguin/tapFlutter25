class PopularModel {
  //bool adult;
  final String backdropPath;
  //List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  //bool video;
  final double voteAverage;
  final int voteCount;

//required valor que se requiere si o si
//En este constructor las llaves me indican que los parámetros son nombrados (no importa el orden en que se envien los parametros)
  PopularModel({
    //required this.adult,
    required this.backdropPath,
    //required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    //required this.video,
    required this.voteAverage,
    required this.voteCount,
  });


  factory PopularModel.fromMap(Map<String,dynamic> movie){
    return PopularModel(
      //cualeses, valida si esto es nulo, si es nulo se cambia lo de la derecha. Si no es nulo se asigna su .
      //backdropPath: movie['backdrop_path'] ?? '',
      backdropPath: movie['backdrop_path'] != null 
          ? 'https://image.tmdb.org/t/p/w500/${movie['backdrop_path']}' 
          : 'https://dinahosting.com/blog/upload/2021/03/error-404.jpg',
      id: movie['id'] ?? 0,
      originalLanguage: movie['original_language'] ?? '',
      originalTitle: movie['original_title'] ?? '', 
      overview: movie['overview'] ?? '',
      popularity: (movie['popularity'] is num) ? (movie['popularity'] as num).toDouble() : 0.0, 
      posterPath: movie['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500/${movie['poster_path']}'
          : 'https://via.placeholder.com/200x300?text=No+Image',
      releaseDate: movie['release_date'] ?? '',
      title: movie['title'] ?? '',
      voteAverage: (movie['vote_average'] is num) ? (movie['vote_average'] as num).toDouble() : 0.0,
      voteCount: (movie['vote_count'] is int) ? movie['vote_count'] : 0,
    );
  }
}