import 'package:flutter/material.dart';
import 'package:schedule_profs/auth/login.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<AddAnnouncementScreen> {

  final _titeController = TextEditingController();
  final _contentController = TextEditingController();

  final registerFormKey = GlobalKey<FormState>();

  // FUNCTION TO INSERT THE NEW USER INTO THE DB
  createUser(idNumber, firstName, lastName, birthdate, email, userId ) async {
    await Supabase.instance.client
    .from('tbl_users')
    .insert({
      'first_name': firstName,
      'last_name' : lastName,
      'email' : email,
      'section' : null,
      'id_number' : idNumber,
      'user_type' : 'professor',
      'birthday' : birthdate,
      'auth_id' : userId
    });

    print("USER CREATED SUCCESSFULLY");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAROON,
        toolbarHeight: 30,
        iconTheme: const IconThemeData(color: WHITE),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: MAROON,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // TOP WHITE CONTAINER
            Container(
              color: MAROON,
              height: MediaQuery.of(context).size.height * 0.14, 
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,         
                children: [
                  Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    "Announcement",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10)
        
                ],
              ),
            ),
        
            // BOTTOM WHITE CONTAINER
            Container(
              
              height: MediaQuery.of(context).size.height * 0.9, 
              // padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              padding: const EdgeInsets.symmetric( horizontal: 20),
              
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: registerFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const SizedBox(height: 40),

                      MyTextFormField(
                        controller: _titeController,
                        hintText: "Title",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Tite"),
                      ),
                  
                      const SizedBox(height: 20),
                  
                  
                      MyTextFormField(
                        controller: _contentController,
                        hintText: "Content",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateTextField(value, "Content"),
                        maxLines: 10,
                      ),    

                      const SizedBox(height: 20),

                          
                      MyButton(
                        onTap: () {
                          
                        },
                        buttonName: "Publish",
                      ),

                      const SizedBox(height: 15),
                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}