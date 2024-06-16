import 'package:app/infra/http/http_adapter.dart';
import 'package:app/infra/http/http_client.dart';
import 'package:http/http.dart';

HttpClient makeHttpClient() => HttpAdapter(Client());
