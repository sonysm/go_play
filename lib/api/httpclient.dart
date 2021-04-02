import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
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

  Future getApi(url, {Map<String, dynamic>? queryParameters}) async{
      final response = await _httpClient.get(_getUir(url, queryParameters: queryParameters), headers: _getHeader());
  }

  Future postApi(url, {Object? body}) async{
     if (body != null){
        body = json.encode(body);
      }
      final response = await _httpClient.post(_getUir(url), body: body, headers: _getHeader());
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

      final stream = await request.send();

      final response =  await http.Response.fromStream(stream);

  }

}