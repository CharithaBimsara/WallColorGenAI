class ImageModel {
  final String email;
  final String interiorImageId;
  final String augmentedImageUrl;
  final String texture;
  final String complexityScore;
  final String interiorImageUrl;
  final String generates;
  final String timeStamp;

  ImageModel({
    required this.email,
    required this.interiorImageId,
    required this.augmentedImageUrl,
    required this.texture,
    required this.complexityScore,
    required this.interiorImageUrl,
    required this.generates,
    required this.timeStamp,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      email: json['email'].toString(),
      interiorImageId: json['interiorImageId'].toString(),
      augmentedImageUrl: json['augmentedImageUrl'].toString(),
      texture: json['texture'].toString(),
      complexityScore: json['complexityScore'].toString(),
      interiorImageUrl: json['interiorImageUrl'].toString(),
      generates: json['generates'].toString(),
      timeStamp: json['timeStamp'].toString(),
    );
  }

  get imgurl => null;
}
