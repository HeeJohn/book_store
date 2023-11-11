// import 'package:flutter/material.dart';

// class CustomRadioButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//   final bool isPressed;

//   const CustomRadioButton({
//     Key? key,
//     required this.text,
//     required this.onTap,
//     this.isPressed = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(10),
//       onTap: onTap,
//       child: Material(
//         elevation: isPressed ? 10.0 : 0.0,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           width: 200.0,
//           height: 200.0,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               shape: BoxShape.rectangle,
//               color: (isPressed ? textColor : Colors.white),
//               border: Border.all(
//                 color: isPressed
//                     ? const Color.fromARGB(255, 185, 78, 218)
//                     : textColor,
//                 width: 10.0,
//               )),
//           child: Center(
//             child: AutoSizeText(
//               text,
//               style: TextStyle(
//                 color: isPressed ? Colors.white : textColor,
//               ),
//               maxFontSize: 50,
//               minFontSize: 30,
//               maxLines: 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
