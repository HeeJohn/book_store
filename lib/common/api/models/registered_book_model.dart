class RegisteredBookModel {
  final String rbName, rbPrice, rbDate, rbImage;

  RegisteredBookModel.fromJson(Map<String, dynamic> json)
      : rbName = json['rb_name'],
        rbPrice = json['rb_price'],
        rbDate = json['rb_date'],
        rbImage = json['rb_image'];
}
