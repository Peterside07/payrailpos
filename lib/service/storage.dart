import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences prefs;

  Future _initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future saveExchange() async {
    await _initPref();
    prefs.setBool('exchange', true);
  }


  static const String _sessionKey = 'sessionKey';
  static const String _masterKey = 'masterKey';
  static const String _tmasterKey = 'tmasterKey';
  static const String _pinKy = 'pinKey';

  Future<void> saveSessionKey(String sessionKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, sessionKey);
  }

  Future<void> saveMasterKey(String masterKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_masterKey, masterKey);
  }

  Future<void> saveTMasterKey(String tmasterKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tmasterKey, tmasterKey);
  }

  Future<void> savePinKy(String pinKy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKy, pinKy);
  }

  Future<String> getSessionKey() async {
    await _initPref();
    return prefs.getString(_sessionKey) ?? '';
  }
  Future<String> getMasterKey() async {
    await _initPref(); 
    return prefs.getString(_masterKey) ?? '';
  }
  Future<String> getTMasterKey() async {
    await _initPref();
    return prefs.getString(_tmasterKey) ?? '';
  }
  Future<String> getPinKy() async {
    await _initPref();
    return prefs.getString(_pinKy) ?? '';
  }

  Future<bool> getExchange() async {
    await _initPref();
    return prefs.getBool('exchange') ?? false;
  }

  Future saveToken(String token) async {
    await _initPref();
    await prefs.setString('@token', token);
  }

  Future<String> getToken() async {
    await _initPref();
    return prefs.getString('@token') ?? '';
  }

  Future removeToken() async {
    await _initPref();
    prefs.remove('@token');
  }

  Future saveViewedWalkthrough() async {
    await _initPref();
    await prefs.setBool('walkedThrough', true);
  }

  Future<bool> getViewedWalkthrough() async {
    await _initPref();
    return prefs.getBool('walkedThrough') ?? false;
  }

  Future savePhone(String phone) async {
    await _initPref();
    prefs.setString('phone', phone);
  }

  Future<String> getPhone() async {
    await _initPref();
    return prefs.getString('phone') ?? '';
  }

  Future saveLanguage(String val) async {
    await _initPref();
    await prefs.setString('lang', val);
  }

  Future<String> getLanguage() async {
    await _initPref();
    var lang = prefs.getString('lang');
    return lang ?? 'en';
  }

  Future saveRememberMe(bool val) async {
    await _initPref();
    prefs.setBool('rememberMe', val);
  }

  Future<bool> getRememberMe() async {
    await _initPref();
    return prefs.getBool('rememberMe') ?? false;
  }

  Future saveCurrentTheme(String val) async {
    await _initPref();
    prefs.setString('theme', val);
  }

  Future<String> getCurrentTheme() async {
    await _initPref();
    return prefs.getString('theme') ?? 'System';
  }

  Future saveAppLanguage(String val) async {
    await _initPref();
    prefs.setString('language', val);
  }

  Future<String> getAppLanguage() async {
    await _initPref();
    return prefs.getString('language') ?? 'EN';
  }
}
