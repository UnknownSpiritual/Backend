import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_2/provider/provider.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Berita'),
      ),
      body: FutureBuilder(
        future: newsProvider.fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          try {
            return ListView.builder(
              itemCount: newsProvider.newsList.length,
              itemBuilder: (context, index) {
                final news = newsProvider.newsList[index];
                return ListTile(
                  title: Text(news.title),
                  subtitle: Text(news.description),
                  leading: Image.network(news.urlToImage),
                );
              },
            );
          } catch (e) {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
