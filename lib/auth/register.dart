import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_profs/auth/login.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:schedule_profs/main.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:schedule_profs/shared/text_field.dart';
import 'package:schedule_profs/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterScreen> {


  final _idNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  final registerFormKey = GlobalKey<FormState>();

  
  bool isStudentBonafide = false;

  // Function to validate student if bonafide or not based on the enrollment records
  // Queries the database using the student's provided credentials.
  // If it has a result, `isStudentBonafide` will be set to true.
  Future<void> validateProfessor() async{  

    try {
      final profToSearch = await 
        Supabase.instance.client
        .from('tbl_profs')
        .select()
        .eq('id_number', _idNumberController.text.trim().toUpperCase())
        .eq('first_name', _firstNameController.text.trim().toUpperCase())
        .eq('last_name', _lastNameController.text.trim().toUpperCase());
    
      if(profToSearch.isNotEmpty) {
        print("PROF FOUND");
        print("PROF TO SEARCH :::: $profToSearch");
        setState(() {
          isStudentBonafide = true;
        });

      } 
      else {
        print("NOT FOUND");
        print("PROF TO SEARCH :::: $profToSearch");
      } 
    } catch (e) {
      Alert.of(context).showError("$e");
    }
  }

  // FUNCTION TO CREATE A NEW ACCOUNT
  void  registerAccount () async{
    await validateProfessor();

    if(registerFormKey.currentState!.validate()) {

      if( isStudentBonafide ) {

        try{

          LoadingDialog.showLoading(context);
          await Future.delayed(const Duration(seconds: 2));

          final AuthResponse res = await supabase.auth.signUp(
            email: _emailController.text.trim(),
            password: _birthDateController.text.trim(),
          );

          final User? user = res.user; // get authenticated user data object 
          final String userId = user!.id;  // get user id

          print("NEW USER UIID::: $userId");
          boxUserCredentials.put("userId", userId);
          
          await createUser(
            _idNumberController.text.trim(),
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _birthDateController.text.trim(),
            _emailController.text.trim(), 
            userId
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherScreen())
          );


        } on AuthException catch(e) {
          LoadingDialog.hideLoading(context);
          Alert.of(context).showError(e.message);
          print("ERROR ::: ${e.code}");

        }

      } else {
          
        Alert.of(context).showError("User not found, please retry");

      }

    }

  }   

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

  DateTime birthDay = DateTime.now();
  selectDate() async{

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDay,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDay = picked;

      var formattedBirthDay = DateFormat('yyyy-MM-dd');
      _birthDateController.text = formattedBirthDay.format(birthDay);

      print('BIRTHDAYYYY ::::: ${formattedBirthDay.format(birthDay)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MAROON,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // TOP WHITE CONTAINER
            Container(

              color: MAROON,
              height: MediaQuery.of(context).size.height * 0.2, 

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,         
                children: [

                  SizedBox(height: 50),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        
                  SizedBox(height: 10),
                ],
              ),
            ),
        
            // BOTTOM WHITE CONTAINER
            Container(
              
              height: MediaQuery.of(context).size.height * 0.8, 
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
                        controller: _idNumberController,
                        hintText: "ID Number",
                        obscureText: false,
                        validator: (value) => Validator.of(context).validateWithRegex(
                          value, 
                          "ID number cannot found", 
                          "ID Number", 
                          RegExp(r'^A\d{2}-\d{4}$')
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                  
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextFormFieldForName(
                                controller: _firstNameController,
                                hintText: "First Name",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "First name"),
                              ),
                            ),
                  
                            const SizedBox(width: 5),
                  
                            Expanded(
                              child: MyTextFormFieldForName(
                                controller: _lastNameController,
                                hintText: "Last Name",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "Last name"),
                              ),
                            ),
                        
                        
                          ],
                        ),
                      ),    
                      const SizedBox(height: 20),
                  
                  
                      ReadOnlyTextFormField(
                        onTap: () => selectDate(),
                        controller: _birthDateController,
                        hintText: "Birthdate",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateTextField(value, "Birthdate"),
                      ),
                      const SizedBox(height: 20),
                      
                      MyTextFormField(
                        controller: _emailController,
                        hintText: "Email addres",
                        obscureText: false,
                        validator: Validator.of(context).validateEmail,
                      ),
                      const SizedBox(height: 20),
                      
                      MyTextFormField(
                        controller: _confirmEmailController,
                        hintText: "Confirm email address",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateConfirmation(value, _emailController.text, "Confirm Email")
                      ),
                      const SizedBox(height: 20),
                  
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text("Already have an account? "),

                          const SizedBox(width: 18),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen())
                              );
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                color: MAROON,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                        ],
                  
                      ),
                      const SizedBox(height: 25),
                          
                      MyButton(
                        onTap: () {
                          registerAccount();
                        },
                        buttonName: "Create",
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Your initial password is your birthdate\nin this format YYYY-MM-DD",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                     
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
