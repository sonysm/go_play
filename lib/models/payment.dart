class Payment {
  final int id;
  final String name;
  final String recipientAcc;
  final String recipientName;
  final String slug;

  const Payment({
    required this.id,
    required this.name,
    required this.recipientAcc,
    required this.recipientName,
    required this.slug,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        name: json['name'],
        recipientAcc: json['recipient_acc'],
        recipientName: json['recipient_name'],
        slug: json['slug'],
      );
}
