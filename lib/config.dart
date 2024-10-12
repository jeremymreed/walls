class Config {
  final String dbPath;
  final String collectionPath;

  const Config({
    required this.dbPath,
    required this.collectionPath,
  });

  @override
  String toString() {
    return 'Config {dbPath: $dbPath, collectionPath: $collectionPath}';
  }
}
