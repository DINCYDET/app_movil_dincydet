import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_player/video_player.dart';

class DialogFilePreview extends StatelessWidget {
  const DialogFilePreview({
    super.key,
    
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

  String get extension {
    return name.split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(10.0),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Builder(
            builder: (context) {
              print(url);

              switch (extension) {
                case 'png':
                case 'jpg':
                case 'jpeg':
                  return PreviewIMG(url: url);
                case 'mp4':
                  return PreviewMP4(url: url);
                case 'pdf':
                  return PreviewPDF(url: url);
                default:
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                      ),
                      Text(
                        'Este archivo no se puede previsualizar',
                      ),
                    ],
                  );
              }
            },
          ),
        )
      ],
    );
  }
}

class PreviewIMG extends StatelessWidget {
  const PreviewIMG({
    super.key,
    required this.url,
  });
  final String url;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImageBuilder(
      url: url,
      builder: (image) {
        return Image.file(
          image,
          fit: BoxFit.contain,
        );
      },
      errorWidget: const Column(
        children: [
          Icon(
            Icons.error_outline_outlined,
          ),
          Text('No se pudo obtener la imagen'),
        ],
      ),
    );
  }
}

class PreviewMP4 extends StatefulWidget {
  const PreviewMP4({
    super.key,
    required this.url,
  });
  final String url;
  @override
  State<PreviewMP4> createState() => _PreviewMP4State();
}

class _PreviewMP4State extends State<PreviewMP4> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url,
    )..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class PreviewPDF extends StatefulWidget {
  const PreviewPDF({
    super.key,
    required this.url,
  });
  final String url;
  @override
  State<PreviewPDF> createState() => _PreviewPDFState();
}

class _PreviewPDFState extends State<PreviewPDF> {
  late Future<PdfDocument> doc;
  late PdfController pdfController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doc = PdfDocument.openData(
      InternetFile.get(widget.url),
    );
    pdfController = PdfController(document: doc);
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(
      controller: pdfController,
    );
  }
}
