import 'package:flutter/material.dart';

class Notify extends StatelessWidget {
  final String buyer;
  final String price;
  final String bookName;

  const Notify({
    super.key,
    required this.buyer,
    required this.bookName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(buyer)],
      ),
    );
  }
}
