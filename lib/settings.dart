import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studify/accountsettings.dart';
import 'package:studify/notificationsettings.dart';
import 'package:studify/synchronizationsettings.dart';
import 'package:studify/uisettings.dart';

import 'about.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Settings extends StatefulWidget {
  bool _darkMode;
  Settings({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                Text(
                  'Ayarlar',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'JetBrainsMono-Regular'
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/15,),
            //Account Settings Title
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                  Text(
                    'Hesap',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'JetBrainsMono-Regular'
                    ),
                  ),
                ],
              ),
            ),
            //Account Settings
            InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(12),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccSettings(darkMode: widget._darkMode))).then((value){
                  setState(() {

                  });
                });
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/10,),
                    CircleAvatar(
                      radius: 35,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_auth.currentUser.photoURL ?? 'https://github.com/seyitahmetgkc/lessonsapi/raw/master/user64px.png'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: (MediaQuery.of(context).size.width/10)-(MediaQuery.of(context).size.width*(50/1080)),),
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              (_auth.currentUser != null) ? _auth.currentUser.displayName != null ? '${_auth.currentUser.displayName}' : 'Kullanıcı' : 'Kullanıcı',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'JetBrainsMono-Regular'
                              ),
                            ),
                          ),
                          Text(
                            'Profili düzenle',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'JetBrainsMono-Regular',
                              color: Theme.of(context).textTheme.caption.color
                            ),
                          ),
                        ],
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
            SizedBox(height: MediaQuery.of(context).size.height/15,),
            //Other Settings Title
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                  Text(
                    'Diğer Ayarlar',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'JetBrainsMono-Regular'
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height/2.2,
                child: Column(
                  children: [
                    //Notification Settings
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotifSettings(darkMode: widget._darkMode)));
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
                                  Icons.notifications_none_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  'Bildirimler',
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
                    ),
                    //Synchronization Settings
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SyncSettings(darkMode: widget._darkMode)));
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
                                child: Text(
                                  'Senkronizasyon',
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
                    ),
                    //UI Settings
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UISettings(darkMode: widget._darkMode)));
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
                                  Icons.color_lens_outlined,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  'Arayüz',
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
                    ),
                    //About
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => About(darkMode: widget._darkMode)));
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
                                  Icons.info_outline,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  'Hakkında',
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
}
