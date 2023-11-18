import 'package:db/common/const/color.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final VoidCallback onItemTap;
  final SearchController controller;
  final void Function(String)? onChanged;
  final VoidCallback onBarTap;
  const Search({
    super.key,
    required this.onItemTap,
    required this.onBarTap,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 255, 255),
          ),
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.only(right: 16),
          ),
          onTap: widget.onBarTap,
          onChanged: widget.onChanged,
          leading: Container(
            color: const Color.fromARGB(255, 223, 223, 223),
            width: 60,
            height: 60,
            child: const Icon(
              Icons.search,
              color: grey,
            ),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(
          5,
          (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: widget.onItemTap,
            );
          },
        );
      },
    );
  }
}
