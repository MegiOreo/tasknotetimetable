import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';

class FaviconPage extends StatefulWidget {
  @override
  _FaviconPageState createState() => _FaviconPageState();
}

class _FaviconPageState extends State<FaviconPage> {
  final TextEditingController _urlController = TextEditingController();
  String? _faviconUrl;

  Future<void> _fetchFavicon() async {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      try {
        final icon = await FaviconFinder.getBest(url);
        setState(() {
          _faviconUrl = icon?.url;
        });
      } catch (e) {
        setState(() {
          _faviconUrl = null;
        });
        print('Error fetching favicon: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Favicon Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFavicon,
              child: Text('Fetch Favicon'),
            ),
            SizedBox(height: 16),
            if (_faviconUrl != null)
              Row(
                children: [
                  Image.network(
                    _faviconUrl!,
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Text(_urlController.text)),
                ],
              )
            else
              Text('No favicon found or enter a URL'),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: FaviconPage(),
    ));
