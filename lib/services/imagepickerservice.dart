import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  // 🔹 Step 1: Private constructor
  ImagePickerService._privateConstructor();

  // 🔹 Step 2: Static instance
  static final ImagePickerService _instance = ImagePickerService._privateConstructor();

  // 🔹 Step 3: Public getter
  static ImagePickerService get instance => _instance;

  final ImagePicker _picker = ImagePicker();

  /// Request required permissions before picking images
  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    } else {
      // Gallery / storage permission
      final status = await Permission.photos.request();
      if (status.isGranted) return true;

      // On Android 13+, use READ_MEDIA_IMAGES
      final status2 = await Permission.storage.request();
      return status2.isGranted;
    }
  }

  /// Capture image from camera with permission check
  Future<File?> captureFromCamera() async {
    final granted = await _requestPermission(ImageSource.camera);
    if (!granted) {
      print('Camera permission denied');
      return null;
    }

    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    return picked != null ? File(picked.path) : null;
  }

  /// Pick image from gallery with permission check
  Future<File?> pickFromGallery() async {
    final granted = await _requestPermission(ImageSource.gallery);
    if (!granted) {
      print('Gallery permission denied');
      return null;
    }

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }
}
