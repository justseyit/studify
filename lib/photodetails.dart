import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:studify/utils/dbhelper.dart';

import 'models/photo.dart';
import 'models/tag.dart';

// ignore: must_be_immutable
class PhotoDetails extends StatefulWidget {
  List<Photo> _photos = [];
  int _index;
  List<Tag> _tags = [];
  PhotoDetails({Key key, @required List<Photo> photoItems, @required int photoIndex, @required List<Tag> tags}) : super(key: key){
    this._photos = photoItems;
    this._index = photoIndex;
    this._tags = tags;

  }

  @override
  _PhotoDetailsState createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetails> {
  bool _showBar = true;
  Photo _currentPhoto;
  DBHelper _dbHelper;

  PageController _controller;

  List<DropdownMenuItem> _dropDownTags;
  Tag _selectedTag;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPhoto = widget._photos[widget._index];
    _controller = PageController(
      initialPage: widget._index,
    );
    _dbHelper = DBHelper();

    _dropDownTags = _dropDownItemsForTags(widget._tags);

    print('Şu anda gördüğünüz fotonun id\'si: '+widget._photos[widget._index].id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16,16,16),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _showBar ? SizedBox(height: MediaQuery.of(context).size.height/15) : SizedBox(),
            _showBar ? Row(
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
                    'Fotoğraf Detayı',
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'JetBrainsMono-Regular'
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ) : SizedBox(),
            _showBar ? SizedBox(height: MediaQuery.of(context).size.height/15,) : SizedBox(),
            Expanded(
              flex: 9,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PhotoViewGallery.builder(
                  pageController: _controller,
                  enableRotation: true,
                  onPageChanged: (value){
                    print('Şu anda gördüğünüz fotonun id\'si: '+widget._photos[value].id.toString());
                    _currentPhoto = widget._photos[value];
                  },
                  backgroundDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 16,16,16),
                  ),
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: FileImage(File(widget._photos[index].imagePath)),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(tag: widget._photos[index].id),
                      filterQuality: FilterQuality.high,
                      onTapUp: (context, details, controllerValue){
                        setState(() {
                          _showBar = !_showBar;
                        });
                      },
                    );
                  },
                  itemCount: widget._photos.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _showBar ? Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: (){
                          _showMessage(
                            title: 'Fotoğraf Ayrıntısı',
                            message: _getPhotoInfo()
                          );
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: (){
                          _editPhotoDialog();
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () async{
                          _deletePhotoDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }

  setWidgetState(){
    setState(() {

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
                              items: _dropDownTags,
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
                        child: Text('İptal', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.white),),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          if(_selectedTag != null){
                            _currentPhoto.tag = _selectedTag;
                            await _dbHelper.updatePhoto(_currentPhoto);
                            widget._photos.remove(_currentPhoto);
                            //_selectedPhoto = null;
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
                            content: Text('Fotoğraf etiketi güncellendi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.black),),
                          ));
                        },
                        child: Text('Tamam', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
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
                    await _dbHelper.deletePhoto(_currentPhoto.id);
                    setState(() {
                      widget._photos.remove(_currentPhoto);
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Fotoğraf silindi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.black),),
                    ));
                  },
                  child: Text('Evet', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.white),),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Hayır', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
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

  _dropDownItemsForTags(List<Tag> tags) {
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

  _showMessage({@required String title, @required RichText message}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
          content: message,//Text(message, style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
          actions: [
            ButtonBar(
              children: [
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Tamam')),
              ],
            )
          ],
        );
      },
    );
  }

  _getPhotoInfo(){
    return RichText(
      text: TextSpan(
        children: [
          //Photo Name
          TextSpan(
            text: 'Fotoğraf adı: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: _currentPhoto.name,
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //Photo Added DateTime to Local Formatted String
          TextSpan(
            text: '\nEklenme tarihi: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '${_currentPhoto.addedDT.day <= 9 ? '0${_currentPhoto.addedDT.day}':'${_currentPhoto.addedDT.day}'}.${_currentPhoto.addedDT.month <= 9 ? '0${_currentPhoto.addedDT.month}':'${_currentPhoto.addedDT.month}'}.${_currentPhoto.addedDT.year}, ${_currentPhoto.addedDT.hour <= 9 ? '0${_currentPhoto.addedDT.hour}':'${_currentPhoto.addedDT.hour}'}:${_currentPhoto.addedDT.minute <= 9 ? '0${_currentPhoto.addedDT.minute}':'${_currentPhoto.addedDT.minute}'}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //Photo Tag
          TextSpan(
            text: '\nFotoğraf etiketi: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '#${_currentPhoto.tag.name}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //Photo Image Path
          TextSpan(
            text: '\nDosya yolu: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '${_currentPhoto.imagePath}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //Is on Device?
          TextSpan(
            text: '\nCihaza kayıtlı mı: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '${_currentPhoto.isOnDevice == true ? 'Evet':'Hayır'}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //Is on Cloud?
          TextSpan(
            text: '\nBuluta yedeklendi mi: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '${_currentPhoto.isOnCloud == true ? 'Evet':'Hayır'}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
          //When Uploaded?
          TextSpan(
            text: '\nBuluta yedeklenme tarihi: ',
            style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
          ),
          TextSpan(
            text: '${_currentPhoto.isOnCloud == true ? '${_currentPhoto.uploadedDT.day <= 9 ? '0${_currentPhoto.uploadedDT.day}': '${_currentPhoto.uploadedDT.day}'}.${_currentPhoto.uploadedDT.month <= 9 ? '0${_currentPhoto.uploadedDT.month}': '${_currentPhoto.uploadedDT.month}'}.${_currentPhoto.uploadedDT.year}, ${_currentPhoto.uploadedDT.hour <= 9 ? '0${_currentPhoto.uploadedDT.hour}': '${_currentPhoto.uploadedDT.hour}'}:${_currentPhoto.uploadedDT.minute <= 9 ? '0${_currentPhoto.uploadedDT.minute}': '${_currentPhoto.uploadedDT.minute}'}':'-'}',
            style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
          ),
        ]
      ),
    );
    //return 'Fotoğraf adı: ${_currentPhoto.name}\nFotoğrafın eklenme tarihi: ${_currentPhoto.addedDT.day}.${_currentPhoto.addedDT.month}.${_currentPhoto.addedDT.year}, ${_currentPhoto.addedDT.hour}:${_currentPhoto.addedDT.minute}\nFotoğraf etiketi: #${_currentPhoto.tag.name}\nDosya yolu: ${_currentPhoto.imagePath}\nCihaza kayıtlı mı: ${_currentPhoto.isOnDevice == true ? 'Evet':'Hayır'}\nBuluta yedeklendi mi: ${_currentPhoto.isOnCloud == true ? 'Evet':'Hayır'}\nBuluta yedeklenme tarihi: ${_currentPhoto.isOnCloud == true ? '${_currentPhoto.uploadedDT.day}.${_currentPhoto.uploadedDT.month}.${_currentPhoto.uploadedDT.year}, ${_currentPhoto.uploadedDT.hour}:${_currentPhoto.uploadedDT.minute}':'-'}';
  }


}
