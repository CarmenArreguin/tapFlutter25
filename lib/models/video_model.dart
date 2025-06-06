class Video {
  final String key;
  final String type;
  final String name;
  final String site;

  Video({
    required this.key,
    required this.type,
    required this.name,
    required this.site,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      key: map['key'] ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      site: map['site'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'type': type,
      'name': name,
      'site': site,
    };
  }
}