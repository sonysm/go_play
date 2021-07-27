import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/config/env.dart';
import 'package:path/path.dart';

class KSHttpClient {
  final String _baseUrl;
  final http.Client _httpClient;

  String? _token;

  KSHttpClient._(this._baseUrl, this._httpClient);

  static final KSHttpClient _instance =
      KSHttpClient._(DEBUG ? DEV_BASE : PRO_BASE, http.Client());

  factory KSHttpClient() {
    return _instance;
  }

  Map<String, String> _getHeader() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    };
  }

  void setToken(String token) {
    _token = token;
  }

  String token() {
    return _token != null ? _token! : '';
  }

  Uri _getUir(url, {Map<String, dynamic>? queryParameters}) {
    if (DEBUG) {
      return Uri.http(_baseUrl, '/api/v1$url', queryParameters);
    }
    return Uri.https(_baseUrl, '/api/v1$url', queryParameters);
  }

  Future postLogin(url, Object body) async {
    body = json.encode(body);
    var result;
    try {
      final response =
          await _httpClient.post(_getUir(url), body: body, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          int code = int.parse(json['code'].toString());
          if (code == 1) {
            result = json['data'];
          } else {
            result = HttpResult(code, json['message']);
          }
        } else {
          result = HttpResult(0, "Something went wrong!");
        }
      } else if (response.statusCode == 401) {
        result = HttpResult(401, "Unauthorized");
      }
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }
    return result;
  }

  Future getApi(url, {Map<String, dynamic>? queryParameters}) async {
    var result;
    try {
      final response = await _httpClient.get(
          _getUir(url, queryParameters: queryParameters),
          headers: _getHeader());
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          int code = int.parse(json['code'].toString());
          if (code == 1) {
            result = json['data'];
          } else {
            result = HttpResult(code, json['message']);
          }
        } else {
          result = HttpResult(0, "Something went wrong!");
        }
      } else if (response.statusCode == 401) {
        result = HttpResult(401, "Unauthorized");
      }
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }

    return result;
  }

  Future postApi(url, {Object? body}) async {
    if (body != null) {
      body = json.encode(body);
    }
    var result;
    try {
      final response = await _httpClient.post(_getUir(url),
          body: body, headers: _getHeader());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          int code = int.parse(json['code'].toString());
          if (code == 1) {
            result = json['data'];
          } else {
            result = HttpResult(code, json['message']);
          }
        } else {
          result = HttpResult(0, "Something went wrong!");
        }
      } else if (response.statusCode == 401) {
        result = HttpResult(401, "Unauthorized");
      }
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }
    return result;
  }

  Future postFileNoAuth(url, File? image,
      {Map<String, String>? fields, String imageKey = 'photo'}) async {
    var result;
    try {
      var request = http.MultipartRequest("POST", _getUir(url));

      if (fields != null) {
        //fields.removeWhere((key, value) => value == null);
        request.fields.addAll(fields);
      }
      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            imageKey,
            image.readAsBytesSync(),
            filename: basename(image.path),
          ),
        );
      }
      request.headers.addAll({
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      });

      request.send().then((stream) async {
        final response = await http.Response.fromStream(stream);
        if (response.statusCode == 200) {
          var json = jsonDecode(utf8.decode(response.bodyBytes));
          if (json != null) {
            int code = int.parse(json['code'].toString());
            if (code == 1) {
              result = json['data'];
            } else {
              result = HttpResult(code, json['message']);
            }
          } else {
            result = HttpResult(0, "Something went wrong!");
          }
        }
      });
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }

    return result;
  }

  /*Future<http.Response> postFile(url, File? image,
      {Map<String, String>? fields, String imageKey = 'photo'}) async {
    var request = http.MultipartRequest("POST", _getUir(url));
    if (fields != null) {
      fields.removeWhere((key, value) => value == null);
      request.fields.addAll(fields);
    }
    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          imageKey,
          image.readAsBytesSync(),
          filename: basename(image.path),
        ),
      );
    }
    request.headers.addAll(_getHeader());
    return request.send().then((stream) {
      return http.Response.fromStream(stream);
    });
  }*/

  Future postFile(url, http.MultipartFile? image,
      {Map<String, String>? fields, String imageKey = 'photo'}) async {
    var request = http.MultipartRequest("POST", _getUir(url));
    if (fields != null) {
      fields.removeWhere((key, value) => value == null);
      request.fields.addAll(fields);
    }
    if (image != null) {
      request.files.add(image);
    }
    request.headers.addAll(_getHeader());
    // return request.send().then((stream) {
    //   return http.Response.fromStream(stream);
    // });

    var result;
    try {
      final stream = await request.send();
      final response = await http.Response.fromStream(stream);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          int code = int.parse(json['code'].toString());
          if (code == 1) {
            result = json['data'];
          } else {
            result = HttpResult(code, json['message']);
          }
        } else {
          result = HttpResult(0, "Something went wrong!");
        }
      } else if (response.statusCode == 401) {
        result = HttpResult(401, "Unauthorized");
      }

      // request.send().asStream().listen((event) async {
      //   print('_____sending: ${event.stream}');
      //   final response = await http.Response.fromStream(event);
      //   if (response.statusCode == 200 || response.statusCode == 201) {
      //     final json = jsonDecode(utf8.decode(response.bodyBytes));
      //     if (json != null) {
      //       int code = int.parse(json['code'].toString());
      //       if (code == 1) {
      //         result = json['data'];
      //       } else {
      //         result = HttpResult(code, json['message']);
      //       }
      //     } else {
      //       result = HttpResult(0, "Something went wrong!");
      //     }
      //   } else if (response.statusCode == 401) {
      //     result = HttpResult(401, "Unauthorized");
      //   }
      // });

      /*http.Response.fromStream(stream).asStream().listen((event) {
        print('_____steam content len: ${event.contentLength}');
        print('_____steam body byte: ${event.bodyBytes}');
        // print('__gggg: ${event.}')
        if (event.statusCode == 200 || event.statusCode == 201) {
          final json = jsonDecode(utf8.decode(event.bodyBytes));
          if (json != null) {
            int code = int.parse(json['code'].toString());
            if (code == 1) {
              result = json['data'];
            } else {
              result = HttpResult(code, json['message']);
            }
          } else {
            result = HttpResult(0, "Something went wrong!");
          }
        } else if (event.statusCode == 401) {
          result = HttpResult(401, "Unauthorized");
        }
      });*/
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }
    return result;
  }

  Future postUploads(url, List<http.MultipartFile>? images,
      {Map<String, String>? fields}) async {
    var request = http.MultipartRequest("POST", _getUir(url));
    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (images != null) {
      request.files.addAll(images);
    }

    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
    });
    var result;
    try {
      final stream = await request.send();
      final response = await http.Response.fromStream(stream);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          int code = int.parse(json['code'].toString());
          if (code == 1) {
            result = json['data'];
          } else {
            result = HttpResult(code, json['message']);
          }
        } else {
          result = HttpResult(0, "Something went wrong!");
        }
      } else if (response.statusCode == 401) {
        result = HttpResult(401, "Unauthorized");
      }
    } on SocketException catch (e) {
      result = HttpResult(-500, "Internet connection");
      print("SocketException = $e");
    } on TimeoutException catch (e) {
      result = HttpResult(408, "Something went wrong!");
      print("TimeoutException = $e");
    } catch (e) {
      result = HttpResult(500, "Something went wrong!");
      print("Exception = $e");
    }
    return result;
  }
}
