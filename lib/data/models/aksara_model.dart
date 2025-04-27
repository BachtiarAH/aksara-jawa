class AksaraModel {
  final String huruf;
  final String image;
  final String audio;
  final String deskripsi;

  AksaraModel({
    required this.huruf,
    required this.image,
    required this.audio,
    required this.deskripsi,
  });

  factory AksaraModel.fromJson(Map<String, dynamic> json) {
    return AksaraModel(
      huruf: json['huruf'],
      image: json['image'],
      audio: json['audio'],
      deskripsi: json['deskripsi'],
    );
  }
}
