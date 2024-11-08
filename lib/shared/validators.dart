import 'package:flutter/material.dart';
class Validator {
  BuildContext context;
  Validator.of(this.context);

  // VALIDATE REQUIRED FIELD
  String? validateRequiredField(String? value, String? fieldName) {
    if(value.toString().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  // VALIDATE NORMAL TEXT FIELD 
  String? validateTextField(String? value, String fieldName) {
    if(value.toString().isEmpty || value == null ) {
      return '${fieldName} cannot be empty';
    }
    if(value.toString().length <= 1) {
      return '${fieldName} must be more than one character';
    }
    return null;
  }

  // EMAIL
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if( email.toString().isEmpty) {
      return 'Email cannot be empty';
    }
    if(!isEmailValid) {
      return 'Please enter a valid email';
    } 
    return null;
  }

  // Validate Confirmation
  String? validateConfirmation(String? value, String? originalValue, String fieldName) {
    if(value.toString().isEmpty) {
      return '$fieldName cannot be empty';
    }
    if(value != originalValue) {
      return '$fieldName does not match';
    }
    return null;
  }

  // VALIDATE REGEX VALIDATION
  String? validateWithRegex(String? value, String errorMessage, String? fieldName, RegExp regex) {
    if(value.toString().isEmpty) {
      return '$fieldName cannot be empty';
    }
    if(value == null || !regex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

}