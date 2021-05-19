import 'package:file_downloader/core/downloader/interfaces/progress_interface.dart';

class ProgressImplementation extends ProgressInterface {
  final Map<String, int> _inner = {};
  @override
  Future<int> getProgress(String url) async {
    return _inner[url] ?? 0;
  }

  @override
  Future<void> setProgress(String url, int received) async {
    _inner[url] = received;
  }
}
