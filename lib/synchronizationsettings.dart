import 'package:auto_size_text/auto_size_text.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/utils/dbhelper.dart';

import 'models/tag.dart';

//ignore:must_be_immutable
class SyncSettings extends StatefulWidget {
  bool _darkMode;
  SyncSettings({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  _SyncSettingsState createState() => _SyncSettingsState();
}

class _SyncSettingsState extends State<SyncSettings> {
  SharedPreferences _prefs;
  bool _autoSync;
  bool _useMobile;
  bool _useWifi;
  Map<String, bool> _tagsToSync;
  List<Tag> _tags;
  DBHelper _helper;
  bool _retrievedTags;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tags = [];
    _tagsToSync = Map<String, bool>();
    _helper = DBHelper();
    _retrievedTags = false;
    _getSharedPrefsAndTags();

  }

  _getTags(){
    _helper.getAllTags().then((value){
      for(Map tagMap in value){
        _tags.add(Tag.fromMap(tagMap));
        if(!_prefs.containsKey(Tag.fromMap(tagMap).id.toString())){
          _prefs.setBool(Tag.fromMap(tagMap).id.toString(), true);
        }
      }
      for(Tag tag in _tags){
        if(_prefs.containsKey(tag.id.toString())){
          _tagsToSync[tag.id.toString()] = _prefs.getBool(tag.id.toString());
        }
      }

      setState(() {
        _retrievedTags = true;
      });

      if(_prefs.containsKey('UseMobile')){
        setState(() {
          _useMobile = _prefs.getBool('UseMobile');
        });
      }
      else{
        setState(() {
          _useMobile = false;
        });
        _prefs.setBool('UseMobile', false);
      }

      if(_prefs.containsKey('UseWifi')){
        setState(() {
          _useWifi = _prefs.getBool('UseWifi');
        });
      }
      else{
        setState(() {
          _useWifi = true;
        });
        _prefs.setBool('UseWifi', true);
      }

      if(_prefs.containsKey('AutoSync')){
        setState(() {
          _autoSync = _prefs.getBool('AutoSync');
        });
      }
      else{
        setState(() {
          _autoSync = true;
        });
        _prefs.setBool('AutoSync', true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/15,),
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
                    'Senkronizasyon',
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*(3.9/5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Auto Sync
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _autoSync == true ? _prefs.setBool('AutoSync', false) : _prefs.setBool('AutoSync', true);
                          setState(() {
                            _autoSync == true ? _autoSync = false : _autoSync = true;
                          });
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
                                  Icons.access_time_sharp,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  'Otomatik Senkronizasyon',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/20,),
                              Container(
                                width: MediaQuery.of(context).size.width/12,
                                height: MediaQuery.of(context).size.width/12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: _autoSync == true ? Container(
                                    width: MediaQuery.of(context).size.width/25,
                                    height: MediaQuery.of(context).size.width/25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: widget._darkMode == true ? Colors.white : Colors.black,
                                      //border: Border.all(color: Colors.red),
                                    ),
                                  ):Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Tags to Sync ExpansionTileCard
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ExpansionTileCard(
                          borderRadius: BorderRadius.circular(12),
                          baseColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                          expandedColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                          elevation: 0,
                          contentPadding: EdgeInsets.zero,
                          expandedTextColor: widget._darkMode == true ? Colors.white : Colors.black,
                          shadowColor: widget._darkMode == true ? Colors.white : Colors.black,
                          trailing: Icon(Icons.keyboard_arrow_down_outlined, size: 35, color: widget._darkMode == true ? Colors.white : Colors.black,),
                          animateTrailing: true,
                          title: Container(
                            height: MediaQuery.of(context).size.height/12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width/10.5,),
                                Container(
                                  width: MediaQuery.of(context).size.width/8,
                                  height: MediaQuery.of(context).size.width/8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                                  ),
                                  child: Icon(
                                    Icons.tag,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/10,),
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: AutoSizeText(
                                    'Senkronize Edilecek Etiketler',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'JetBrainsMono-Regular'
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: _retrievedTags == true ? _listTagsToSync(_tags) : [SizedBox()],
                        ),
                      ),
                    ),
                    //Tags to Sync
                    /*Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){},
                        child: Container(
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
                                  Icons.tag,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width/2,
                                    child: AutoSizeText(
                                      'Senkronize Edilecek Etiketler',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JetBrainsMono-Regular'
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/20,),
                              Icon(Icons.keyboard_arrow_down_outlined, size: 35,)
                            ],
                          ),
                        ),
                      ),
                    ),*/
                    //Data Usage
                    /*Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){},
                        child: Container(
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
                                  Icons.perm_data_setting_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width/2,
                                    child: AutoSizeText(
                                      'Veri Kullanımı Ayarları',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JetBrainsMono-Regular'
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/20,),
                              Icon(Icons.keyboard_arrow_down_outlined, size: 35,)
                            ],
                          ),
                        ),
                      ),
                    ),*/
                    //Data Usage ExpansionTileCard
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ExpansionTileCard(
                          baseColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                          expandedColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                          elevation: 0,
                          contentPadding: EdgeInsets.zero,
                          expandedTextColor: widget._darkMode == true ? Colors.white : Colors.black,
                          shadowColor: widget._darkMode == true ? Colors.white : Colors.black,
                          trailing: Icon(Icons.keyboard_arrow_down_outlined, size: 35, color: widget._darkMode == true ? Colors.white : Colors.black,),
                          animateTrailing: true,
                          title: Container(
                            height: MediaQuery.of(context).size.height/12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width/10.5,),
                                Container(
                                  width: MediaQuery.of(context).size.width/8,
                                  height: MediaQuery.of(context).size.width/8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                                  ),
                                  child: Icon(
                                    Icons.perm_data_setting_outlined,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      child: AutoSizeText(
                                        'Veri Kullanımı Ayarları',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'JetBrainsMono-Regular'
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          children: [
                            //Use Mobile Data
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _useMobile == true ? _prefs.setBool('UseMobile', false) : _prefs.setBool('UseMobile', true);
                                  setState(() {
                                    _useMobile == true ? _useMobile = false : _useMobile = true;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/10,
                                        height: MediaQuery.of(context).size.width/10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                                        ),
                                        child: Icon(
                                          Icons.signal_cellular_alt_outlined,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/20,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/3,
                                            child: Text(
                                              'Mobil Veri Kullan',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'JetBrainsMono-Regular'
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Container(
                                        width: MediaQuery.of(context).size.width/15,
                                        height: MediaQuery.of(context).size.width/15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3),
                                          child: _useMobile == true ? Container(
                                            width: MediaQuery.of(context).size.width/40,
                                            height: MediaQuery.of(context).size.width/40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: widget._darkMode == true ? Colors.white : Colors.black,
                                              //border: Border.all(color: Colors.red),
                                            ),
                                          ):Container(),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //Use Wifi Data
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _useWifi == true ? _prefs.setBool('UseWifi', false) : _prefs.setBool('UseWifi', true);
                                  setState(() {
                                    _useWifi == true ? _useWifi = false : _useWifi = true;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/10,
                                        height: MediaQuery.of(context).size.width/10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                                        ),
                                        child: Icon(
                                          Icons.wifi_outlined,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/20,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width/3,
                                            child: Text(
                                              'WI-FI Kullan',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'JetBrainsMono-Regular'
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                      Container(
                                        width: MediaQuery.of(context).size.width/15,
                                        height: MediaQuery.of(context).size.width/15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3),
                                          child: _useWifi == true ? Container(
                                            width: MediaQuery.of(context).size.width/40,
                                            height: MediaQuery.of(context).size.width/40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: widget._darkMode == true ? Colors.white : Colors.black,
                                              //border: Border.all(color: Colors.red),
                                            ),
                                          ):Container(),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/40,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getSharedPrefsAndTags() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      _getTags();

    });
  }

  _listTagsToSync(List<Tag> tags){
    List<Widget> tagWidgets = [];
    for(Tag tag in tags){
      tagWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(12),
          onTap: (){
            _tagsToSync[tag.id.toString()] == true ? _prefs.setBool(tag.id.toString(), false) : _prefs.setBool(tag.id.toString(), true);
            setState(() {
              _tagsToSync[tag.id.toString()] == true ? _tagsToSync[tag.id.toString()] = false : _tagsToSync[tag.id.toString()] = true;
            });
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/10,
                  height: MediaQuery.of(context).size.width/10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                  ),
                  child: Icon(
                    Icons.tag,
                    size: 20,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width/20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      child: Text(
                        '${tag.name}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'JetBrainsMono-Regular'
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width/40,),
                Container(
                  width: MediaQuery.of(context).size.width/15,
                  height: MediaQuery.of(context).size.width/15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: _tagsToSync[tag.id.toString()] ? Container(
                      width: MediaQuery.of(context).size.width/40,
                      height: MediaQuery.of(context).size.width/40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: widget._darkMode == true ? Colors.white : Colors.black,
                        //border: Border.all(color: Colors.red),
                      ),
                    ):Container(),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width/40,),
              ],
            ),
          ),
        ),
      ));
    }
    return tagWidgets;
  }
}
