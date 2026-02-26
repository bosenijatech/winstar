import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  // 🔹 Singleton instance
  static final AppLauncher _instance = AppLauncher._internal();
  factory AppLauncher() => _instance;
  AppLauncher._internal();

  /// ✅ Launch a URL (opens in browser or new tab)
  Future<void> launchUrlInBrowser(String url, {bool isNewTab = true}) async {
    final Uri uri = Uri.parse(url);

    // Check if the URL can be launched
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch $url');
    }

    // iOS automatically opens Safari; Android opens browser or in-app view
    await launchUrl(
      uri,
      mode: isNewTab
          ? LaunchMode.externalApplication // Opens system browser (new tab)
          : LaunchMode.inAppWebView,        // Opens inside app
    );
  }
}
