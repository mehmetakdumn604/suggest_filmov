import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:suggest_filmov/const.dart';

enum Requests { get, post, put, delete, update }

String authority = "api.themoviedb.org";

class BaseService {
  final client = http.Client();
  late http.Response response;
  final _timeOutDuration = 30;


  late Map<String, String> queryParma;

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
    HttpHeaders.authorizationHeader:
        "Bearer $READACCESSTOKEN"
  };

// headers
  Map<String, String> setHeaders({Map<String, String>? header}) {
    headers.addAll(header ?? {});
    return headers;
  }

// query parameters

  Map<String, String> setQueryParameters({Map<String, String>? query}) {
    queryParma = {"api_key": APIKEY};
    queryParma.addAll(query ?? {});

    return queryParma;
  }

// response
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;

      case 400:
        throw Exception(jsonDecode(jsonEncode(response.body)));
      // return response;

      case 401:
      case 403:
        // throw UnauthorizedException(jsonDecode(jsonEncode(response.body)));
        return response;

      case 500:
      default:
        throw Exception(
            'Error occured while Communicating with Server with StatusCode: ${response.statusCode}\nRESPONSE:${decodeResponse(response)}');
      // return response;
    }
  }

  Future<http.Response> request({
    required Requests method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameter,
    Map<String, String>? header,
  }) async {
    // setQueryParameters();
    switch (method) {
      case Requests.get:
        response = await client
            .get(
              Uri.https(
                  authority, path, queryParameter ?? setQueryParameters()),
              headers: header ?? headers,
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;
      case Requests.post:
        response = await client
            .post(
              Uri.https(
                  authority, path, queryParameter ?? setQueryParameters()),
              headers: header ?? headers,
              body: jsonEncode(body ?? {}),
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;
      case Requests.delete:
        response = await client
            .delete(
              Uri.https(
                  authority, path, queryParameter ?? setQueryParameters()),
              headers: header ?? headers,
              body: jsonEncode(body ?? {}),
            )
            .timeout(Duration(seconds: _timeOutDuration));
        break;

      default:
        break;
    }

    // if (response.statusCode == 401 || response.statusCode == 403) {
    //   Auth().logout();
    //   // Get.offAll(page);

    //   return returnResponse(response);
    // }
    return returnResponse(response);
  }

  //decodes response from string to json object
  dynamic decodeResponse(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
