import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/config/env.dart';

class HttpClient{

  final String _baseUrl;
  final http.Client _httpClient;

  Map<String, String>? _header;

  String? _token;

  HttpClient._(this._baseUrl, this._httpClient);

  static final HttpClient _instance = HttpClient._(DEBUG ? DEV_BASE : PRO_BASE, http.Client());

  factory HttpClient() {
    return _instance;
  }

  Map<String, String> _getHeader(){
    if(_header != null){
      return _header!;
    }
    _header = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_token',
    };
    return _header!;
  }

  void setToken(String token){
      _token = token;
  }

  Uri _getUir(url, {Map<String, dynamic>? queryParameters}){
     if(DEBUG){
        return Uri.http(_baseUrl, '/api/v1$url', queryParameters);
     }
      return Uri.https(_baseUrl, '/api/v1$url', queryParameters);
  }

  Future postLogin(url, Object body) async{
      body = json.encode(body);
      var result;
      try{
        final response = await _httpClient.post(_getUir(url), body: body, headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
        });
        if (response.statusCode == 200 || response.statusCode == 201){
          final json = jsonDecode(response.body);
          if(json != null){
            int code = int.parse(json['code'].toString());
              if(code == 1){
                  result = json['data'];
              }else{
                    result = HttpResult(code, json['sms']);
              }
          }else{
              result = HttpResult(0, "Something went wrong!");
          }
        }else if(response.statusCode == 401){
            result = HttpResult(401, "Unauthorized");
        }
      } 
      on SocketException catch(e){
          result = HttpResult(-500, "Internet connection");
          print("SocketException = $e"); 
      } 
      on TimeoutException catch(e){
          result = HttpResult(408, "Something went wrong!");
          print("TimeoutException = $e"); 
      }
      catch(e){
          result = HttpResult(500, "Something went wrong!");  
          print("Exception = $e");
      }
      return result;
  }


  Future getApi(url, {Map<String, dynamic>? queryParameters}) async{
    var result;
    try{
      final response = await _httpClient.get(_getUir(url, queryParameters: queryParameters), headers: _getHeader());
      if(response.statusCode == 200){
          final json = jsonDecode(response.body);
          if(json != null){
              int code = int.parse(json['code'].toString());
              if(code == 1){
                  result = json['data'];
              }else{
                  result = HttpResult(code, json['sms']);
              }
          }else{
              result = HttpResult(0, "Something went wrong!");
          }
      }else if (response.statusCode == 401){
          result = HttpResult(401, "Unauthorized");
      }
    }
    on SocketException catch(e){
        result = HttpResult(-500, "Internet connection");
        print("SocketException = $e"); 
    }
    on TimeoutException catch(e){
          result = HttpResult(408, "Something went wrong!");
          print("TimeoutException = $e"); 
    }
    catch(e){
        result = HttpResult(500, "Something went wrong!");  
        print("Exception = $e");
    }

    return result;
  }

  Future postApi(url, {Object? body}) async{
     if (body != null){
        body = json.encode(body);
      }
      var result;
      try{
          final response = await _httpClient.post(_getUir(url), body: body, headers: _getHeader());
          if(response.statusCode == 200 || response.statusCode == 201){
              final json = jsonDecode(response.body);
              if(json != null){
                  int code = int.parse(json['code'].toString());
                  if(code == 1){
                      result = json['data'];
                  }else{
                      result = HttpResult(code, json['sms']);
                  }
              }else{
                  result = HttpResult(0, "Something went wrong!");
              }
          }
          else if (response.statusCode == 401){
              result = HttpResult(401, "Unauthorized");
          }
      }
      on SocketException catch(e){
        result = HttpResult(-500, "Internet connection");
        print("SocketException = $e");
      }
      on TimeoutException catch(e){
          result = HttpResult(408, "Something went wrong!");
          print("TimeoutException = $e"); 
      }
      catch(e){
         result = HttpResult(500, "Something went wrong!");  
         print("Exception = $e");
      }
      return result;
  }

  Future postUploads(url, List<http.MultipartFile> images, {Map<String, String>? fields}) async {
     var request = http.MultipartRequest("POST", _getUir(url));
      if(fields != null){
          request.fields.addAll(fields);
      }
      request.files.addAll(images);

      request.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      });
      var result;
      try{
          final stream = await request.send();
          final response =  await http.Response.fromStream(stream);
          if(response.statusCode == 200 || response.statusCode == 201){
                final json = jsonDecode(response.body);
                if(json != null){
                    int code = int.parse(json['code'].toString());
                    if(code == 1){
                        result = json['data'];
                    }else{
                        result = HttpResult(code, json['sms']);
                    }
                }else{
                    result = HttpResult(0, "Something went wrong!");
                }
          }else if(response.statusCode == 401){
              result = HttpResult(401, "Unauthorized");
          }
      }
      on SocketException catch(e){
        result = HttpResult(-500, "Internet connection");
        print("SocketException = $e");
      }
      on TimeoutException catch(e){
          result = HttpResult(408, "Something went wrong!");
          print("TimeoutException = $e"); 
      }
      catch(e){
          result = HttpResult(500, "Something went wrong!");  
          print("Exception = $e");
         
      }
      return result;
  }
}