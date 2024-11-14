import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.hintText,
      required this.prefixIcon,
      this.onTap});
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final Widget prefixIcon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "field must not be empty ";
        } else {
          return null;
        }
      },
      onTap: onTap,
      decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 18),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          hintText: hintText,
          prefixIcon: prefixIcon),
    );
  }
}
