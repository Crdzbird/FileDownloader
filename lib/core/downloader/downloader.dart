import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_downloader/core/downloader/core/downloader_core.dart';
import 'package:file_downloader/core/downloader/utils/downloader_utils.dart';
import 'package:file_downloader/core/downloader/utils/constants.dart';
import 'package:file_downloader/core/utils/dart_define_config.dart';

typedef ProgressCallback = void Function(int count, int total);
Future<DownloaderCore> download(String url, DownloaderUtils options) async {
  try {
    final subscription = await initDownload(url, options);
    return DownloaderCore(subscription, options, url);
  } catch (e) {
    rethrow;
  }
}

Future<StreamSubscription> initDownload(
    String url, DownloaderUtils options) async {
  var lastProgress = await options.progress.getProgress(url);
  final client = options.client ??
      Dio(BaseOptions(sendTimeout: DartDefineConfig.networkTimeout));
  StreamSubscription? subscription;
  try {
    isDownloading = true;
    final target = await options.target.create(recursive: true);
    final response = await client.get(
      url,
      options: Options(
          responseType: ResponseType.stream,
          headers: {HttpHeaders.rangeHeader: 'bytes=$lastProgress-'}),
    );
    final _total = int.tryParse(response.headers.value('Content-length')!) ?? 0;
    final sink = await target.open(mode: FileMode.writeOnlyAppend);
    subscription = response.data.stream.listen((Uint8List data) async {
      subscription!.pause();
      await sink.writeFrom(data);
      final currentProgress = lastProgress + data.length;
      await options.progress.setProgress(url, currentProgress.toInt());
      options.progressCallback.call(currentProgress, _total);
      lastProgress = currentProgress;
      subscription.resume();
    }, onDone: () async {
      options.onDone.call();
      await sink.close();
      if (options.client != null) {
        client.close();
      }
    }, onError: (error) async {
      subscription!.pause();
    });
    return subscription!;
  } catch (e) {
    print('errors');
    print(e);
    rethrow;
  }
}
