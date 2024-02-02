
import 'package:app_movil_dincydet/previews/dialog_preview.dart';
import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// TODO: Change the data fields to the correct ones

class FilesGrid extends StatelessWidget {
  const FilesGrid({
    super.key,
    required this.data,
    this.onTapAdd,
    this.onTapDelete,
  });
  final List<dynamic> data;
  final void Function()? onTapAdd;
  final void Function(int fileid)? onTapDelete;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 10.0,
              children: List.generate(
                data.length,
                (index) {
                  final row = data[index];
                  final extension = row['NAME'].split('.').last;
                  return SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  // Save File
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DialogFilePreview(
                                          name: row['NAME'],
                                          url: row['URL'],
                                        );
                                      });
                                  return;
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    {'png', 'jpg', 'jpeg', 'gif'}
                                            .contains(extension)
                                        ? Expanded(
                                            child: CachedNetworkImageBuilder(
                                              url: row['URL'],
                                              builder: (image) {
                                                return Image.file(
                                                  image,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          )
                                        : parseIcon(row['NAME']),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      row['NAME'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_sharp,
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    if (onTapDelete == null) {
                                      return;
                                    }
                                    onTapDelete!(row['ID']);
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    String? selectedDir = await FilePicker
                                        .platform
                                        .getDirectoryPath();

                                    if (selectedDir == null) {
                                      return;
                                    }
                                    String finalpath =
                                        '$selectedDir/${row['NAME']}';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Descargando archivo'),
                                      ),
                                    );
                                    final response = await Dio()
                                        .download(row['URL'], finalpath);
                                    String text = "Error en la descarga";
                                    if (response.statusCode == 200) {
                                      text = "Descarga completa";
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(text)));
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )..add(
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: onTapAdd,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget parseIcon(String name) {
    final extension = name.split('.').last;
    switch (extension) {
      case 'pdf':
        return const Icon(
          Icons.picture_as_pdf_outlined,
          size: 48,
        );
      case 'mp4':
        return const Icon(
          Icons.video_collection,
          size: 48,
        );
      case 'txt':
        return const Icon(
          Icons.file_open,
          size: 48,
        );
      case 'pptx':
        return const Icon(
          Icons.present_to_all,
          size: 48,
        );
      default:
        return const Icon(
          Icons.file_download,
          size: 48,
        );
    }
  }
}
