import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_profs/model/section_model.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditSubjectScreen extends StatefulWidget {
  const EditSubjectScreen({super.key});

  @override
  State<EditSubjectScreen> createState() => _EditSubjectStateScreen();
}

class _EditSubjectStateScreen extends State<EditSubjectScreen> {
  
  @override
  void initState() {
    super.initState();
    getAllAvailableSections();
  }

  final _sectionController = TextEditingController();
  final _subjectName = TextEditingController();
  final _timeStartController = TextEditingController();
  final _timeEndController = TextEditingController();

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

  final List<String> _sections = [];
  Future<void> getAllAvailableSections() async {
    
    try{
      
      final selectAllSection = await 
      Supabase.instance.client
      .from('tbl_section')
      .select();
      
      for(var s in selectAllSection) {
        var section = SectionModel(
          sectionName: s['section']
        );

        _sections.add(s['section']);
      }

      for(var s in _sections) {
        print("SECTION ::: $s");
      }

    } catch (e) {
      print("ERROR ::: $e");
    }

  }

  Future<void> selectSection() async {
    // Show the Cupertino modal popup
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            onSelectedItemChanged: (int value) {
              
              setState(() {
                _sectionController.text = _sections[value];
              });
              print('SECTION :::: ${_sections[value]}'); 
            },
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: _sections.map((section) => Text(section)).toList(),
          ),
        );
      },
    );
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
                    "Edit Subject",
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

                      ReadOnlyTextFormField(
                        onTap: selectSection,
                        controller: _sectionController,
                        hintText: "Section",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateTextField(value, "Birth Date"),
                      ),

                      const SizedBox(height: 20),
                  

                      MyTextFormField(
                        controller: _subjectName,
                        hintText: "Subject Name",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Tite"),
                      ),
           
                      const SizedBox(height: 20),

                      MyTextFormField(
                        controller: _timeEndController,
                        hintText: "Time-Start",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Tite"),
                      ),
           
                      const SizedBox(height: 20),

                      MyTextFormField(
                        controller: _timeEndController,
                        hintText: "Time-End",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Tite"),
                      ),
           
                      const SizedBox(height: 20),

                          
                      MyButton(
                        onTap: () {
                          
                        },
                        buttonName: "Save",
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