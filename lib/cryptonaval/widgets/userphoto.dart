import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class UserPhoto extends StatelessWidget {
  const UserPhoto({
    super.key,
    required this.avatar,
    required this.client,
    this.radius = 24,
  });

  final Uri? avatar;
  final Client client;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: CupertinoColors.systemGrey,
      child: ClipOval(
        child: avatar == null
            ? Icon(
                Icons.person,
                color: Colors.white,
                size: radius * 1.5,
              )
            : extended_image.ExtendedImage.network(
                avatar!
                    .getThumbnail(client, width: 2 * radius, height: 2 * radius)
                    .toString(),
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case extended_image.LoadState.loading:
                      return const CupertinoActivityIndicator();
                    case extended_image.LoadState.completed:
                      return extended_image.ExtendedRawImage(
                        image: state.extendedImageInfo?.image,
                      );
                    case extended_image.LoadState.failed:
                      return const Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      );
                  }
                },
              ),
      ),
    );
  }
}
