class Actor {
  final String name;
  final String character;
  final String profilePath;

  Actor({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      name: map['name'] ?? 'Nombre no disponible',
      character: map['character'] ?? 'Personaje no disponible',
      profilePath: map['profile_path'] != null 
          ? 'https://image.tmdb.org/t/p/w200${map['profile_path']}'
          : 'https://via.placeholder.com/200x300?text=No+Image',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'character': character,
      'profile_path': profilePath,
    };
  }
}