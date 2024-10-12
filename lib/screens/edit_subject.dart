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

class EditSubjectScreen extends StatefulWidget {
  const EditSubjectScreen({
    super.key,
    required this.schedId, 
    required this.section,
    required this.subjectName, 
    required this.day,
    required this.startTime, 
    required this.endTime,
    this.profName, 
  });


  final int schedId;
  final String section;
  final String subjectName;
  final String day;
  final String startTime;
  final String endTime;
  final String? profName;

  @override
  State<EditSubjectScreen> createState() => _EditSubjectStateScreen();
}

class _EditSubjectStateScreen extends State<EditSubjectScreen> {
  
  @override
  void initState() {
    super.initState();
    getAllAvailableSections();
    fillOutForm(
      widget.section,
      widget.subjectName,
      widget.day,
      widget.startTime, 
      widget.endTime
    );
  }

  final _sectionController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeStartController = TextEditingController();
  final _timeEndController = TextEditingController();

  final editSubjectFormKey = GlobalKey<FormState>();

 

  // ANCHOR - EDIT SUBJECT FUNCTION
  void editSubject(int scheduleId, String section, String subjectName, String day, String timeStart, String timeEnd) async {

    if(editSubjectFormKey.currentState!.validate()) {
      try {
        await Supabase.instance.client
        .from('tbl_schedule')
        .update({
          'section' : section,
          'subject' : subjectName,
          'day_of_week' : day,
          'start_time' : timeStart,
          'end_time' : timeEnd,
        })
        .eq("schedule_id", scheduleId);

        print("PROFF NAME :::: ${boxUserCredentials.get("profName")}");
        print("SCHEDULE UPDATED SUCCESSFULLY");
        
        Alert.of(context).showSuccess("Schedule updated successfully🥰🥰🥰");
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

  // ANCHOR - SELECT DAY FUNCTION
  final List<String> _dayOfWeek = [ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday' ];
  Future<void> selectDay() async {
    // Show the Cupertino modal popup
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            itemExtent: 30,
            backgroundColor: Colors.white,
            onSelectedItemChanged: (int value) {
              
              setState(() {
                _dayController.text = _dayOfWeek[value];
              });

              print('SECTION :::: ${_dayOfWeek[value]}'); 
            },
            
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: _dayOfWeek.map((day) => Text(day)).toList(),
          ),
        );
      },
    );
  }

  void fillOutForm(String section, String subjectName, String day, String timeStart, String timEnd) {

    _sectionController.text = section;
    _subjectNameController.text = subjectName;
    _dayController.text = day;
    _timeStartController.text = timeStart;
    _timeEndController.text = timEnd;

    print("START-TIME :::: ${widget.startTime}");
    print("END-TIME   :::: ${widget.endTime}");

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
                key: editSubjectFormKey,
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
                        controller: _subjectNameController,
                        hintText: "Subject Name",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Tite"),
                      ),
           
                      const SizedBox(height: 20),

                      ReadOnlyTextFormField(
                        onTap: selectDay,
                        controller: _dayController,
                        hintText: "Day",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Day"),
                      ),

                      const SizedBox(height: 20),

                      MyTextFormField(
                        controller: _timeStartController,
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
                        onTap: () async{
                          editSubject(
                            widget.schedId,
                            _sectionController.text,
                            _subjectNameController.text,
                            _dayController.text,
                            _timeStartController.text,
                            _timeEndController.text
                          );
                        },
                        buttonName: "Update",
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