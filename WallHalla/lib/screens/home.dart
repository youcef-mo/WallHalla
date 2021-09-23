import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thememode_selector/thememode_selector.dart';
import 'package:wallhalla/screens/download_screen.dart';
import 'package:wallhalla/screens/search_screen.dart';
import 'package:wallhalla/screens/topics_screen.dart';

import '../theme/themes.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child) {
      return ThemeModeManager(
        defaultThemeMode: ThemeMode.light,
        builder: (themeMode) {
          return MaterialApp(
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        title: ThemeModeSelector(
                          height: 30,
                          onChanged: (mode) {
                            print('ThemeMode changed to $mode');
                            // Again, this could be using whatever approach to state
                            // management you like
                            ThemeModeManager.of(context).themeMode = mode;
                          },
                        ),
                        floating: true,
                        pinned: false,
                        expandedHeight: 180.0,
                        stretch: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            "WallHalla",
                            style: TextStyle(fontFamily: "Nexa"),
                          ),
                          stretchModes: [StretchMode.fadeTitle],
                          background: Image.network(
                            "https://source.unsplash.com/1600x900/?nature",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: HomePage()),
            ),
          );
        },
      );
    });
  }
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const margin = EdgeInsets.only(
    left: 10,
  );

  List photos = [];
  List topics = [];
  int i = 0;
  List data = [];
  List order = ["latest", "oldest", "popular"];
  String order_by = "latest";
  int per_page = 30;
  final client_id = "";

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    var url =
        'https://api.unsplash.com/photos?per_page=$per_page&order_by=$order_by&client_id=$client_id';
    readJson(url);
    getTopics();
  }

  Future<void> getTopics() async {
    var turl = "https://api.unsplash.com/topics?client_id=$client_id";
    var response = await http.get(turl);
    var converted = json.decode(response.body);
    setState(() {
      topics = converted;
    });
  }

  Future<void> readJson(url) async {
    var response = await http.get(url);
    var converted = json.decode(response.body);
    setState(() {
      data = converted;
    });
    print(data);
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        _searchBar(context),
        SizedBox(height: 10),
        Padding(
          padding: margin,
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Nexa",
            ),
          ),
        ),
        categorisBar(),
        SizedBox(height: 5),
        Padding(
          padding: margin,
          child: Text(
            'For you',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Nexa",
            ),
          ),
        ),
        _latestPhotos()
      ],
    );
  }

  Widget categorisBar() {
    return Container(
      height: 100,
      child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            /// Create List Item tile
            return TopicTile(
                imgUrls: topics[index]["cover_photo"]["urls"]["small"],
                categorie: topics[index]["title"],
                topicPhotos: topics[index]["links"]["photos"]);
          }),
    );
  }

  Widget _latestPhotos() {
    return Expanded(
      child: SafeArea(
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
                                imgPath: data[index]["urls"]["regular"])));
                  },
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: data[index]["urls"]["small"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return Container(
      margin: EdgeInsets.only(left: 5, right: 100),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      decoration: BoxDecoration(
          color: Colors.teal[50], borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black54,
        ),
        controller: textController,
        decoration: InputDecoration(
          hintText: "Search Wallpaper",
          hintStyle: TextStyle(
            color: Colors.black54,
          ),
          border: InputBorder.none,
          suffix: IconButton(
            focusColor: Colors.teal,
            disabledColor: Colors.purpleAccent,
            color: Colors.cyanAccent,
            icon: Icon(
              Icons.search,
              color: Colors.cyanAccent,
            ),
            onPressed: () {
              if (textController.text != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(keyword: textController.text)));
              }
            },
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        ),
      ),
    );
  }

  Widget _popularPhotos() {
    var order_by = "popular";
    var url1 =
        'https://api.unsplash.com/photos?per_page=$per_page&order_by=$order_by&client_id=$client_id';
    readJson(url1);
    return Expanded(
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
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: data[index]["urls"]["small"],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    ));
  }

  Widget _oldestrPhotos() {
    var order_by = "oldest";
    var url2 =
        'https://api.unsplash.com/photos?per_page=$per_page&order_by=$order_by&client_id=$client_id';
    readJson(url2);
    return Expanded(
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
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: data[index]["urls"]["small"],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    ));
  }
}

class TopicTile extends StatelessWidget {
  final String imgUrls, categorie, topicPhotos;
  TopicTile(
      {@required this.imgUrls,
      @required this.categorie,
      @required this.topicPhotos});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TopicScreen(
                      categorie: categorie,
                      topicPhotos: topicPhotos,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: imgUrls,
                height: 50,
                width: 100,
                fit: BoxFit.fill,
              )),
          Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            width: 100,
            child: Text(
              categorie,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nexa'),
            ),
          )
        ]),
      ),
    );
  }
}
