class MeetingModel {
  final String seller,
      buyer,
      sellerPhone,
      buyerPhone,
      bookName,
      className,
      author,
      publisher,
      publishedYear;
  final int price, bookID, sellerID, buyerID;

  MeetingModel.fromJson(Map<String, dynamic> json)
      : buyer = json['buyer'],
        seller = json['seller'],
        sellerPhone = json['s_phone'],
        buyerPhone = json['b_phone'],
        bookName = json['book_name'],
        className = json['class_name'],
        author = json['author'],
        publisher = json['publisher'],
        publishedYear = json['published_year'],
        price = json['price'],
        bookID = json['book_id'],
        sellerID = json['seller_id'],
        buyerID = json['buyer_id'];
}
