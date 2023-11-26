import 'package:db/common/api/address.dart';
import 'package:db/common/const/color.dart';
import 'package:flutter/material.dart';

class MeetUpList extends StatefulWidget {
  const MeetUpList({super.key});

  @override
  State<MeetUpList> createState() => _MeetUpListState();
}

class _MeetUpListState extends State<MeetUpList> {
  late final List<String> bbookName, bbookPrice, bbuyer, bseller;
  late final List<String> sbookName, sbookPrice, sbuyer, sseller;

  Future<String?> getList() async {
    return 'success';
  }

  @override
  void initState() {
    bbookName = ['hi', 'hoho', 'hoo'];
    bbookPrice = ['hi', 'hoho', 'hoo'];
    bbuyer = ['hi', 'hoho', 'hoo'];
    bseller = ['hi', 'hoho', 'hoo'];
    sbookName = ['hi', 'hoho', 'hoo'];
    sbookPrice = ['hi', 'hoho', 'hoo'];
    sbuyer = ['hi', 'hoho', 'hoo'];
    sseller = ['hi', 'hoho', 'hoo'];
    super.initState();
  }

  void onTap(dynamic arguments) {
    Navigator.of(context).pushNamed(meetUpScreen, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: FutureBuilder<String?>(
              future: getList(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const Text(
                      '판매 약속 리스트',
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: bseller.length,
                          itemBuilder: (context, index) {
                            return MeetUp(
                              onTap: () => onTap(index),
                              behave: '판매',
                              seller: bseller[index],
                              bookName: bbookName[index],
                              bookPrice: bbookPrice[index],
                              buyer: bbuyer[index],
                            );
                          },
                        ),
                      ),
                    ),
                    const Text(
                      '구매 약속 리스트',
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: sseller.length,
                          itemBuilder: (context, index) {
                            return MeetUp(
                              onTap: () => onTap(index),
                              behave: '구매',
                              seller: sseller[index],
                              bookName: sbookName[index],
                              bookPrice: sbookPrice[index],
                              buyer: sbuyer[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class MeetUp extends StatelessWidget {
  final String buyer, seller, bookName, bookPrice, behave;
  final VoidCallback onTap;
  const MeetUp({
    super.key,
    required this.bookName,
    required this.bookPrice,
    required this.buyer,
    required this.seller,
    required this.behave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.person_2,
                  ),
                  Text(
                    seller,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.arrow_forward_sharp,
                  ),
                  Text(
                    behave,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.person_2_outlined,
                  ),
                  Text(
                    seller,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(bookName),
                  Text(bookPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
