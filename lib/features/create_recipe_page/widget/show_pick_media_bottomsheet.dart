import 'package:fit_eat/features/create_recipe_page/viewmodel/create_recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../model/recipe_media_model.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  const MediaPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<CreateRecipeViewModel>();

    void pick(MediaType type, ImageSource source) {
      Navigator.pop(context);
      viewmodel.pickMedia(type, source);
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Image from Gallery"),
            onTap: () => pick(MediaType.image, ImageSource.gallery),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Image from Camera"),
            onTap: () => pick(MediaType.image, ImageSource.camera),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text("Video from Gallery"),
            onTap: () => pick(MediaType.video, ImageSource.gallery),
          ),
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text("Video from Camera"),
            onTap: () => pick(MediaType.video, ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
