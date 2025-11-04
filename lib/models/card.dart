class Card {
  final int id;
  final String cardName;
  final String cardImage;
  final int indexNumber;
  final int rarityId;

  Card({
    required this.id,
    required this.cardName,
    required this.cardImage,
    required this.indexNumber,
    required this.rarityId,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(id: json['id'], cardName: json['cardName'], cardImage: json['cardImage'], indexNumber: json['indexNumber'], rarityId: json['rarityId']);
  }
}