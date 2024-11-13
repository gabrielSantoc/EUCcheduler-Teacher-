import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:schedule_profs/auth/auth.dart';
import 'package:schedule_profs/auth/change_password.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/main.dart';
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
  final String? profileImageUrl;
  final VoidCallback onProfileImageChanged;

  const DrawerClass({
    super.key, 
    required this.profileImageUrl,
    required this.onProfileImageChanged,
  });

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = '${boxUserCredentials.get('userId')}_${path.basename(file.path)}';

      // Delete existing profile picture if there's one
      String? oldFilePath = boxUserCredentials.get("filePath");
      if (oldFilePath != null) {
        await Supabase.instance.client.storage
            .from('profile_pictures')
            .remove([oldFilePath]);
      }


      // Upload new image
      await Supabase.instance.client.storage
          .from('profile_pictures')
          .upload(fileName, file);
          
      // Update file path in tbl_users
      await Supabase.instance.client.from('tbl_users').update({
        'file_path': fileName,
      }).eq('auth_id', boxUserCredentials.get('userId'));

      // Update local storage
      await boxUserCredentials.put("filePath", fileName);
      
      // Notify parent to reload profile image
      onProfileImageChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                ),
                Positioned(
                  right: 80,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: pickAndUploadImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: MAROON,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_center_rounded),
            title: const Text('FAQ'),
            onTap: () {},
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