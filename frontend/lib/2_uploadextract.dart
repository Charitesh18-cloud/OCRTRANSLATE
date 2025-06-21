import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadExtractScreen extends StatefulWidget {
  final String? preselectedOcrLanguage;
  const UploadExtractScreen({super.key, this.preselectedOcrLanguage});

  @override
  State<UploadExtractScreen> createState() => _UploadExtractScreenState();
}

class _UploadExtractScreenState extends State<UploadExtractScreen> {
  Uint8List? _fileBytes;
  String? _fileName;
  String? _extractedText;
  String? _translatedText;
  bool _isLoading = false;
  bool _isTranslating = false;

  String _ocrLanguage = 'eng';
  String _targetLanguage = 'hi';
  String? _selectedLangName;

  final Map<String, String> _ocrLanguages = {
    'Assamese': 'asm',
    'Bengali': 'ben',
    'Bodo': 'bod',
    'Gujarati': 'guj',
    'Hindi': 'hin',
    'Kannada': 'kan',
    'Malayalam': 'mal',
    'Marathi': 'mar',
    'Nepali': 'nep',
    'Odia': 'ori',
    'Punjabi': 'pan',
    'Sanskrit': 'san',
    'Sindhi': 'snd',
    'Tamil': 'tam',
    'Telugu': 'tel',
    'Urdu': 'urd',
    'English': 'eng',
  };

  final Map<String, String> _translationLanguages = {
    'Assamese': 'as',
    'Bengali': 'bn',
    'Bodo': 'brx',
    'Gujarati': 'gu',
    'Hindi': 'hi',
    'Kannada': 'kn',
    'Malayalam': 'ml',
    'Marathi': 'mr',
    'Nepali': 'ne',
    'Odia': 'or',
    'Punjabi': 'pa',
    'Sanskrit': 'sa',
    'Sindhi': 'sd',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Urdu': 'ur',
    'English': 'en',
  };

  @override
  void initState() {
    super.initState();
    if (widget.preselectedOcrLanguage != null &&
        _ocrLanguages.containsValue(widget.preselectedOcrLanguage)) {
      _ocrLanguage = widget.preselectedOcrLanguage!;
      _targetLanguage = _translationLanguages[_ocrLanguages.keys
          .firstWhere((k) => _ocrLanguages[k] == _ocrLanguage)]!;
      _selectedLangName = _ocrLanguages.keys
          .firstWhere((k) => _ocrLanguages[k] == _ocrLanguage);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _fileBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
        _extractedText = null;
        _translatedText = null;
      });
    }
  }

  Future<void> _extractText() async {
    if (_fileBytes == null) return;
    setState(() {
      _isLoading = true;
      _extractedText = null;
      _translatedText = null;
    });

    try {
      final apiUrl = 'http://192.168.0.102:8000/ocr';
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['language'] = _ocrLanguage
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          _fileBytes!,
          filename: _fileName,
          contentType: MediaType(
            _fileName!.toLowerCase().endsWith('.pdf') ? 'application' : 'image',
            _fileName!.toLowerCase().endsWith('.pdf') ? 'pdf' : 'jpeg',
          ),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final decoded = json.decode(respStr);
        setState(() {
          _extractedText = decoded['text'] ?? 'No text found.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _extractedText = 'OCR error (status ${response.statusCode}).';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _extractedText = 'OCR failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _translateText() async {
    if (_extractedText == null || _extractedText!.trim().isEmpty) return;
    setState(() {
      _isTranslating = true;
      _translatedText = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.102:8000/translate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': _extractedText,
          'source_language': 'en',
          'target_language': _targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          _translatedText = decoded['translated_text'] ?? 'Translation failed.';
          _isTranslating = false;
        });
      } else {
        setState(() {
          _translatedText = 'Translation error: ${response.statusCode}';
          _isTranslating = false;
        });
      }
    } catch (e) {
      setState(() {
        _translatedText = 'Translation failed: $e';
        _isTranslating = false;
      });
    }
  }

  Future<void> _downloadTextFile() async {
    if (_extractedText == null) return;
    final text = _extractedText!;
    final filename = 'extracted_text.txt';

    try {
      final blob = html.Blob([text]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (_) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved to: ${file.path}')),
      );
    }
  }

  Future<void> _saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null ||
        _extractedText == null ||
        _extractedText!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required or no extracted text')),
      );
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_docs')
          .doc();

      await docRef.set({
        'filename': _fileName ?? 'Unnamed Document',
        'text': _extractedText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to Firestore')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    }
  }

  bool _isImageFile(String? fileName) {
    if (fileName == null) return false;
    final lower = fileName.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        title: const Text('Upload & Extract'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Icon(Icons.upload, size: 28, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text('Upload & Extract Text', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.orange.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📌 Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("1. Upload an image or PDF document."),
                      Text("2. Extract text using OCR."),
                      Text("3. Translate the extracted text into one of the target languages."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: _pickFile,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.text_snippet),
                      label: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Extract Text'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: _isLoading ? null : _extractText,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_extractedText != null) ...[
                const Text("Select Language:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _translationLanguages.entries.map((entry) {
                    final isSelected = _selectedLangName == entry.key;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blueGrey.shade600 : Colors.blueGrey.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          _targetLanguage = entry.value;
                          _ocrLanguage = _ocrLanguages[entry.key] ?? 'eng';
                          _selectedLangName = entry.key;
                        });
                      },
                      child: Text(entry.key, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.translate),
                    label: _isTranslating
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Translate Text'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _isTranslating ? null : _translateText,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (_fileBytes != null && _isImageFile(_fileName)) ...[
                Image.memory(_fileBytes!, height: 250),
                const SizedBox(height: 20),
              ] else if (_fileBytes != null && _fileName != null) ...[
                Text("Selected file: $_fileName"),
                const SizedBox(height: 20),
              ],
              if (_extractedText != null) ...[
                SelectableText(_extractedText!, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
              ],
              if (_translatedText != null) ...[
                const Divider(),
                const Text("Translated Text:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SelectableText(_translatedText!, style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
              const SizedBox(height: 20),
              if (_extractedText != null) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Text'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _extractedText!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Text copied to clipboard')),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download as .txt'),
                  onPressed: _downloadTextFile,
                ),
                const SizedBox(height: 10),
                if (FirebaseAuth.instance.currentUser != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save to My Docs'),
                    onPressed: _saveToFirestore,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
