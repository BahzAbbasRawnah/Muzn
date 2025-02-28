import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../app/core/secure_storage.dart';

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();

  static const String baseUrl  = 'http://192.168.1.102:8000/api/';


  final storage = SecureStorage();

  factory ApiProvider() {
    return _instance;
  }
  ApiProvider._internal();
  String authToken = '';

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    authToken = await storage.read(key: 'token') ?? "";
    print('auth token is $authToken');

    final response = await http.post(
      Uri.parse(baseUrl + path),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',


        // "X-SHOP-ID":"$shopId2",
        // "X-ORDER-TYPE":"$orderType",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> get(String path) async {
    authToken = await storage.read(key: 'token') ?? "";

    print('auth token is $authToken');
    // var shopId2 = storage.read(key: "shopId") ?? "";
    // var orderType = await storage.read(key: "orderType") ?? "";

    final response = await http.get(
      Uri.parse(baseUrl + path),
      headers: {
        'Authorization': 'Bearer $authToken',
        // 'X-Tenant': '3d52eb2f-e5e9-4da0-ad47-561361419f0d',

        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'lang': 'ar',
      },
      // 'X-SHOP-ID':'$shopId2',
    );
    return response;
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    authToken = await storage.read(key: 'token') ?? "";
    var shopId2 = await storage.read(key: "shopId") ?? "";

    final response = await http.put(
      Uri.parse(baseUrl + path),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'lang': 'ar',

        // "X-SHOP-ID":"$shopId2",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> patch(String path, Map<String, dynamic> body) async {
    authToken = await storage.read(key:'token') ?? "";
    var shopId2 = await storage.read(key: "shopId") ?? "";
    final response = await http.patch(
      Uri.parse(baseUrl + path),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',

        'lang': 'ar',
        // "X-SHOP-ID":"$shopId2",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> postWithFiles({
    required String path,
    required Map<String, String> body,
    required File file,
    required String FileName,
    File? file2,
    String? FileName2,
    File? file3,
    String? FileName3,
  }) async {
    authToken = await storage.read(key: 'token') ?? "";
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + path));
    request.headers['Authorization'] = 'Bearer $authToken';
    request.fields.addAll(body);
    request.files.add(await http.MultipartFile.fromPath(FileName, file.path));
    // if(FileName2!=null&&file2==null){
    //   print('on fil999999999999999999999999999999999999999999999999999e 2');
    //   print(FileName2);
    //   print(FileName2?.length);
    request.files.add(
        await http.MultipartFile.fromPath(FileName2 ?? "", file2?.path ?? ""));
    request.files.add(
        await http.MultipartFile.fromPath(FileName3 ?? "", file3?.path ?? ""));
    // }
    var response = await request.send();
    // print(response.headers.toString());
    // print(response.contentLength);
    return http.Response.fromStream(response);
  }

  Future<http.Response> postWithFile({
    required String path,
    required Map<String, String> body,
    required File? file,
    required String FileName,
  }) async {
    authToken = await storage.read(key: 'token') ?? "";
    // var shopId2 = await storage.read(key: "shopId") ?? "";
    // var orderType = await storage.read(key: "orderType") ?? "";

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + path));
    request.headers['Authorization'] = 'Bearer $authToken';
    // request.headers['X-SHOP-ID'] = shopId2;
    // request.headers['X-ORDER-TYPE'] = orderType;

    // "X-SHOP-ID":"$shopId2",
    // print('order types in post with files 9898666666666666666666666666666 $orderType');
    request.fields.addAll(body);
    if (file?.path.isNotEmpty ?? false) {
      request.files
          .add(await http.MultipartFile.fromPath(FileName, file?.path ?? ""));
    }
    // if(FileName2!=null&&file2==null){
    //   print('on fil999999999999999999999999999999999999999999999999999e 2');
    //   print(FileName);
    //   print(file?.path??"");
    // print(FileName?.length);
    // request.files.add(await http.MultipartFile.fromPath(FileName2??"", file2?.path??""));
    // request.files.add(await http.MultipartFile.fromPath(FileName3??"", file3?.path??""));
    // }
    var response = await request.send();
    // print(response.headers.toString());
    // print(response.contentLength);
    return http.Response.fromStream(response);
  }

  Future<http.Response> delete(String path) async {
    authToken = await storage.read(key: 'token') ?? "";
    final response = await http.delete(
      Uri.parse(baseUrl + path),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',

        'lang': 'ar',
      },
    );
    return response;
  }

  void updateAuthToken(String token) {
    authToken = token;
  }
}
