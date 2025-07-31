class Artwork {
  final int id;
  final String title;
  final String artist;
  final String date;
  final String imageId;
  final String description;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.date,
    required this.imageId,
    required this.description,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      artist: json['artist_title'] ?? 'Unknown',
      date: json['date_display'] ?? 'No date',
      imageId: json['image_id'] ?? '',
      description: json['thumbnail']?['alt_text'] ?? 'No description available',
    );
  }

  String get imageUrl =>
      'https://www.artic.edu/iiif/2/$imageId/full/843,/0/default.jpg';
}
