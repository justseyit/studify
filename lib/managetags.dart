import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studify/models/tag.dart';
import 'package:studify/tagdetails.dart';
import 'package:studify/utils/dbhelper.dart';

import 'models/photo.dart';

// ignore: must_be_immutable
class ManageTags extends StatefulWidget {
  List<Tag> _tgs;
  Map<String, List<Photo>> _dtMap;
  bool _darkMode;
  ManageTags({Key key, @required tags, @required Map dataMap, @required bool darkMode}) : super(key: key){
    this._tgs = tags;
    this._dtMap = dataMap;
    this._darkMode = darkMode;
  }

  @override
  _ManageTagsState createState() => _ManageTagsState();
}

class _ManageTagsState extends State<ManageTags> with SingleTickerProviderStateMixin{
  bool _visible;
  ScrollController _scrollController;
  DBHelper _dbHelper;
  List<Tag> _tags;
  Tag _selectedTag;
  bool _retrieved;

  var _addTagFormKey = GlobalKey<FormState>();
  var _editTagFormKey = GlobalKey<FormState>();

  double _height = 60.0;
  double _width = 60.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _visible = true;
    _retrieved = true;//false;
    _dbHelper = DBHelper();
    _tags = widget._tgs ?? [];
    /*_dbHelper.getAllTags().then((value){
      for(Map tagMap in value){
        _tags.add(Tag.fromMap(tagMap));
      }
      print('retrieve completed');
      setState(() {
        _retrieved = true;
      });
    });*/
    _scrollController.addListener((){
      if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(_visible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          print("**** $_visible up"); //Move IO away from setState
          setState((){
            _visible = false;
            _height = 0;
            _width = 0;
          });
        }
      } else {
        if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
          if(_visible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            print("**** $_visible down"); //Move IO away from setState
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
      resizeToAvoidBottomInset: false,
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
              backgroundColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : Colors.white,
              foregroundColor: widget._darkMode == true ? Colors.white : Colors.black,
              focusElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              hoverElevation: 0,
              elevation: 0,
              child: Icon(Icons.add_outlined, size: 40,),
              onPressed: (){
                _addTagDialog();
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
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
                    'Etiketleri Yönet',
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
              child: SingleChildScrollView(
                controller: _scrollController,
                child: _retrieved == true ? Column(
                  children: _listAllTags(_tags),
                  /*List.generate(100, (index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _selectActionDialog(Tag(
                            name: 'etiket$index',
                            created: DateTime.now(),
                            updated: null,
                            onDevice: true,
                            onCloud: false
                          ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height/10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/8,
                                height: MediaQuery.of(context).size.width/8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Icon(
                                  Icons.tag_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  'etiket$index',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/20,
                              ),
                              Icon(Icons.arrow_forward_ios_outlined, size: 40,),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),*/
                ) : Center(child: CircularProgressIndicator(),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController _addTagController = TextEditingController();
  TextEditingController _editTagController = TextEditingController();

  _showMessage({@required String title, @required String message}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
          content: Text(message, style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
          actions: [
            ButtonBar(
              children: [
                TextButton(onPressed: (){Navigator.of(context).pop(); setState(() {});}, child: Text('Tamam')),
              ],
            )
          ],
        );
      },
    );
  }
  setWidgetState(){
    setState(() {

    });
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
                      _editTagDialog();
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
                      _deleteTagDialog();
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

  _addTagDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text(
            'Etiket Ekle',
            style: TextStyle(
              fontFamily: 'JetBrainsMono-ExtraBold',
            ),
          ),
          content: Form(
            key: _addTagFormKey,
            child: Container(
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width/3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('#', style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18)),
                      Container(
                        width: MediaQuery.of(context).size.width*(1.2/3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: widget._darkMode == true ? Colors.white : Colors.black
                            ),
                          ),
                        ),
                        child: TextFormField(
                          controller: _addTagController,
                          style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18),
                          cursorColor: widget._darkMode == true ? Colors.white : Colors.black,
                          decoration: InputDecoration(
                              focusColor: widget._darkMode == true ? Colors.white : Colors.black,
                              fillColor: widget._darkMode == true ? Colors.white : Colors.black,
                              hoverColor: widget._darkMode == true ? Colors.white : Colors.black,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero
                          ),
                        ),
                      ),
                    ],
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
                    final validCharacters = RegExp(r'^[a-z0-9&öçşğıü]+$');
                    if(validCharacters.hasMatch(_addTagController.text)){
                      Tag newTag = Tag(name: _addTagController.text, created: DateTime.now(), onDevice: true, onCloud: false);
                      await _dbHelper.addTag(newTag);
                      _dbHelper.getAllTags().then((value){
                        List<Tag> _t = [];
                        for(Map map in value){
                          _t.add(Tag.fromMap(map));
                        }
                        _tags.clear();
                        _tags = List.from(_t);
                        _t = null;
                        setWidgetState();
                      });
                      _tags.add(newTag);
                      Tag tempTag = newTag;
                      _tags[_tags.length-1] = _tags[0];
                      _tags[0] = tempTag;
                      tempTag = null;
                      Navigator.of(context).pop();
                      _addTagController.text = '';
                      setState(() {

                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Etiket kaydedildi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
                        duration: Duration(milliseconds: 1500),
                      ));
                    }else{
                      _showMessage(title: 'Geçersiz Etiket', message: 'Etiketler boşluk, büyük harf veya sembol içeremez. Ayrıca etiketler boş olamaz. Lütfen yalnızca küçük harfleri ve sayıları kullanınız.');
                    }
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
      }
    );
  }

  _editTagDialog(){
    _editTagController.text = _selectedTag.name;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: Text(
                  'Etiket Ekle',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono-ExtraBold',
                  ),
                ),
                content: Form(
                  key: _editTagFormKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height/10,
                    width: MediaQuery.of(context).size.width/3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('#', style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18)),
                            Container(
                              width: MediaQuery.of(context).size.width*(1.2/3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color: widget._darkMode == true ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                controller: _editTagController,
                                style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18),
                                cursorColor: widget._darkMode == true ? Colors.white : Colors.black,
                                decoration: InputDecoration(
                                    focusColor: widget._darkMode == true ? Colors.white : Colors.black,
                                    fillColor: widget._darkMode == true ? Colors.white : Colors.black,
                                    hoverColor: widget._darkMode == true ? Colors.white : Colors.black,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero
                                ),
                              ),
                            ),
                          ],
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
                        child: Text('İptal', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.white : Colors.black,),),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          final validCharacters = RegExp(r'^[a-z0-9&öçşğıü]+$');
                          if(validCharacters.hasMatch(_editTagController.text)){
                            Tag updTag = Tag.withID(id: _selectedTag.id, name: _editTagController.text, created: _selectedTag.creationDT, updated: DateTime.now(), onDevice: _selectedTag.isOnDevice, onCloud: _selectedTag.isOnCloud);
                            for(int i = 0; i < _tags.length; i++){
                              if(_tags[i].id == _selectedTag.id){
                                _tags[i] = updTag;
                                _selectedTag = _tags[i];
                                break;
                              }
                            }

                            await _dbHelper.updateTag(_selectedTag);
                            setState((){

                            });
                            Navigator.of(context).pop();
                            _editTagController.text = '';
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Etiket güncellendi.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.black : Colors.white),),
                              duration: Duration(milliseconds: 1500),
                            ));
                          }else{
                            _showMessage(title: 'Geçersiz Etiket', message: 'Etiketler boşluk, büyük harf veya sembol içeremez. Ayrıca etiketler boş olamaz. Lütfen yalnızca küçük harfleri ve sayıları kullanınız.');
                          }
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

  _deleteTagDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Etiketi Sil', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
          content: Text('Bir etiketi sildiğinizde, o etikete sahip olan fotoğraflar da silinir. #${_selectedTag.name} etiketini ve ilgili fotoğrafları silmek istiyor musunuz?', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
          actions: [
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () async{
                    List<Tag> templist = [];
                    await _dbHelper.deleteTag(_selectedTag.id);
                    List<Photo> p = [];
                    _dbHelper.getPhotosWithTagID([_selectedTag.id]).then((value)async{
                      for(Map map in value){
                        p.add(Photo.fromMap(map));
                      }

                      for(Photo pht in p){
                        await _dbHelper.deletePhoto(pht.id);
                      }
                    });
                    for(Tag tag in _tags){
                      if(tag.id != _selectedTag.id){
                        templist.add(tag);
                      }
                    }
                    _tags.clear();
                    setState(() {
                      _tags = List.from(templist);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Evet', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold', color: widget._darkMode == true ? Colors.white : Colors.black,),),
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

  _listAllTags(List<Tag> tags){
    if(tags != null && tags.length != 0 && tags.isNotEmpty){
      List<Widget> taglist = [];
      for(Tag tag in tags){
        taglist.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            borderRadius: BorderRadius.circular(12),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagDetails(tag: tag, photos: widget._dtMap[tag.id.toString()], tags: _tags, darkMode: widget._darkMode,)));
            },
            onLongPress: (){
              _selectedTag = tag;
              _selectActionDialog();
            },
            child: Container(
              height: MediaQuery.of(context).size.height/10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                  Container(
                    width: MediaQuery.of(context).size.width/8,
                    height: MediaQuery.of(context).size.width/8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                    ),
                    child: Icon(
                      Icons.tag_outlined,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Text(
                      '${tag.name}',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'JetBrainsMono-Regular'
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/20,
                  ),
                  Icon(Icons.arrow_forward_ios_outlined, size: 40,),
                ],
              ),
            ),
          ),
        ));
      }
      return taglist;
    }else{
      return [Center(
        child: Container(
          child: Text(
            'Etiket Mevcut Değil',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'JetBrainsMono-ExtraBold'
            ),
          ),
        ),
      )];
    }
  }
}
