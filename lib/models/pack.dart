class Pack {
  final int id;
  final String packName;
  final String packImage;
  final int price;
  final int cardQuantity;
  final int? globalQuantity;

  Pack({
    required this.id,
    required this.packName,
    required this.packImage,
    required this.price,
    required this.cardQuantity,
    this.globalQuantity,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      id: json['id'],
      packName: json['packName'],
      packImage: json['packImage'],
      price: json['price'],
      cardQuantity: json['cardQuantity'],
      globalQuantity: json['globalQuantity'],
    );
  }
}