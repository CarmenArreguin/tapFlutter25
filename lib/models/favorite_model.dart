class FavoriteModel {
  final int movieId;
  final String title;
  final String posterPath;
  final double voteAverage;

  FavoriteModel({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      movieId: map['movieId'],
      title: map['title'],
      posterPath: map['posterPath'] ?? 'https://via.placeholder.com/200x300?text=No+Image',
      voteAverage: (map['voteAverage'] is num) ? (map['voteAverage'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
    };
  }
}
