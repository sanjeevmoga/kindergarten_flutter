import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:kindergarten/core/base/NetException.dart';
import 'package:kindergarten/repository/UserModel.dart';

class RequestClient {
  static Future request(String url,
      [Map<String, String> queryParameters]) async {
    var host = Platform.isAndroid ? '192.168.31.150:8080' : '127.0.0.1:8080';
    var httpClient = new HttpClient();
    var requestUrl = new Uri.http(host, url, queryParameters);
    UserModel onlineUser = UserProvide.getCacheUser();
    var response =
        await httpClient.postUrl(requestUrl).then((HttpClientRequest request) {
      request.headers.add('os', Platform.operatingSystem);
      if (onlineUser != null) {
        request.headers.add('token', onlineUser.token);
      }
      print(request.headers);
      return request.close();
    });
    if (response.statusCode == HttpStatus.OK) {
      var jsonData = await response.transform(UTF8.decoder).join();
      var data = json.decode(jsonData);
      print(requestUrl);
      print(jsonData);
      if (data['code'].toString() == '1003') {
        UserProvide.loginOut();
        return new Future.value(data["data"]);
      } else if (data['code'].toString() != '200') {
//        ScaffoldState.showSnackBar(new SnackBar(content: new Text(data['msg'])));
        throw new NetException(data['code'], data['msg']);
      } else {
        return new Future.value(data["data"]);
      }
    } else {
      throw 'Error getting IP address:\nHttp status ${response.statusCode}';
    }
  }
}
