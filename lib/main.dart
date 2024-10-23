import 'dart:io';
import 'package:args/args.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:walls/config.dart';
import 'package:walls/local_database.dart';
import 'package:walls/pages/collection/collection_page.dart';

// We're supporting only Linux, so this hardcoded path is ok.
final String dbPathBase = '${xdg.dataHome.path}/walls';
late final LocalDatabase db;

void main(List<String> arguments) async {
  if (Platform.isLinux) {
    sqfliteFfiInit();
  } else {
    debugPrint('Platform is not Linux');
    exit(1);
  }
  databaseFactory = databaseFactoryFfi;

  ArgParser parser = ArgParser();
  parser.addOption('dbFilename',
      defaultsTo: 'database.sqlite', help: 'Filename of the SQLite database');
  parser.addFlag('help',
      abbr: 'h', negatable: false, help: 'Print this help message');

  var results = parser.parse(arguments);

  if (results['help']) {
    debugPrint(parser.usage);
    exit(0);
  }

  Config config = Config(
      dbPath: '$dbPathBase/${results.option('dbFilename')!}',
      collectionPath: '');

  db = LocalDatabase(dbPath: config.dbPath);

  await db.openLocalDatabase();
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
