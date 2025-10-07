import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        children: [
          Image.asset(
            'assets/rencong_aceh_logo.png',
            width: 150,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Chatbot ditenagai oleh RAG, LangChain & Google Gemini.\n'
            'Analisis Sentimen menggunakan fine-tuned IndoBERT.\n\n'
            'Dibuat oleh M Hafiz Rinaldi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
