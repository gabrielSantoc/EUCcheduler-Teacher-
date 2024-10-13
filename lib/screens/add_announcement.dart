import 'package:flutter/material.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAnnouncementScreen extends StatefulWidget {

  final int schedId;

  const AddAnnouncementScreen({ required this.schedId, super.key});
  
  
  @override
  State<AddAnnouncementScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<AddAnnouncementScreen> {

  final _titeController = TextEditingController();
  final _contentController = TextEditingController();

  final addAnnouncementFormKey = GlobalKey<FormState>();

   // ANCHOR - ADD SUBJECT FUNCTION
  void addAnouncement(int scheduleId, DateTime createdAt, String title, String content) async {

    if(addAnnouncementFormKey.currentState!.validate()) {
      try {
        await Supabase.instance.client
        .from('tbl_announcement')
        .insert({
          'schedule_id': scheduleId,
          'created_at' : createdAt.toIso8601String(),
          'title' : title,
          'content' : content,
        });

        print("ANNOUNCEMENT ID :::: ${scheduleId}");
        print("Announcement has been successfully added!");
        
        Alert.of(context).showSuccess("Announcement has been successfully added!🥰🥰🥰");
        // Navigator.pop(context); => Mas efficient sana to kaso hindi ma rerebuild yung widget
        // ito na lang muna pansamantagal
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context)=> const TeacherScreen())
        );
      }catch (e) {
        Alert.of(context).showError("$e 😢😢😢");
      }
    }
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
                key: addAnnouncementFormKey,
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
                          var createdAt = DateTime.now();
                          print("CREATED AT ::::: $createdAt");
                          addAnouncement(
                            widget.schedId,
                            createdAt,
                            _titeController.text.toString().trim(),
                            _contentController.text.toString().trim(),
                          );
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