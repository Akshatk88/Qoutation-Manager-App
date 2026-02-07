class QuotationModel {
  double price;
  double discount;
  int quantity;
  double totalPrice;

  int cuvette;
  String cuvetteType;

  QuotationModel({
    required this.price,
    required this.discount,
    required this.quantity,
    required this.totalPrice,
    this.cuvette = 0,
    this.cuvetteType = '',
  });

  double get finalAmount =>
      (price * quantity) - ((price * quantity) * discount / 100);
}
