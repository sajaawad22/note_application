import 'package:flutter/material.dart';

final List<String> noteDescription = [];
final List<String> noteHeading = [];
TextEditingController noteHeadingController = new TextEditingController();
TextEditingController noteDescriptionController = new TextEditingController();
FocusNode textSecondFocusNode = new FocusNode();

int notesHeaderMaxLenth = 25;
int notesDescriptionMaxLines = 10;
int notesDescriptionMaxLenth= 300;
String deletedNoteHeading = "";
String deletedNoteDescription = "";


List<Color> noteColor = [
  
    Color(0xffffffff),
    Color(0xfff28b81), // light pink
    Color(0xfff7bd02), // yellow
    Color(0xfffbf476), // light yellow
    Color(0xffcdff90), // light green
    Color(0xffa7feeb), // turquoise
    Color(0xffcbf0f8), // light cyan
    Color(0xffafcbfa), // light blue
    Color(0xffd7aefc), // plum
    Color(0xfffbcfe9), // misty rose
    Color(0xffe6c9a9), // light brown
    Color(0xffe9eaee)
  
];
List<Color> noteMarginColor= [
    Color(0xffffffff), // classic white
    Color(0xfff28b81), // light pink
    Color(0xfff7bd02), // yellow
    Color(0xfffbf476), // light yellow
    Color(0xffcdff90), // light green
    Color(0xffa7feeb), // turquoise
    Color(0xffcbf0f8), // light cyan
    Color(0xffafcbfa), // light blue
    Color(0xffd7aefc), // plum
    Color(0xfffbcfe9), // misty rose
    Color(0xffe6c9a9), // light brown
    Color(0xffe9eaee)
];