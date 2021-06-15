import 'package:auto_size_text/auto_size_text.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/setting.dart';

class UISettings extends StatefulWidget {
  bool _darkMode;
  UISettings({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  _UISettingsState createState() => _UISettingsState();
}

class _UISettingsState extends State<UISettings> {
  bool _darkMode;
  SharedPreferences _prefs;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getSharedPrefs();
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
                    'Arayüz',
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
                    //Dark Mode
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _darkMode == true ? _prefs.setBool('DarkMode', false) : _prefs.setBool('DarkMode', true);
                          print('Now dark mode value is ${_prefs.getBool('DarkMode')}');
                          setState(() {
                            _darkMode == true ? _darkMode = false : _darkMode = true;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height/7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Icons.bedtime_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'Koyu Mod',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JetBrainsMono-Regular'
                                      ),
                                      maxLines: 2,
                                    ),
                                    AutoSizeText(
                                      'Bu ayarı değiştirdiğinizde, yeni tercihiniz uygulamaya bir sonraki girişinizden itibaren etkin olur.',
                                      style: TextStyle(
                                          fontSize: 5,
                                          fontFamily: 'JetBrainsMono-Regular'
                                      ),
                                      maxLines: 5,
                                    ),
                                  ],
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
                                  child: _darkMode == true ? Container(
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
                    //PhotoShowMode
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
                                    Icons.fit_screen,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/10,),
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: AutoSizeText(
                                    'Fotoğraf Karesi Büyüklüğü',
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
                          children: [
                            //Very Small
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _prefs.setString('PhotoSize', 'verySmall');
                                  setState(() {
                                    Setting.setPhotoSize(PhotoSize.verySmall);
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
                                          Icons.crop_free,
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
                                              'Çok Küçük',
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
                                          child: Setting.currentPhotoSize == PhotoSize.verySmall ? Container(
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
                            //Small
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _prefs.setString('PhotoSize', 'small');
                                  setState(() {
                                    Setting.setPhotoSize(PhotoSize.small);
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
                                          Icons.crop_free,
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
                                              'Küçük',
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
                                          child: Setting.currentPhotoSize == PhotoSize.small ? Container(
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
                            //Medium
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _prefs.setString('PhotoSize', 'medium');
                                  setState(() {
                                    Setting.setPhotoSize(PhotoSize.medium);
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
                                          Icons.crop_free,
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
                                              'Orta',
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
                                          child: Setting.currentPhotoSize == PhotoSize.medium ? Container(
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
                            //Large
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _prefs.setString('PhotoSize', 'large');
                                  setState(() {
                                    Setting.setPhotoSize(PhotoSize.large);
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
                                          Icons.crop_free,
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
                                              'Büyük',
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
                                          child: Setting.currentPhotoSize == PhotoSize.large ? Container(
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
                            //Very Large
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                borderRadius: BorderRadius.circular(12),
                                onTap: (){
                                  _prefs.setString('PhotoSize', 'veryLarge');
                                  setState(() {
                                    Setting.setPhotoSize(PhotoSize.veryLarge);
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
                                          Icons.crop_free,
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
                                              'Çok Büyük',
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
                                          child: Setting.currentPhotoSize == PhotoSize.veryLarge ? Container(
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

  _getSharedPrefs() async {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;

      if(_prefs.containsKey('DarkMode')){
        setState(() {
          _darkMode = _prefs.getBool('DarkMode');
        });
      }else{
        _prefs.setBool('DarkMode', true);
        setState(() {
          _darkMode = true;
        });
      }

      if(_prefs.containsKey('PhotoSize')){
        setState(() {
          switch(_prefs.getString('PhotoSize')){
            case 'verySmall':
              Setting.currentPhotoSize = PhotoSize.verySmall;
              break;

            case 'small':
              Setting.currentPhotoSize = PhotoSize.small;
              break;

            case 'medium':
              Setting.currentPhotoSize = PhotoSize.medium;
              break;

            case 'large':
              Setting.currentPhotoSize = PhotoSize.large;
              break;

            case 'veryLarge':
              Setting.currentPhotoSize = PhotoSize.veryLarge;
              break;

            default:
              Setting.currentPhotoSize = PhotoSize.medium;
              break;
          }
        });
      }else{
        _prefs.setString('PhotoSize', 'medium');
        setState(() {
          Setting.currentPhotoSize = PhotoSize.medium;
        });
      }

    });
  }

}
