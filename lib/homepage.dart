import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studify/about.dart';
import 'package:studify/managephotos.dart';
import 'package:studify/managetags.dart';
import 'package:studify/models/photo.dart';
import 'package:studify/settings.dart';
import 'package:studify/signinsignup.dart';
import 'package:studify/tagdetails.dart';
import 'package:studify/utils/dbhelper.dart';
import 'models/tag.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
class Homepage extends StatefulWidget {
  bool _darkMode;
  Homepage(this._darkMode, {Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{


  TextEditingController _searchBarController;
  //Widget _categoryListing;
  List<Tag> _tags;
  DBHelper _dbHelper;
  bool _retrievedTags;
  List<Tag> _duplicateTags;
  List<Tag> _searchItems;
  bool _searching;
  Map<String, List<Photo>> _tagPreviews;
  File file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchBarController = TextEditingController();
    _dbHelper = DBHelper();
    _tags = [];
    _duplicateTags = [];
    _searchItems = [];
    _retrievedTags = false;
    _searching = false;




    _tagPreviews = Map<String, List<Photo>>();

    if(mounted) _getTagInfo();
  }

  _getTagInfo() async{
    _dbHelper.getAllTags().then((value) async{
      for(Map tagMap in value){
        _tags.add(Tag.fromMap(tagMap));
      }
      for(Tag tag in _tags){
        _dbHelper.getPhotosWithTagID([tag.id]).then((value) async{
          List<Photo> pht = [];
          for(Map map in value){
            pht.add(Photo.fromMap(map));
          }
          _tagPreviews[tag.id.toString()] = pht;

          _duplicateTags = List.from(_tags);
          _retrievedTags = true;
          print('retrieve completed');
          //_initializeCategoryWidget(context);
          if(mounted){
            setState(() {
              _retrievedTags = true;
            });
          }
        });
      }
      if(_tags.isEmpty){
        if(mounted){
          setState(() {
            _retrievedTags=true;
          });
        }
      }
      //WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => About())));
    });

  }

  _getImageWidthHeight(Image image, bool isWidth) async{
    Completer<ui.Image> completer = Completer<ui.Image>();

    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _){
      completer.complete(info.image);
    }));

    completer.future.then((image){
      //print(image.width);
      //print(image.height);
      return isWidth ? image.width : image.height;
    });
  }

  /*_initializeCategoryWidget(BuildContext context){
    _categoryListing = _listCategories(_tags);
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    //_initializeCategoryWidget(context);
    //_auth.signOut();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //drawer: myDrawer(),
      backgroundColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
      body: Center(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 48,),
                  InkWell(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Icon(Icons.search),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*(6.5/10),
                            height: 50,
                            child: Center(
                              child: TextFormField(
                                onChanged: (value){
                                  if(value.length>0){
                                    setState(() {
                                      _searching = true;
                                    });
                                    _filterSearchResults(value);
                                  }else{
                                    setState(() {
                                      _searching = false;
                                    });
                                  }
                                },
                                style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
                                controller: _searchBarController,
                                autofocus: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Etiketleri arayın.",
                                  hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            onSelected: (result){
                              switch(result){

                                case 0:
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManagePhotos(darkMode: widget._darkMode,))).then((value)async{
                                    _tags.clear();
                                    await _getTagInfo();
                                    setState(() {});
                                  });
                                  break;

                                case 1:
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageTags(tags: _tags, dataMap: _tagPreviews, darkMode: widget._darkMode,))).then((value) async{
                                    _tags.clear();
                                    await _getTagInfo();
                                    setState(() {});
                                  });
                                  break;

                                case 2:
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(darkMode: widget._darkMode)));
                                  break;
                                  
                                case 3:
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => About(darkMode: widget._darkMode)));
                                  break;

                                case 4:
                                  _showSignOutDialog();
                                  break;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Icon(Icons.more_vert_outlined),
                            ),
                            itemBuilder: (context){
                              return [
                                PopupMenuItem(
                                  value: 0,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                            Icons.photo_camera_outlined
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/40,),
                                        Text(
                                          'Fotoğrafları\nYönet',
                                          style: TextStyle(
                                              fontFamily: 'JetBrainsMono-Regular'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                          Icons.tag_outlined
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Text(
                                        'Etiketleri\nYönet',
                                        style: TextStyle(
                                            fontFamily: 'JetBrainsMono-Regular'
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings_outlined
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Text(
                                        'Ayarlar',
                                        style: TextStyle(
                                            fontFamily: 'JetBrainsMono-Regular'
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Text(
                                        'Hakkında',
                                        style: TextStyle(
                                            fontFamily: 'JetBrainsMono-Regular'
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(
                                          Icons.exit_to_app_outlined
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Text(
                                          'Çıkış Yap',
                                          style: TextStyle(
                                              fontFamily: 'JetBrainsMono-Regular'
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width*(9/10),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: widget._darkMode ? Color.fromARGB(255,30,30,30) : Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: AutoSizeText(
                      _tags.length > 0 ? 'Fotoğraf İçeren Tüm Etiketler' : 'Fotoğraf İçeren Etiket Mevcut Değil',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontFamily: 'JetBrainsMono-Regular',
                         fontSize: 20
                       ),
                      maxLines: 2,
                    ),
                  ),
                  _searching == false ? _retrievedTags == false ? CircularProgressIndicator() : _listCategories(_tags)
                      :
                  _retrievedTags == false ? CircularProgressIndicator() : _listCategories(_searchItems)
                ],
              ),
            ),
          ),

    );
  }

  void _filterSearchResults(String query) {
    List<Tag> dummySearchList = [];
    dummySearchList.addAll(_duplicateTags);
    if(query.isNotEmpty) {
      List<Tag> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _searchItems.clear();
        _searchItems.addAll(dummyListData);
        print('${dummyListData.length}');
      });
      return;
    } else {
      setState(() {
        _searchItems.clear();
        _searchItems.addAll(_duplicateTags);
      });
    }
  }

  double randomDoubleInRange({double min = 0.0, double max = 1.0}){
    return Random().nextDouble() * (max - min + 1) + min;
  }

  _listCategories(List<Tag> tags){
    List<Widget> _even = [];
    List<Widget> _single = [];

    double width = MediaQuery.of(context).size.width*(5/11);
    double height = MediaQuery.of(context).size.height/5;

    for(int i = 0; i < tags.length; i++){
      //print('_listCategories() for döngüsüne girildi.');
      if(_tagPreviews[tags[i].id.toString()] != null && _tagPreviews[tags[i].id.toString()].isNotEmpty){
        double rndHeight = height*randomDoubleInRange(min: 0.7, max: 1.3);
        i.isEven ?
        _even.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async{
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagDetails(tag: tags[i], photos: _tagPreviews[tags[i].id.toString()], tags: _tags, darkMode: widget._darkMode))).then((value) async{
                _tags.clear();
                await _getTagInfo();
                setState(() {});
              });
            },
            child: Container(
              width: width,
              height: (_tagPreviews[tags[i].id.toString()][0].height ?? 1280)/5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget._darkMode == true ?  Colors.black12 : Colors.grey,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '#${tags[i].name}',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono-Regular',
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: (_tagPreviews[tags[i].id.toString()][0].height ?? 1280)/5 - (height/5.5),//rndHeight - (height/5.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      //color: Colors.grey.shade900,
                      image: DecorationImage(
                          image: _tagPreviews[tags[i].id.toString()] != null && _tagPreviews[tags[i].id.toString()].isNotEmpty ? FileImage(File(_tagPreviews[tags[i].id.toString()][0].imagePath)) : AssetImage('assets/images/empty-gallery-icon.png'),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )):
        _single.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async{
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagDetails(tag: tags[i], photos: _tagPreviews[tags[i].id.toString()], tags: _tags, darkMode: widget._darkMode,))).then((value) async{
                _tags.clear();
                await _getTagInfo();
                setState(() {});
              });
            },
            child: Container(
              width: width,
              height: (_tagPreviews[tags[i].id.toString()][0].height ?? 1280)/5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget._darkMode == true ?  Colors.black12 : Colors.grey,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '#${tags[i].name}',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono-Regular',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*(5/11),
                    height: (_tagPreviews[tags[i].id.toString()][0].height ?? 1280)/5 - (height/5.5),//rndHeight - (height/5.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      //color: Colors.grey.shade900,
                      image: DecorationImage(
                          image: _tagPreviews[tags[i].id.toString()] != null && _tagPreviews[tags[i].id.toString()].isNotEmpty ? FileImage(File(_tagPreviews[tags[i].id.toString()][0].imagePath)) : AssetImage('assets/images/empty-gallery-icon.png'),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));

      }
    }


    return Container(
      //width: MediaQuery.of(context).size.width*(4/5),
      height: MediaQuery.of(context).size.height*(3.6/5),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _single
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _even
            ),
          ],
        ),
      ),
    );
  }

  _showSignOutDialog() {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Çıkış yapılsın mı?', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
            content: Text('Senkronize edilmemiş ögeleri kaybedeceksiniz. Eğer bu ögeler cihazınızda bulunuyorsa yine de bunlara, bu cihazda oturum açtığınız takdirde erişebileceksiniz. Çıkış yapmak istediğinize emin misiniz?', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      _auth.signOut().then((value){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginSignup()));
                      });
                    },
                    child: Text('Evet', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.white : Colors.black),),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('Hayır', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: widget._darkMode == true ? Colors.white : Colors.black,
                      enableFeedback: true,
                      splashFactory: InkSplash.splashFactory
                    ),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }
}
