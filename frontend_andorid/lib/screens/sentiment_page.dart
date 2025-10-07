import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../widgets/footer_widget.dart';

class SentimentAnalysisPage extends StatefulWidget {
  const SentimentAnalysisPage({super.key});
  @override
  State<SentimentAnalysisPage> createState() => _SentimentAnalysisPageState();
}

class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = 'Hasil analisis akan ditampilkan di sini...';
  String _disclaimer = '';
  bool _isLoading = false;

  Future<void> _analyzeSentiment() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _disclaimer = '';
    });

    try {
      final response = await ApiService.postPredictSentiment({
        'text': _controller.text,
      }).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _result =
              "Hasil Sentimen: ${data['sentiment']?.toString().toUpperCase()}";

          _disclaimer = data['disclaimer'] ?? '';
        });
      } else {
        setState(
          () => _result =
              'Error: Gagal terhubung (Code: ${response.statusCode}).',
        );
      }
    } catch (e) {
      setState(() => _result = 'Error: Periksa koneksi dan alamat IP Backend.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Analisis Sentimen Teks Budaya',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prototipe V2: Masukkan potongan teks sastra atau hikayat untuk dianalisis.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Masukkan teks di sini...',
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _analyzeSentiment,
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black87,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Analisis Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Hasil Analisis:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _result,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                if (_disclaimer.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF4A6569)),
                  Text(
                    'Catatan: $_disclaimer',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
