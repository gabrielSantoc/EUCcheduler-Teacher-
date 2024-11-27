import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.suffixIcon,
    this.validator,
    this.maxLines
  });

  final controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: maxLines,
        decoration: InputDecoration(  
          suffixIcon: suffixIcon,
          errorStyle: const TextStyle(
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.green)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[500]
          ),
        ),
      ),
    );
  }
}


class MyTextFormFieldForName extends StatelessWidget {
  const MyTextFormFieldForName({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator
  });

  final controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.green)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[500]
          ),
        ),
      ),
    );
  }
}


class ReadOnlyTextFormField extends StatelessWidget {
  const ReadOnlyTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onTap,
    this.validator
  });

  final void Function()? onTap;
  final controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
      
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        readOnly: true,
        onTap: onTap,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 11
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.green)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[500]
          ),
        ),
      ),
    );
  }
}


class MyTextFormFieldPasword extends StatelessWidget {
  const MyTextFormFieldPasword({
    super.key, 
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.suffixIcon,
    required this.validator
  });

  final controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 11
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green)
          ),errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red)
          ),

          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey[500]
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class MyTextFormFieldShortReadOnly extends StatelessWidget {
  const MyTextFormFieldShortReadOnly({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator, this.onTap
  });

  final controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        readOnly: true,
        onTap: onTap,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.green)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: Colors.grey.shade500)
            borderSide: const BorderSide(color: Colors.red)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[500]
          ),
        ),
      ),
    );
  }
}