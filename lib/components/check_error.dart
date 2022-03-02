import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';

class CheckError {
  static bool checkBasicErrors(BuildContext context, List<String> fields) {
    bool hasError = false;
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].isEmpty) {
        showToast(context, "Lütfen boş alanları doldurunuz", Colors.red);
        hasError = true;
        break;
      }
    }
    if (fields[1].length < 6 && !hasError) {
      showToast(
          context, "Lütfen şifreniz minimum 6 karakter içersin", Colors.red);
      hasError = true;
    }
    return hasError;
  }

  static void checkErrors(Object e, BuildContext context) {
    if (e.toString().contains(
        "The password is invalid or the user does not have a password.")) {
      showToast(
          context,
          "Parolanız geçersiz veya hatalı. Lütfen kontrol edip tekrar deneyiniz.",
          Colors.red);
    } else if (e.toString().contains("The email address is badly formatted.")) {
      showToast(context, "E mailinizi uygun formatta girip tekrar deneyiniz.",
          Colors.red);
    } else if (e.toString().contains(
        "There is no user record corresponding to this identifier. The user may have been deleted.")) {
      showToast(
          context,
          "Böyle bir kullanıcı bulunamadı. Bilgilerinizi kontrol edip tekrar deneyiniz...",
          Colors.red);
    }
  }
}
