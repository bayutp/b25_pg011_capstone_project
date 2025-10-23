import 'package:b25_pg011_capstone_project/provider/user/user_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditableAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;

  const EditableAvatar({super.key, this.imageUrl, this.size = 90.0});

  @override
  State<EditableAvatar> createState() => _EditableAvatarState();
}

class _EditableAvatarState extends State<EditableAvatar> {
  late UserImageProvider _imgService;

  @override
  void initState() {
    super.initState();
    _imgService = context.read<UserImageProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final imgUri = widget.imageUrl ?? '';
    return Stack(
      children: [
        Consumer<UserImageProvider>(
          builder: (context, value, child) {
            return CircleAvatar(
              radius: size / 2,
              child: ClipOval(
                child: SizedBox.expand(
                  child: value.imageBytes != null
                      ? Image.memory(value.imageBytes!, fit: BoxFit.cover)
                      : (imgUri.isNotEmpty
                            ? Image.network(imgUri, fit: BoxFit.cover)
                            : Image.asset(
                                'assets/img/avatar.png',
                                fit: BoxFit.cover,
                              )),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Opacity(
            opacity: 0.7,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _imgService.openGallery();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Camera'),
                            onTap: () {
                              Navigator.pop(context);
                              _imgService.openCamera();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.photo_camera_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
