import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class PreviewPdfImg extends StatelessWidget {
  PreviewPdfImg(
    this.url, {
    super.key,
  }) {
    if (hasFile && isPdf) {
      pdfController = PdfController(
        document: PdfDocument.openData(InternetFile.get(url!)),
      );
    }
  }

  final String? url;
  PdfController? pdfController;

  @override
  Widget build(BuildContext context) {
    if (!hasFile) {
      return const Center(
        child: Text('No se adjuntó un archivo'),
      );
    }
    if (!isValidFormat) {
      return const Center(
        child: Text('El visor no soporta este formato'),
      );
    }
    return isImage
        ? PhotoView.customChild(
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 2,
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: CachedNetworkImageBuilder(
              url: url!,
              builder: (image) {
                return Image.file(
                  image,
                );
              },
            ),
          )
        : PdfView(
            controller: pdfController!,
            builders: PdfViewBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(
                loaderSwitchDuration: Duration(seconds: 1),
              ),
              errorBuilder: (p0, error) => const Center(
                child: Text('No se pudo cargar el archivo'),
              ),
            ),
          );
  }

  bool get hasFile => url != null && url!.isNotEmpty;
  bool get isImage =>
      {'png', 'jpg', 'jpeg', 'gif'}.contains(url!.split('.').last);
  bool get isValidFormat =>
      {'pdf', 'png', 'jpg', 'jpeg', 'gif'}.contains(url!.split('.').last);
  bool get isPdf => url!.split('.').last == 'pdf';
}
