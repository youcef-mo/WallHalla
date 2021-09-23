import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'download_screen.dart';
import 'home.dart';

class SearchPage extends StatefulWidget {
  final String keyword;
  SearchPage({@required this.keyword});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var search = {};
  var query = "china";
  String order_by = "latest";
  int per_page = 30;
  int page = 1;
  final client_id = "";

  getSearch() async {
    var url =
        "https://api.unsplash.com/search/photos?page=$page&per_page=$per_page&query=${widget.keyword}&client_id=$client_id";
    var response = await http.get(url);
    var converted = json.decode(response.body);
    setState(() {
      search = converted;
    });
  }

  @override
  void initState() {
    getSearch();
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
        body: _buildSearch(),
      ),
    );
  }

  Widget _buildSearch() {
    int i = 0;
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
                                imgPath: search["results"][index]["urls"]
                                    ["regular"])));
                  },
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: search["results"][index]["urls"]["small"],
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
