import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'home.dart';

class ImageView extends StatefulWidget {
  final String imgPath;

  ImageView({@required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isLoading;
  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Hero(
        tag: widget.imgPath,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FadeInImage.memoryNetwork(
              image: widget.imgPath,
              placeholder: kTransparentImage,
              fit: BoxFit.cover),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).accentColor,
            icon: const Icon(
              Icons.chevron_left,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child:
            Padding(padding: const EdgeInsets.all(20.0), child: _buildButton()),
      ),
    ]));
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        _save();
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(500),
            ),
            padding: const EdgeInsets.all(17),
            child: Icon(
              Icons.download_rounded,
              color: Colors.cyanAccent,
              size: 20,
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              height: 53,
              width: 53,
              child: isLoading
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.amberAccent,
                    )
                  : Container())
        ],
      ),
    );
  }

  _save() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(widget.imgPath);
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(widget.imgPath);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } catch (error) {
      print(error);
    }
    setState(() {
      isLoading = false;
    });
  }
}
