import 'package:flutter/material.dart';
import 'package:schedule_profs/main.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/app_dialog.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool obscureTextFlagForNewPassword = true;
  bool obscureTextFlagForConfirmNewPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future _passwordReset() async {

    if(changePasswordFormKey.currentState!.validate()) {
      try {

        final res = await supabase.auth.updateUser(
          UserAttributes(
            password: _passwordController.text.trim()
          )
        );
        
        AppDialog.showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Password updated sucessfully.',
          onConfirm: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const TeacherScreen()));
          }
        );

      } on AuthException catch (error) {
        
        Alert.of(context).showError('${error.message} 😢😢😢');
        

      }

    } else {
      Alert.of(context).showError("Make sure your password match");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MAROON,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: changePasswordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
            
            
                const Text(
                  'Update your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                ),
            
                const SizedBox(height: 40),
            
                MyTextFormFieldPasword(
                  controller: _passwordController,
                  hintText: 'New Password',
                  obscureText: obscureTextFlagForNewPassword,
                  suffixIcon: GestureDetector(
            
                    onTap: () {
                      setState(() {
                        obscureTextFlagForNewPassword = !obscureTextFlagForNewPassword;
                      });
                    },
                    child: Icon( obscureTextFlagForNewPassword ?Icons.visibility_off :Icons.visibility )
                  ),
                  
                  validator: (value)=> Validator.of(context).validateTextField(value, "New Password"),
                ),
                
                const SizedBox(height: 10),
            
                MyTextFormFieldPasword(
                  controller: _newPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: obscureTextFlagForConfirmNewPassword,
                  suffixIcon: GestureDetector(
            
                    onTap: () {
                      setState(() {
                        obscureTextFlagForConfirmNewPassword =! obscureTextFlagForConfirmNewPassword;
                      });
                    },
                    child: Icon( obscureTextFlagForConfirmNewPassword ?Icons.visibility_off :Icons.visibility )
                  ),
                  
                  validator: (value) {
                    return Validator.of(context).validateConfirmation(value, _passwordController.text.trim(), 'Confirm Password');
                  }
                ),
            
                const SizedBox(height: 20),
            
                MyButton(
                  onTap: _passwordReset,
                  buttonName: 'Update'
                )
            
              ],  
            
            ),
          ),
        ),
      ),

    );
  }
}