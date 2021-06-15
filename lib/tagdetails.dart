import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:studify/models/setting.dart';
import 'package:studify/photodetails.dart';
import 'package:studify/utils/dbhelper.dart';
import 'package:uuid/uuid.dart';

import 'models/photo.dart';
import 'models/tag.dart';

// ignore: must_be_immutable
class TagDetails extends StatefulWidget {
  Tag _tag;
  List<Photo> _photos;
  List<Tag> _tags;
  bool _darkMode;
  TagDetails({Key key, @required Tag tag, @required List<Photo> photos, @required List<Tag> tags, @required bool darkMode}) : super(key: key){
    this._tag = tag;
    this._photos = photos;
    this._tags = tags;
    this._darkMode = darkMode;
  }

  @override
  _TagDetailsState createState() => _TagDetailsState();
}

class _TagDetailsState extends State<TagDetails> with SingleTickerProviderStateMixin{

  final ImagePicker _picker = ImagePicker();
  File _image;

  //List<Tag> _tags;

  DBHelper _dbHelper;

  Photo _selectedPhoto;
  Tag _selectedTag;
  List<DropdownMenuItem> _ddTags;
  //List<Photo> _photos;

  bool _visible;
  ScrollController _scrollController;

  double _height = 60.0;
  double _width = 60.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHelper = DBHelper();
    _ddTags = [];
    //_tags = widget._tgs ?? [];
    //_photos = widget._pht ?? [];

    _ddTags = _ddItemsForTags(widget._tags);
    /*_dbHelper.getAllTags().then((value) async{
      for(Map tagMap in value){
        _tags.add(Tag.fromMap(tagMap));
      }
      _ddTags = _ddItemsForTags(_tags);
      //_photos = _fakePhotoData();

      /*for(Photo photo in _photos){
        _dbHelper.addPhoto(photo).then((value){
          print('added to db');
        });
      }*/
    });*/

    /*_dbHelper.getPhotosWithTagID([widget._tag.id]).then((value){
      for(Map photoMap in value){
        _photos.add(Photo.fromMap(photoMap));
        print('${widget._tag.name} etiketi için foto geldi');
      }
      print('for döngüsünden çıkıldı.');
      setState(() {

      });
    });*/

    //_tags = _fakeTagData();


    //_dbHelper.deleteAllOfThePhotoTable();
    //_dbHelper.deleteAllOfTheTagTable();

    /*for(Tag tag in _tags){
      _dbHelper.addTag(tag);
    }*/


    _scrollController = ScrollController();
    _visible = true;
    _scrollController.addListener((){
      if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(_visible == true) {
          print("**** $_visible up");
          setState((){
            _visible = false;
            _height = 0;
            _width = 0;
          });
        }
      } else {
        if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
          if(_visible == false) {
            print("**** $_visible down");
            setState((){
              _visible = true;
              _width = 60.0;
              _height = 60.0;
            });
          }
        }
      }});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
      floatingActionButton: AnimatedSize(
        duration: Duration(microseconds: 500),
        //curve: Curves.easeIn,
        vsync: this,
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2)
            ),
            child: FloatingActionButton(
              backgroundColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
              foregroundColor: widget._darkMode == true ? Colors.white : Colors.black,
              focusElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              elevation: 0,
              child: Icon(Icons.add_outlined, size: 40,),
              onPressed: (){
                _selectAddActionDialog();
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  iconSize: 40,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                Container(
                  width: MediaQuery.of(context).size.width*(3.5/5),
                  child: AutoSizeText(
                    '#${widget._tag.name}',
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'JetBrainsMono-Regular'
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/15,),
            Container(
              height: MediaQuery.of(context).size.height*(3.8/5),
              width: MediaQuery.of(context).size.width*(9/10),
              child: widget._photos != null && widget._photos.length > 0 ? GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Setting.photoCrossAxisCount ?? 3,
                ),
                controller: _scrollController,
                //crossAxisCount: Setting.photoCrossAxisCount ?? 3,
                children: _listPhotos(widget._photos)
              ) : Container(
                height: MediaQuery.of(context).size.height*(3.8/5),
                width: MediaQuery.of(context).size.width*(9/10),
                child: Center(
                  child: Text(
                    'Burada hiç fotoğraf bulamadık.',
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'JetBrainsMono-Regular'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setWidgetState(){
    setState(() {

    });
  }

  /*_fakeTagData(){
    List<Tag> tags = [];
    for(int i = 0; i<10; i++){
      tags.add(Tag(
        name: 'tag$i',
        created: DateTime.now(),
        onDevice: true,
        onCloud: false,
      ));
    }
    return tags;
  }

  _fakePhotoData(){
    List<Photo> photos = [];
    for(Tag tag in widget._tags){
      for(int i = 0; i < 10; i++){
        photos.add(Photo(
          name: 'photo-$i for tag #${tag.name}',
          imagePath: 'assets/images/test.jpg',
          tag: tag,
          added: DateTime.now(),
          onCloud: false,
          onDevice: true,
        ));
        print('photo-$i for tag #${tag.name}');
      }
    }
    return photos;
  }*/

  _listPhotos(List<Photo> photos){
    List<Widget> photoWidgetList = [];
    for(int i = 0; i < photos.length; i++){
      photoWidgetList.add(Padding(
        padding: const EdgeInsets.all(0.0),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotoDetails(photoItems: widget._photos, photoIndex: i, tags: widget._tags,))).then((value){
              setState(() {

              });
            });
          },
          onLongPress: (){
            _selectedPhoto = widget._photos[i];
            _selectActionDialog();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: widget._darkMode == true ? Colors.black : Colors.white, width: 0.2),
              image: DecorationImage(
                image: FileImage(File('${widget._photos[i].imagePath}')),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ));
    }
    return photoWidgetList;
  }

  _selectActionDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height/4,
              child: Column(
                children: [
                  //Edit
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(12),
                      onTap: (){
                        Navigator.of(context).pop();
                        _editPhotoDialog();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              height: MediaQuery.of(context).size.width/8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width*(1/3),
                              child: Text(
                                'Düzenle',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMono-Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Delete
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(12),
                      onTap: (){
                        Navigator.of(context).pop();
                        _deletePhotoDialog();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              height: MediaQuery.of(context).size.width/8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width*(1/3),
                              child: Text(
                                'Sil',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMono-Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _selectAddActionDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height/4,
              child: Column(
                children: [
                  //Gallery
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(12),
                      onTap: (){
                        Navigator.of(context).pop();
                        _getImageFromGallery();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              height: MediaQuery.of(context).size.width/8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black
                                ),
                              ),
                              child: Icon(
                                Icons.photo_size_select_actual_outlined,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width*(1/3),
                              child: Text(
                                'Galeriden Ekle',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMono-Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Camera
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(12),
                      onTap: (){
                        Navigator.of(context).pop();
                        _getImageFromCamera();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width/8,
                              height: MediaQuery.of(context).size.width/8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/20,),
                            Container(
                              width: MediaQuery.of(context).size.width*(1/3),
                              child: Text(
                                'Kameradan Ekle',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMono-Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _getImageFromGallery() async {
    var uuid = Uuid();
    _picker.getImage(source: ImageSource.gallery).then((value){
      if (value != null) {
        _image = File(value.path);
        _selectedPhoto =Photo(name: '${uuid.v1()}', imagePath: _image.path, tag: widget._tag, added: DateTime.now(), onDevice: true, onCloud: false);
        _dbHelper.addPhoto(_selectedPhoto);
        _dbHelper.getPhotosWithTagID([widget._tag.id]).then((value){
          widget._photos.clear();
          for(Map map in value){
            widget._photos.add(Photo.fromMap(map));
          }
          setState(() {

          });
        });
      } else {
        print('No image selected.');
      }
    });
  }

  _getImageFromCamera() async {
    var uuid = Uuid();
    _picker.getImage(source: ImageSource.camera).then((value){
      if (value != null) {
        _image = File(value.path);
        _selectedPhoto =Photo(name: '${uuid.v1()}', imagePath: _image.path, tag: widget._tag, added: DateTime.now(), onDevice: true, onCloud: false);
        _dbHelper.addPhoto(_selectedPhoto);
        _dbHelper.getPhotosWithTagID([widget._tag.id]).then((value){
          widget._photos.clear();
          for(Map map in value){
            widget._photos.add(Photo.fromMap(map));
          }
          setState(() {

          });
        });
      } else {
        print('No image selected.');
      }
    });
  }

  _editPhotoDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: Text(
                  'Fotoğraf Ayrıntısını Düzenle',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono-ExtraBold',
                  ),
                ),
                content: Form(
                  child: Container(
                    height: MediaQuery.of(context).size.height/10,
                    width: MediaQuery.of(context).size.width/3,
                    child: Column(
                      children: [
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                "Yeni Bir etiket seçin.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "JetBrainsMono-Regular",
                                ),
                              ),
                              value: _selectedTag,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTag = value;
                                });
                              },
                              items: _ddTags,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('İptal', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.white : Colors.black),),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          if(_selectedTag != null){
                            _selectedPhoto.tag = _selectedTag;
                            await _dbHelper.updatePhoto(_selectedPhoto);
                            widget._photos.remove(_selectedPhoto);
                            _selectedPhoto = null;
                          }
                          /*List<Widget> tempPhotoList = [];
                          for(Widget wid in _phwidget){
                            if(wid != _selectedPhwid){
                              tempPhotoList.add(wid);
                            }
                          }
                          _phwidget.clear();
                          _phwidget = List.from(tempPhotoList);
                          tempPhotoList = null;*/
                          setWidgetState();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Fotoğraf etiketi güncellendi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
                          ));
                        },
                        child: Text('Tamam', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
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
            },
          );
        }
    );
  }

  _deletePhotoDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Fotoğrafı Sil', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
          content: Text('Seçili fotoğrafı silmek istiyor musunuz?', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
          actions: [
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () async{
                    List<Photo> templist = [];
                    await _dbHelper.deletePhoto(_selectedPhoto.id);
                    setState(() {
                      widget._photos.remove(_selectedPhoto);
                      _selectedPhoto = null;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Fotoğraf silindi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
                    ));
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
      },
    );
  }

  _ddItemsForTags(List<Tag> tags) {
    List<DropdownMenuItem> listTag = [];

    for (Tag tag in tags) {
      if (tag != null) {
        listTag.add(DropdownMenuItem(
          value: tag,
          child: Text(
            '${tag.name}',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "JetBrainsMono-Regular",
            ),
          ),
        ));
      }
    }
    return listTag;
  }

}
