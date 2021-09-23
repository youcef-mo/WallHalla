import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'download_screen.dart';

class TopicScreen extends StatefulWidget {
  final String categorie, topicPhotos;
  TopicScreen({@required this.categorie, @required this.topicPhotos});

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List topic = [];
  String order_by = "latest";
  int per_page = 30;
  int page = 1;
  final client_id = "";

  getTopics() async {
    var turl = "${widget.topicPhotos}?per_page=$per_page&client_id=$client_id";
    var response = await http.get(turl);
    var converted = json.decode(response.body);
    setState(() {
      topic = converted;
    });
  }

  @override
  void initState() {
    getTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _buildTopic(),
      ),
    );
  }

  Widget _buildTopic() {
    return SafeArea(
      minimum: EdgeInsets.only(left: 8, right: 8),
      child: StaggeredGridView.countBuilder(
        primary: false,
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        itemCount: per_page,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(
                                imgPath: topic[index]["urls"]["regular"])));
                  },
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: topic[index]["urls"]["small"],
                    fit: BoxFit.cover,
                  ),
                ),
              ));
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      ),
    );
  }
}
