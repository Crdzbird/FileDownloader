enum Environment { DEV, QA, PRODUCTION }

class DartDefineConfig {
  static const appName = String.fromEnvironment(
    'appName',
    defaultValue: 'FILE_DOWNLOADER',
  );

  static const env = String.fromEnvironment(
    'env',
    defaultValue: 'DEV',
  );

  static const _networkTimeout = String.fromEnvironment('networkTimeout');
  static int get networkTimeout => int.tryParse(_networkTimeout) ?? 60;

  static Environment environment() {
    switch (env.toUpperCase()) {
      case 'DEV':
        return Environment.DEV;
      default:
        return Environment.DEV;
    }
  }
}
