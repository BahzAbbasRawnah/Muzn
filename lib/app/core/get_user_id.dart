import 'secure_storage.dart';

Future<int> getUserId() async {
  final storage = SecureStorage();
  String? val = await storage.read(key: 'user_id');
  print('val user id ');
  print(val);
  // Check if the value is not null and not empty
  if (val != null && val.isNotEmpty) {
    // Remove any prefix (e.g., "yes") if necessary
    // if (val.startsWith('yes')) {
    // val = val.substring(3); // Remove the first 3 characters ("yes")
    // }

    // Try to parse the value to an integer
    try {
      int userId = int.parse(val);
      return userId; // Return the parsed integer
    } catch (e) {
      throw Exception(
          'Invalid user ID format: $val'); // Throw an exception if parsing fails
    }
  } else {
    throw Exception(
        'User ID not found in storage'); // Throw an exception if the value is null or empty
  }
}

Future<String> getUserName() async {
  final storage = SecureStorage();
  String? val = await storage.read(key: 'user_name');

  // Check if the value is not null and not empty
  if (val != null && val.isNotEmpty) {
    // Remove any prefix (e.g., "yes") if necessary
    // if (val.startsWith('yes')) {
    //   val = val.substring(3); // Remove the first 3 characters ("yes")
    // }
    return val;
    // Try to parse the value to an integer
    // try {
    //   int userId = int.parse(val);
    //   return userId; // Return the parsed integer
    // } catch (e) {
    //   throw Exception('Invalid user ID format: $val'); // Throw an exception if parsing fails
    // }
  } else {
    throw Exception(
        'User ID not found in storage'); // Throw an exception if the value is null or empty
  }
}
