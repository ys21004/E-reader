import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PdfUploadPage extends StatelessWidget {
  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('YOUR_STRAPI_UPLOAD_ENDPOINT'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'pdf',
          result.files.single.path!,
        ),
      );

      // Add any necessary headers or authentication tokens
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // File uploaded successfully
        print('File uploaded!');
      } else {
        // Handle error
        print('Error uploading file: ${response.reasonPhrase}');
      }
    } else {
      // User canceled the file picker
      print('User canceled file picker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Upload Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadFile,
          child: Text('Upload PDF'),
        ),
      ),
    );
  }
}
