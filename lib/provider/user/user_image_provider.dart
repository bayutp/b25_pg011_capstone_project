import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserImageProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  Uint8List? imageBytes;

  Future<void> _setImage(XFile? value) async {
    if (value == null) return;
    imageFile = value;
    imagePath = value.path; // gunakan path asli
    imageBytes = await value.readAsBytes(); // baca bytes langsung
    notifyListeners();
  }

  Future<void> openGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      await _setImage(picked);
    } catch (e) {
      debugPrint('openGallery error: $e');
    }
  }

  Future<void> openCamera() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.camera);
      await _setImage(picked);
    } catch (e) {
      debugPrint('openCamera error: $e');
    }
  }

  Future<void> cropImage(BuildContext context) async {
    if (imagePath == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: imagePath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(title: 'Crop Photo'),
        WebUiSettings(context: context),
      ],
    );

    if (cropped != null) {
      await _setImage(XFile(cropped.path));
    }
  }

  void clearImage() {
    imagePath = null;
    imageFile = null;
    imageBytes = null;
    notifyListeners();
  }
}
