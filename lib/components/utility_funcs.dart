import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/services/api_service.dart';

APIService apiService = APIService();

Size getSize(BuildContext context) => MediaQuery.of(context).size;

//search textfieldı
OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(
    color: Colors.white,
  ),
);

//textstyles
TextStyle textStyle = GoogleFonts.inter(color: Colors.white, fontSize: 18);

//custom loading
Widget customLoading = Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Color.fromARGB(255, 66, 63, 63),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(whiteColor)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Loading",
          style: textStyle,
        ),
      ),
    ],
  ),
);
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
  BuildContext context,
  String msg,
  Color bgColor,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        style: textStyle.copyWith(fontSize: 16),
      ),
      backgroundColor: bgColor,
      duration: Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      width: getSize(context).width * .7,
    ),
  );
}
