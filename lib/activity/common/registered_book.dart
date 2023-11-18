import 'package:flutter/material.dart';

class RegisterdBook extends StatelessWidget {
  final String name;
  final String bookImage;
  final String date;
  final VoidCallback onTap;
  final String price;
  const RegisterdBook({
    super.key,
    required this.name,
    required this.bookImage,
    required this.date,
    required this.onTap,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      bookImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
