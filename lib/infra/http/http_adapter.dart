import 'package:app/infra/http/errors/errors.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({required String url, required String method, Map? body, Map? headers}) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    Future<Response>? futureResponse;
    try {
      if (method == 'post') {
        futureResponse = client.post(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      } else if (method == 'get') {
        futureResponse = client.get(Uri.parse(url), headers: defaultHeaders);
      } else if (method == 'put') {
        futureResponse = client.put(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      } else if (method == 'delete') {
        futureResponse = client.delete(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
      }
      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 10));
      }
    } catch (error) {
      throw ServerError(error.toString());
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return body;
      case 204:
        return null;
      case 400:
        throw BadRequest(body['error']);
      case 401:
        throw Unauthorized(body['error']);
      case 403:
        throw Forbidden(body['error']);
      case 404:
        throw NotFound(body['error']);
      default:
        throw ServerError(body['error']);
    }
  }
}
