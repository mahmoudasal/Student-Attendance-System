import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyValueError;
  final String validationError;
  final RegExp regex;

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.emptyValueError,
    required this.validationError,
    required this.regex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive width calculation
    double textFieldWidth;
    if (screenWidth > 992) {
      // Desktop: use current size
      textFieldWidth = 750;
    } else if (screenWidth > 576) {
      // Tablet: 80% of screen width
      textFieldWidth = screenWidth * 0.8;
    } else {
      // Mobile: 90% of screen width
      textFieldWidth = screenWidth * 0.9;
    }
    
    return SizedBox(
      height: 70,
      width: textFieldWidth,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        validator: (currentValue) {
          var nonNullValue = currentValue ?? "";
          if (nonNullValue.isEmpty) {
            return emptyValueError;
          } else if (!regex.hasMatch(nonNullValue)) {
            return validationError;
          }
          return null;
        },
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String selectedChoice;

  CustomDropdown({
    required this.items,
    required this.selectedChoice,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState(selectedChoice);
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedChoice;

  _CustomDropdownState(this.selectedChoice);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive width calculation
    double dropdownWidth;
    if (screenWidth > 992) {
      // Desktop: use current size
      dropdownWidth = 550;
    } else if (screenWidth > 576) {
      // Tablet: 70% of screen width
      dropdownWidth = screenWidth * 0.7;
    } else {
      // Mobile: 85% of screen width
      dropdownWidth = screenWidth * 0.85;
    }
    
    return SizedBox(
        height: 70,
        width: dropdownWidth,
        child: InputDecorator(
          decoration: InputDecoration(

              // contentPadding: EdgeInsets.all(10),
              ),
          child: Theme(
            // <- Here
            data: Theme.of(context).copyWith(
              // <- Here
              splashColor: Colors.transparent, // <- Here
              highlightColor: Colors.transparent, // <- Here
              hoverColor: Colors.transparent, // <- Here
            ),
            child: DropdownButtonFormField<String>(
              focusColor: Colors.white,
              autofocus: true,
              value: selectedChoice,
              onChanged: (String? newValue) {
                setState(() {
                  selectedChoice = newValue!;
                });
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
