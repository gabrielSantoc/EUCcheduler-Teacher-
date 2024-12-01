import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:schedule_profs/auth/auth.dart';
import 'package:schedule_profs/auth/change_password.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/main.dart';
import 'package:schedule_profs/screens/FAQ.dart';
import 'package:schedule_profs/screens/about_dev_screen.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const MAROON = Color(0xFF862349);
const WHITE = Color(0xFFFFFFFF);
const LIGHTGRAY = Color(0xFFECECEC);
const GRAY = Color(0xFF8F8E8E);
Widget vSpacerWidth(double width) {

  return SizedBox(

    height: width,

  );
}

class SpacerClass extends StatelessWidget {
  const SpacerClass({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}


class LoadingDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: MAROON,
            size: 60,
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
  }
}


void showConfirmDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 155, 10, 0)
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel 😁'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 155, 10, 0)
            ),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: const Text('Delete 😔'),
          ),
        ],
      );
    },
  );
}


class DrawerClass extends StatelessWidget {
  const DrawerClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/app-icon.png')
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Developers'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutDev()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_center_rounded),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FAQScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Sign Out'),
            onTap: () async {
              await supabase.auth.signOut();
              boxUserCredentials.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PasswordGuide extends StatelessWidget {
  const PasswordGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric( horizontal: 25.0 ),
      child: Text.rich(
        TextSpan(
          text: 'For new users, ',
          children: <TextSpan>[
            TextSpan(
              text: 'your initial password ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'is your birthdate in this format ',
            ),
            TextSpan(
              text: 'YYYY-MM-DD.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}