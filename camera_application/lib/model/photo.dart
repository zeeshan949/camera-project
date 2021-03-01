class Photo {

  final int id;
  final String imageName;
  final String imageUrl;
  final int userId;

  Photo({this.id, this.imageName, this.imageUrl, this.userId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      imageName: json['imageName'],
      imageUrl: json['imageUrl'],
      userId: json['userId']
    );
  }

}