


// class MyButton extends StatelessWidget {
//   const MyButton({super.key, required this.onTap, required this.buttonName});

//   final void Function()? onTap;
//   final String buttonName;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 21),
//         margin: const EdgeInsets.symmetric(horizontal: 30),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           color: Color(0xFF9e0b0f)
//         ),
//         child: Center(
//           child: Text(
//             buttonName,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:schedule_profs/shared/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.buttonName});

  final void Function()? onTap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10)),
          backgroundColor: const WidgetStatePropertyAll(MAROON),
          foregroundColor: const WidgetStatePropertyAll(WHITE),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              
            )
          )
        ),
        child: Text(
          buttonName, 
          style: const TextStyle(
            fontSize: 18
          )
        ),

      ),
    );
  }
}


class MyButton2 extends StatelessWidget {
  const MyButton2({super.key, required this.onTap, required this.buttonName});

  final void Function()? onTap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: OutlinedButton(
      
        style: OutlinedButton.styleFrom(
          foregroundColor: WHITE,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          side: const BorderSide(
            color: WHITE,
            width: 2
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonName, 
          style: const TextStyle( 
            fontSize: 15,
            fontWeight:  FontWeight.bold
          )
        ),
      ),
    );
  }
}

class CustomFloatingActionButoon extends StatelessWidget {
  const CustomFloatingActionButoon({super.key, this.onTap});

  
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      shape: const CircleBorder(),
      backgroundColor: MAROON,
      child: const Icon(
        Icons.add,
        color: WHITE,
      ),
    );
  }
}

