import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({
    super.key,
    this.photo,
    this.radius = 20,
  });
  final String? photo;
  final double radius;
  @override
  Widget build(BuildContext context) {
    if (photo == null) {
      return Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: radius * 1.5,
        ),
      );
    }
    return CachedNetworkImageBuilder(
      url: photo!,
      builder: ((image) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.contain,
            ),
          ),
        );
      }),
      placeHolder: const CircularProgressIndicator(),
      errorWidget: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      imageExtensions: const ['jpg', 'jpeg', 'png'],
    );
  }
}
