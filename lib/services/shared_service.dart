import 'package:shared_preferences/shared_preferences.dart';
import 'package:suggest_filmov/const.dart';

class SharedService {
  static final SharedService instance = SharedService._init();
  static SharedPreferences? _sp;
  SharedService._init();

  Future<SharedPreferences> get sp async {
    if (_sp != null) {
      return _sp!;
    }
    _sp = await _initSp();
    return _sp!;
  }

  static Future<SharedPreferences> _initSp() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setData(String key, int value, String dateKey) async {
    SharedPreferences sp = await instance.sp;
    DateTime today = DateTime.now();
    String date = "${today.day}/${today.month}/${today.year}";
    if ((sp.getString(dateKey) ?? "") != date) {
      sp.setString(dateKey, date);
      sp.setInt(key, value);
      print("girdi");
    }
  }

  static Future<int> getData(String key) async {
    SharedPreferences sp = await instance.sp;
    return sp.getInt(key) ?? 1;
  }
}
