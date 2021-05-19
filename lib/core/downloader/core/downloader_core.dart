import 'dart:async';

import 'package:file_downloader/core/downloader/downloader.dart';
import 'package:file_downloader/core/downloader/utils/downloader_utils.dart';
import 'package:file_downloader/core/downloader/utils/constants.dart';

class DownloaderCore {
  late StreamSubscription _inner;
  late final DownloaderUtils _options;
  late final String _url;
  bool isCancelled = false;

  DownloaderCore(StreamSubscription inner, DownloaderUtils options, String url)
      : _inner = inner,
        _options = options,
        _url = url;

  Future<void> pause() async {
    _isActive();
    await _inner.cancel();
    isDownloading = false;
  }

  Future<void> resume() async {
    _isActive();
    if (isDownloading) return;
    _inner = await initDownload(_url, _options);
  }

  Future<void> cancel() async {
    _isActive();
    await _inner.cancel();
    await _options.progress.resetProgress(_url);
    if (_options.deleteOnCancel) {
      await _options.target.delete();
    }
    isCancelled = true;
    isDownloading = false;
  }

  void _isActive() {
    if (isCancelled) throw StateError('Already cancelled');
  }

  Future<DownloaderCore> download(String url, DownloaderUtils options) async {
    try {
      final subscription = await initDownload(url, options);
      return DownloaderCore(subscription, options, url);
    } catch (e) {
      rethrow;
    }
  }
}
