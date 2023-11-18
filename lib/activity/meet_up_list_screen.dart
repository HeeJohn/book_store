import 'package:db/common/const/color.dart';
import 'package:db/home/common/layout.dart';
import 'package:flutter/material.dart';

class MeetUpList extends StatelessWidget {
  const MeetUpList({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                '구매 약속 리스트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return null;
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                '판매 약속 리스트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MeetUp extends StatelessWidget {
  final String buyer, seller, bookName, bookPrice;
  const MeetUp({
    super.key,
    required this.bookName,
    required this.bookPrice,
    required this.buyer,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: grey,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Icon(
                Icons.person_2,
              ),
              Text(buyer),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.person_2,
              ),
              Text(
                seller,
              ),
            ],
          ),
          Column(
            children: [
              Text(bookName),
              Text(bookPrice),
            ],
          ),
        ],
      ),
    );
  }
}
