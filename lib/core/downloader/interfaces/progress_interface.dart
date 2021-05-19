abstract class ProgressInterface {
  Future<int> getProgress(String url);
  Future<void> setProgress(String url, int received);
  Future<void> resetProgress(String url) async {
    await setProgress(url, 0);
  }
}
