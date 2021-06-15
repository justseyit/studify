import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifSettings extends StatefulWidget {
  bool _darkMode;
  NotifSettings({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  _NotifSettingsState createState() => _NotifSettingsState();
}

class _NotifSettingsState extends State<NotifSettings> {
  bool _progressNotif;
  bool _completeNotif;
  bool _problemNotif;
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
                    'Bildirimler',
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
                    //Sync Progress Notification
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _progressNotif == true ? _prefs.setBool('ProgressNotif', false) : _prefs.setBool('ProgressNotif', true);
                          setState(() {
                            _progressNotif ? _progressNotif = false : _progressNotif = true;
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
                                  Icons.sync_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: AutoSizeText(
                                  'Senkronizasyon İlerlemesi Bildirimi',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 2,
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
                                  child: _progressNotif == true ? Container(
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
                    //Sync Completed Notification
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _completeNotif == true ? _prefs.setBool('CompleteNotif', false) : _prefs.setBool('CompleteNotif', true);
                          setState(() {
                            _completeNotif ? _completeNotif = false : _completeNotif = true;
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
                                  Icons.published_with_changes_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: AutoSizeText(
                                  'Senkronizasyon Tamamlandı Bildirimi',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 2,
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
                                  child: _completeNotif == true ? Container(
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
                    //Sync Problem Notification
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          _problemNotif == true ? _prefs.setBool('ProblemNotif', false) : _prefs.setBool('ProblemNotif', true);
                          setState(() {
                            _problemNotif == true ? _problemNotif = false : _problemNotif = true;
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
                                  Icons.sync_problem_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: AutoSizeText(
                                  'Senkronizasyon Problemi Bildirimi',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 2,
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
                                  child: _problemNotif == true ? Container(
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

      if(_prefs.containsKey('ProgressNotif')){
        setState(() {
          _progressNotif = _prefs.getBool('ProgressNotif');
        });
      }else{
        _prefs.setBool('ProgressNotif', true);
        setState(() {
          _progressNotif = true;
        });
      }

      if(_prefs.containsKey('ProblemNotif')){
        setState(() {
          _problemNotif = _prefs.getBool('ProblemNotif');
        });
      }else{
        _prefs.setBool('ProblemNotif', true);
        setState(() {
          _problemNotif = true;
        });
      }

      if(_prefs.containsKey('CompleteNotif')){
        setState(() {
          _completeNotif = _prefs.getBool('CompleteNotif');
        });
      }else{
        _prefs.setBool('CompleteNotif', true);
        setState(() {
          _completeNotif = true;
        });
      }
    });
  }
}
