import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/model/section_model.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAnnouncement extends StatefulWidget {
  const EditAnnouncement({
    super.key,
    required this.announcementId,
    required this.title,
    required this.content
  });


  final int announcementId;
  final String title;
  final String content;

  @override
  State<EditAnnouncement> createState() => _EditSubjectStateScreen();
}

class _EditSubjectStateScreen extends State<EditAnnouncement> {
  
  @override
  void initState() {
    super.initState();

    fillOutForm(
      widget.title,
      widget.content,
    );
  }

  final _titeController = TextEditingController();
  final _contentController = TextEditingController();

  final editAnnouncementFormKey = GlobalKey<FormState>();

 

  // ANCHOR - EDIT SUBJECT FUNCTION
  void editAnnouncement(int announcementId, String announcementTitle, String announcementContent) async {

    if(editAnnouncementFormKey.currentState!.validate()) {
      try {
        await Supabase.instance.client
        .from('tbl_announcement')
        .update({
          'title' : announcementTitle,
          'content' : announcementContent,
        })
        .eq("id", announcementId);

        print("ANNOUNCEMENT WAS UPDATED SUCCESSFULLY");
        Alert.of(context).showSuccess("Announcement was updated successfully🥰🥰🥰");
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

  void fillOutForm(String announcmentTitle, String announcmentContent) {

    _titeController.text = announcmentTitle;
    _contentController.text = announcmentContent;

    print("ANNOUNCMENT TITLE :::: ${widget.title}");
    print("ANNOUNCEMENT CONTENT   :::: ${widget.content}");

  }

  @override
  Widget build(BuildContext context) {
    // LAMANAN YUNG MGA TEXTFIELD KUNG ALING SUBJECT YUNG PININDOT NILA

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
                    "Edit Announcement",
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
                key: editAnnouncementFormKey,
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
                          editAnnouncement(
                            widget.announcementId,
                            widget.title,
                            widget.content
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