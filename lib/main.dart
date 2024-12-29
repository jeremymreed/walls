import 'dart:io';
import 'package:args/args.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:walls/config.dart';
import 'package:walls/logger_wrapper.dart';
import 'package:walls/local_database.dart';
import 'package:walls/pages/collection/collection_page.dart';
import 'package:walls/pages/output_status/output_status_page.dart';

late final PackageInfo packageInfo;

late final String dbPathBase;
late final LocalDatabase db;

late final LoggerWrapper loggerWrapper;
late final String logPath;

void main(List<String> arguments) async {
  if (Platform.isLinux) {
    sqfliteFfiInit();
  } else {
    debugPrint('Platform is not Linux');
    exit(1);
  }

  // Required for the package_info_plus package.
  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();

  // We're supporting only Linux, so this hardcoded path is ok.
  logPath =
      "${Platform.environment['HOME']}/.local/state/${packageInfo.appName}/";
  dbPathBase = '${xdg.dataHome.path}/walls';

  debugPrint('logPath: $logPath');
  debugPrint('dbPathBase: $dbPathBase');

  loggerWrapper = LoggerWrapper(logPath: logPath);

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

  loggerWrapper.info('Setup completed, running the app');
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
            OutputStatusPage(),
            CollectionPage(),
            Center(child: Text('Tags')),
            Center(child: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
