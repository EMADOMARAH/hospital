import 'package:flutter/material.dart';





Widget DefaultFormField({
  @required TextEditingController controller,
  String label,
  TextInputType textInputType,
  bool isPassword = false,
  IconData suffix,
  IconData prefix,
  int maxLength,
  Function validate,
  Function onSubmit,
  Function onChanged,
  Function suffixPressed,
  String hint,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      validator: validate,
      onChanged: onChanged,
      maxLength: maxLength ,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        labelStyle: TextStyle(
          fontSize: 15,
        ),
        suffixIcon: suffix!= null ? IconButton(
          onPressed: suffixPressed ,
          icon: Icon(
            suffix,
          ),
        ) : null,
        prefixIcon: prefix !=null ? Icon(
          prefix,
        ) : null,
        border: InputBorder.none,
      ),
    );


void navigateTo(BuildContext context , Widget screen)
{
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateReplacement(BuildContext context , Widget screen){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen));
}