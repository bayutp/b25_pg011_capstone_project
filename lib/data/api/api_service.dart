import 'dart:convert';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _host = "https://api.cloudinary.com";
  final DotEnv env;

  const ApiService({required this.env});

  Future<String?> uploadImage(File file) async {
    final cloudName = env["CLOUDINARY_CLOUD_NAME"];
    final uploadPreset = env["CLOUDINARY_UPLOAD_PRESET"];

    final String path = "/v1_1/$cloudName/image/upload";

    try {
      final uri = Uri.parse('$_host$path');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file to the request
      request.fields['upload_preset'] = uploadPreset!;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final resJson = json.decode(responseData);
        return resJson['secure_url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
