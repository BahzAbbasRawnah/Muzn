
import 'secure_storage.dart';

Future<bool> checkIfLogin() async {
  final storage = SecureStorage();
  String? val =  await storage.read(key: 'isLogin');
  print('val is Login');
  print(val);
  if (val != null && val.isNotEmpty) {
    if (val.startsWith('true')) {
      return true;
    }
    return false;
  } else {
    return false;
  }
}
