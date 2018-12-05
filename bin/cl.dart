import 'package:http/http.dart'
    as http; // Must include http package in your pubspec.yaml
import 'dart:convert';

void main() async {
  const String clientID = "com.heroes.tutorial";
  const String body = "username=bob&password=password&grant_type=password";

// Note the trailing colon (:) after the clientID.
// A client identifier secret would follow this, but there is no secret, so it is the empty string.
  final clientCredentials = base64.encode("$clientID:".codeUnits);

  final response = await http.post("http://localhost:8888/auth/token",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Basic $clientCredentials"
      },
      body: body);
    print(response.body);
}
