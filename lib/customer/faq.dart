import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FAQPage(),
    );
  }
}

class FAQPage extends StatelessWidget {
  final List<FAQ> faqs = [
    FAQ(
        question: 'What is the return policy?',
        answer: 'You can return any item within 3 days of purchase.'),
    FAQ(
        question: 'How do I track my order?',
        answer: 'You can track your order using the tracking link.'),
    FAQ(
        question: 'What payment methods are accepted?',
        answer: 'We accept credit cards, Qris, and bank transfers.'),
    FAQ(
        question: 'How can I contact customer support?',
        answer: 'You can contact us via whatsapp ( Alfaregi - 085934759574 ).'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return FAQCard(faq: faqs[index]);
          },
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQCard extends StatelessWidget {
  final FAQ faq;

  FAQCard({required this.faq});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(faq.answer),
          ),
        ],
      ),
    );
  }
}
