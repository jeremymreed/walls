import 'package:flutter/material.dart';
import 'package:walls/pages/collection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallpaper Manager'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Outputs'),
              Tab(text: 'Collection'),
              Tab(text: 'Tags'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: Text('Outputs')),
            CollectionPage(),
            Center(child: Text('Tags')),
            Center(child: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
