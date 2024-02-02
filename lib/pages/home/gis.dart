import 'package:app_movil_dincydet/main.dart';
import 'package:app_movil_dincydet/providers/home/dashboard_provider.dart';
import 'package:app_movil_dincydet/providers/main/main_provider.dart';
import 'package:app_movil_dincydet/providers/main/mainuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:app_movil_dincydet/src/utils/user_photo.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class RealTimeMap extends StatelessWidget {
  const RealTimeMap({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return LayoutBuilder(
        builder: (context, constrains) {
          final maxW = constrains.maxWidth;
          final maxH = maxW * 0.5;
          print(maxW);
          print(MediaQuery.of(context).size);
          return Container(
            height: maxH,
            width: maxW,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mapa2.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: provider.gisData.entries.map((e) {
                return MyAvatarWidget(
                  images: e.value['images'],
                  ids: e.value['ids'],
                  top: e.value['ypos'] * maxH / 1000,
                  left: e.value['xpos'] * maxW / 1000,
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }
}

class MyAvatarWidget extends StatelessWidget {
  const MyAvatarWidget({
    super.key,
    required this.images,
    required this.top,
    required this.left,
    required this.ids,
  });

  final List<dynamic> images;
  final List<dynamic> ids;
  final double top;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top - 48,
      left: left - 48,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          const Icon(
            Icons.place,
            size: 96,
            color: Colors.red,
          ),
          Container(
            child: Column(
              children: [
                images.length == 1
                    ? Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        child: InkWell(
                          onTap: () {
                            onTapID(ids[0], images[0]);
                          },
                          child: CachedNetworkImageBuilder(
                            url: images[0],
                            placeHolder: const CircularProgressIndicator(),
                            builder: (image) {
                              return Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(image),
                                      fit: BoxFit.cover),
                                ),
                              );
                            },
                            errorWidget: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MC_darkblue,
                              border:
                                  Border.all(color: Colors.black, width: 2.0)),
                          child: Text(
                            '${images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onTap: () {
                          final tooltip = SuperTooltip(
                            showCloseButton: ShowCloseButton.inside,
                            content: Material(
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                child: GridView.count(
                                  crossAxisCount: 5,
                                  children:
                                      List.generate(images.length, (index) {
                                    return InkWell(
                                      onTap: () {
                                        onTapID(ids[index], images[index]);
                                      },
                                      child: UserPhotoWidget(
                                        photo: images[index],
                                        radius: 20,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            popupDirection: TooltipDirection.down,
                          );
                          tooltip.show(context);
                        },
                      ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTapID(int id, String photo) {
    Provider.of<MainUserProvider>(navigatorKey.currentContext!, listen: false)
        .USERID = id;
    Provider.of<MainProvider>(navigatorKey.currentContext!, listen: false)
        .USERDATA = null;
    navigatorKey.currentState!.pushNamed('/userview');
  }
}
