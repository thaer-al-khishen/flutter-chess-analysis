import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Function to download the file
Future<File> downloadFile(String url, String filename) async {
  http.Response response = await http.get(Uri.parse(url));

  Directory downloadsDirectory = await getApplicationDocumentsDirectory();
  File file = File('${downloadsDirectory.path}/$filename');

  await file.writeAsBytes(response.bodyBytes);

  return file;
}
