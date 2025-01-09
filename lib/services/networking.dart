import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking {
  final String url;

  Networking({required this.url});

  Future<dynamic> getData() async {
    try {
      // Realiza la solicitud HTTP GET
      var response = await http.get(Uri.parse(url));

      // Verifica el estado de la respuesta
      if (response.statusCode == 200) {
        // Decodifica el cuerpo de la respuesta JSON
        var jsonResponse = jsonDecode(response.body);
        print('Respuesta del servidor: $jsonResponse'); // Imprime la respuesta completa
        return jsonResponse;
      } else {
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        return null; // Maneja errores devolviendo null
      }
    } catch (e) {
      print('Excepción al realizar la solicitud: $e');
      return null; // Devuelve null en caso de error
    }
  }
}
