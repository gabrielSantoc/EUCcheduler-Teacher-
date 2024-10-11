
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/model/section_model.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  
  @override
  void initState() {
    super.initState();
    getAllAvailableSections();
  }

  final _sectionController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeStartController = TextEditingController();
  final _timeEndController = TextEditingController();

  final addSubjectFormKey = GlobalKey<FormState>();


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

  // ANCHOR - SELECT SECTION FUNCTION
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

  // ANCHOR - SELECT TIME FUNCTION
  String formattedTimeStart = "";
  String formattedTimeEnd = "";
  Future<void> selectTime(TextEditingController controller, String whichTime) async{
    final TimeOfDay? timePicked = await  showTimePicker(
      context: context,
      initialTime:  TimeOfDay.now(),
    );

    if(timePicked != null) {
      var now = DateTime.now();
      var formattedTime = DateFormat('HH:mm:ss').format(
        DateTime(
          now.year,
          now.month, 
          now.day, 
          timePicked.hour, 
          timePicked.minute
        )
      );
      
      if(whichTime == "start") {
        setState(() {
          formattedTimeStart = formattedTime;
        });
      }
      if (whichTime == "end") {
        setState(() {
          formattedTimeEnd = formattedTime;
        });
      }
      print("TIME SELECTED :::: $formattedTime");

      var twelveHoursFormat = DateFormat('hh:mm a').format(
        DateTime(
          now.year,
          now.month, 
          now.day, 
          timePicked.hour, 
          timePicked.minute
        )
      );
      // controller.text = formattedTime;
      print("12 HOURS FORMAT :::: $twelveHoursFormat");
      controller.text = twelveHoursFormat;
    }
    
  }
  
  // ANCHOR - ADD SUBJECT FUNCTION
  void addSubject(String section, String subjectName, String day, String timeStart, String timeEnd) async {

    if(addSubjectFormKey.currentState!.validate()) {
      try {
        await Supabase.instance.client
        .from('tbl_schedule')
        .insert({
          'professor_name': boxUserCredentials.get("profName"),
          'subject' : subjectName,
          'section' : section,
          'start_time' : timeStart,
          'end_time' : timeEnd,
          'day_of_week' : day,
        });

        print("PROFF NAME :::: ${boxUserCredentials.get("profName")}");
        print("SCHEDULE ADDED SUCCESSFULLY");
        
        Alert.of(context).showSuccess("SCHEDULE ADDED SUCCESSFULLY🥰🥰🥰");
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
                    "Add Subject",
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
                key: addSubjectFormKey,
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
                        validator: (value)=> Validator.of(context).validateTextField(value, "Section"),
                      ),

                      const SizedBox(height: 20),
                  

                      MyTextFormField(
                        controller: _subjectNameController,
                        hintText: "Subject Name",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Subject Name"),
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

                      ReadOnlyTextFormField(
                        onTap: () {
                          selectTime(_timeStartController, "start");
                        },
                        controller: _timeStartController,
                        hintText: "Time-Start",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Time-Start"),
                      ),
           
                      const SizedBox(height: 20),

                      ReadOnlyTextFormField(
                        onTap: () {
                          selectTime(_timeEndController, "end");
                        },
                        controller: _timeEndController,
                        hintText: "Time-End",
                        obscureText: false,
                        validator:  (value)=> Validator.of(context).validateTextField(value, "Time-end"),
                      ),
           
                      const SizedBox(height: 20),

                          
                      MyButton(
                        onTap: () async{
                          print("FORMATTED TIME START :::: $formattedTimeStart");
                          print("FORMATTED TIME END :::: $formattedTimeEnd");
                          addSubject(
                            _sectionController.text.toString().trim(),
                            _subjectNameController.text.toString().trim(),
                            _dayController.text.toString().trim(),
                            formattedTimeStart,
                            formattedTimeEnd
                          );
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