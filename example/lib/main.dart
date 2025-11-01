import 'package:flutter/material.dart';
import 'package:amazon_url_extractor/amazon_url_extractor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon URL Extractor Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AmazonExtractorExample(),
    );
  }
}

class AmazonExtractorExample extends StatefulWidget {
  const AmazonExtractorExample({super.key});

  @override
  State<AmazonExtractorExample> createState() => _AmazonExtractorExampleState();
}

class _AmazonExtractorExampleState extends State<AmazonExtractorExample> {
  final TextEditingController _urlController = TextEditingController();
  ExtractionResult? _result;
  bool _isLoading = false;
  String? _error;

  final extractor = const AmazonUrlExtractor();

  Future<void> _extractProductInfo() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _error = 'Please enter a URL';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await extractor.extractProductInfo(url);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Amazon URL Extractor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Amazon Product URL',
                hintText: 'https://www.amazon.com/dp/B08N5WRWNW',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _extractProductInfo,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Extract Product Info'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Extracted Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('ASIN', _result!.asin ?? 'N/A'),
                      _buildInfoRow('Domain', _result!.domain.domain),
                      _buildInfoRow('Country', _result!.domain.countryCode),
                      _buildInfoRow('Currency', _result!.domain.currency),
                      _buildInfoRow('Marketplace', _result!.domain.marketplace),
                      if (_result!.title != null)
                        _buildInfoRow('Title', _result!.title!),
                      if (_result!.price?.formattedPrice != null)
                        _buildInfoRow('Price', _result!.price!.formattedPrice!),
                      if (_result!.affiliateInfo?.hasAffiliateTag ?? false)
                        _buildInfoRow(
                          'Affiliate Tag',
                          _result!.affiliateInfo!.tag ?? 'N/A',
                        ),
                      if (_result!.canonicalUrl != null)
                        _buildInfoRow('Canonical URL', _result!.canonicalUrl!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_result!.asin != null)
                AmazonProductPreview(
                  title: _result!.title ?? 'Product',
                  price: _result!.price,
                  availability: _result!.availability,
                  asin: _result!.asin,
                  onTap: () {
                    // Handle tap
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
