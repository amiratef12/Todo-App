import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.keyboardType,
      this.onTap,
      required this.hintText,
      required this.prefixIcon});
  final TextEditingController controller;
  final TextInputType keyboardType;
  final void Function()? onTap;
  final String hintText;
  final Widget prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onTap: onTap ?? () {},
      validator: (value) {
        if (value!.isEmpty) {
          return 'field must not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
