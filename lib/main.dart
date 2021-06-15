import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/models/tag.dart';
import 'package:studify/signinsignup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studify/utils/dbhelper.dart';
import 'homepage.dart';
import 'models/photo.dart';
import 'models/receivednotification.dart';
import 'models/setting.dart';


FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseStorage _storage = FirebaseStorage.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

SharedPreferences _prefs; //Shared Preferences'a erişmek için
DBHelper _dbHelper = DBHelper(); //Veritabanına erişmek için
//List<Tag> _tags = [];
//List<Photo> _photos = [];
bool _darkMode; //Koyu mod bilgisini tutmak için
bool _progressNotif; //Fotoğraf yedeklemesi ilerlemesi bildiriminin ayarı için
bool _completeNotif; //Yedekleme tamamlandı bildiriminin ayarı için
bool _problemNotif; //Yedekleme problemi bildiriminin ayarı için
String _photoSize; //Fotoğraf karesi boyutu ayarı için
bool _autoSync; //Otomatik senkronizasyon ayarı için
bool _useMobile; //Mobil veri ayarı için
bool _useWifi; //Kablosuz ayarı için
Map<String, bool> _tagsToSync; //Senkronize edilecek etiketler için

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
String selectedNotificationPayload;
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  _getSharedPrefs();


  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

  if (notificationAppLaunchDetails.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  if(_autoSync == true) _checkAndSync();
  runApp(Phoenix(child: MyApp()));
}


_checkAndSync() async{
  print('check and sync was executed');
  _getSharedPrefs();
  var connectivityResult;// = await (Connectivity().checkConnectivity());
  Connectivity().checkConnectivity().then((value){
    connectivityResult = value;
    if(_useMobile == true && _useWifi == true){
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        _getTagsFromDB().then((tags){
          _getPhotosFromDB().then((photos){
            _syncPhotosAndTags(photos, tags);
          });
        });
      }
    }else if(_useWifi == true && _useMobile == false){
      if(connectivityResult == ConnectivityResult.wifi){
        _getTagsFromDB().then((tags){
          _getPhotosFromDB().then((photos){
            _syncPhotosAndTags(photos, tags);
          });
        });
      }
    }else if(_useMobile == true && _useWifi == false){
      if(connectivityResult == ConnectivityResult.mobile){
        _getTagsFromDB().then((tags){
          _getPhotosFromDB().then((photos){
            _syncPhotosAndTags(photos, tags);
          });
        });
      }
    }else{
      //Do nothing.
    }
  });
}

_showNotification({@required String text, @required String contentTitle, @required String summaryText, @required String previewTitle, @required String previewText}) async {
  BigTextStyleInformation btsi = BigTextStyleInformation(
    text,
    htmlFormatBigText: true,
    contentTitle: contentTitle,
    htmlFormatContentTitle: true,
    summaryText: summaryText,
    htmlFormatSummaryText: true,
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('0', 'com.chainbreak.studify', 'studify',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: btsi,
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    previewTitle,
    previewText,
    //RepeatInterval.everyMinute,
    //_nextInstanceOfDT('00','21'),
    platformChannelSpecifics,
    //payload: 'item x',
    //androidAllowWhileIdle: true,
    //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //matchDateTimeComponents: DateTimeComponents.time,
  );
}

_syncPhotosAndTags(List<Photo> photos, List<Tag> tags) async{
  List<Tag> tagsToSync = [];
  List<Photo> photosToSync = [];
  List<Map> mapList = [];
  for(int j = 0; j < tags.length; j++){
    if(_tagsToSync[tags[j].id.toString()] == true) tagsToSync.add(tags[j]);
    mapList = await _dbHelper.getPhotosWithTagID([tags[j].id]);
    for(Map map in mapList){
      Photo photo = Photo.fromMap(map);
      if(photo.isOnCloud == false){
        photosToSync.add(photo);
      }
    }
  }

  for(int i = 0; i<photos.length; i++){
    if(tagsToSync.contains(photos[i].tag) && photos[i].isOnCloud == false) photosToSync.add(photos[i]);
  }
  try {
    if(photosToSync != null &&  photosToSync.isNotEmpty){
      for(int k = 0; k < photosToSync.length; k++){
        var ref = _storage.ref().child('UserFiles').child('${_auth.currentUser.uid}').child('UploadedPhotos').child('${photosToSync[k].name}');
        ref.putFile(File(photosToSync[k].imagePath)).then((value) async{
          String photoLink = await value.ref.getDownloadURL();
          print(photoLink);
          _firestore.collection('users').doc('${_auth.currentUser.uid}').collection('photos').doc('${photosToSync[k].name}').set(photosToSync[k].toMap(), SetOptions(merge: true));
          _firestore.collection('users').doc('${_auth.currentUser.uid}').collection('photos').doc('${photosToSync[k].name}').set({'downloadLink':'$photoLink'}, SetOptions(merge: true));
          if(photosToSync[k].tag.isOnCloud == false) _firestore.collection('users').doc('${_auth.currentUser.uid}').collection('tags').doc('${photosToSync[k].tag.name}').set(photosToSync[k].tag.toMap(), SetOptions(merge: true));
          photosToSync[k].isOnCloud = true;
          photosToSync[k].tag.isOnCloud = true;
          _firestore.collection('users').doc('${_auth.currentUser.uid}').collection('photos').doc('${photosToSync[k].name}').set({'onCloud': 1}, SetOptions(merge: true));
          _firestore.collection('users').doc('${_auth.currentUser.uid}').collection('photos').doc('${photosToSync[k].name}').set({'uploadedDT': DateTime.now()}, SetOptions(merge: true));
          await _dbHelper.updatePhoto(photosToSync[k]);
          await _dbHelper.updateTag(photosToSync[k].tag);
          if(_progressNotif == true) _showProgressNotification(photosToSync.length-1, k);
          if(k == photosToSync.length-1){
            if(_completeNotif == true) _showNotification(text: 'Senkronizasyon başarıyla tamamlandı.', contentTitle: 'Senkronizasyon Tamamlandı', summaryText: 'Senkronizasyon Tamamlandı', previewTitle: 'Senkronizasyon Tamamlandı', previewText: 'Senkronizasyon tamamlandı.');
          }
        });
      }
      print('sync şartlı çalıştı.');
    }
    print('sync çalıştı.');
  }catch (e) {
    if(_problemNotif == true) _showNotification(text: 'Senkronizasyon sırasında bir hata oluştu.\nHata kodu: ${e.toString()}', contentTitle: 'Senkronizasyon Hatası', summaryText: 'Senkronizasyon Hatası', previewTitle: 'Senkronizasyon Hatası', previewText: 'Senkronizasyon sırasında bir hata oluştu.');
  }
}

_getSharedPrefs(){
SharedPreferences.getInstance().then((value){
  _prefs = value;
  if(_prefs.containsKey('ProgressNotif')){
    _progressNotif = _prefs.getBool('ProgressNotif');
  }else{
    _progressNotif = true;
    _prefs.setBool('ProgressNotif', true);
  }

  if(_prefs.containsKey('ProblemNotif')){
    _problemNotif = _prefs.getBool('ProblemNotif');
  }else{
    _problemNotif = true;
    _prefs.setBool('ProblemNotif', true);
  }

  if(_prefs.containsKey('CompleteNotif')){
    _completeNotif = _prefs.getBool('CompleteNotif');
  }else{
    _completeNotif = true;
    _prefs.setBool('CompleteNotif', true);
  }

  if(_prefs.containsKey('DarkMode')){
    _darkMode = _prefs.getBool('DarkMode');
  }else{
    _darkMode = true;
    _prefs.setBool('DarkMode', true);
  }

  if(_prefs.containsKey('UseMobile')){
    _useMobile = _prefs.getBool('UseMobile');
  }
  else{
    _useMobile = false;
    _prefs.setBool('UseMobile', false);
  }

  if(_prefs.containsKey('UseWifi')){
    _useWifi = _prefs.getBool('UseWifi');
  }
  else{
    _useWifi = true;
    _prefs.setBool('UseWifi', true);
  }

  if(_prefs.containsKey('AutoSync')){
    _autoSync = _prefs.getBool('AutoSync');
  }
  else{

    _autoSync = true;
    _prefs.setBool('AutoSync', true);
  }

  if(_prefs.containsKey('PhotoSize')){
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
  }else{
    _prefs.setString('PhotoSize', 'medium');
    Setting.currentPhotoSize = PhotoSize.medium;
  }
  });
}

_showProgressNotification(int maxValue, int currentValue) async {
  int maxProgress = maxValue;
  /*for (int i = 0; i <= maxProgress; i++) {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('1', '1',
          'StudifyProgress',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: i
      );
      final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Senkorizasyon Sürüyor',
          'Verilerinizi eşitliyoruz...',
          platformChannelSpecifics,
          payload: 'item x'
      );
    });
  }*/
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('1', '1',
      'StudifyProgress',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: currentValue,
  );
  final NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'Senkorizasyon Sürüyor',
      'Verilerinizi eşitliyoruz...',
      platformChannelSpecifics,
      payload: 'item x'
  );
}

Future<List<Photo>> _getPhotosFromDB() async{
  print('_getPhotosFromDB() was executed.');
  List <Photo> _photos = [];
  List <Map> _tagMaps = [];
  _tagMaps = await _dbHelper.getAllPhotos();
  for(Map map in _tagMaps){
    _photos.add(Photo.fromMap(map));
  }
  return _photos;
  /*_dbHelper.getAllPhotos().then((value){
    for(Map map in value){
      _photos.add(Photo.fromMap(map));
    }
    print('_getPhotosFromDB() içindeki .then çalıştı.');
  });*/
}

Future<List<Tag>> _getTagsFromDB() async{
  List <Tag> _tags = [];
  List <Map> _tagMaps = [];
  _tagsToSync = {};
  _tagMaps = await _dbHelper.getAllTags();
  for(Map map in _tagMaps){
    _tags.add(Tag.fromMap(map));
  }
  for(Tag tag in _tags){
    if(_prefs.containsKey(tag.id.toString())){
      _tagsToSync[tag.id.toString()] = _prefs.getBool(tag.id.toString());
    }else{
      _tagsToSync[tag.id.toString()] = true;
      _prefs.setBool(tag.id.toString(), true);
    }
  }
  return _tags;
  /*_dbHelper.getAllTags().then((value){
    for(Map map in value){
      _tags.add(Tag.fromMap(map));
    }

    for(Tag tag in _tags){
      if(_prefs.containsKey(tag.id.toString())){
        _tagsToSync[tag.id.toString()] = _prefs.getBool(tag.id.toString());
      }
    }
    print('_getTagsFromDB() içindeki .then çalıştı.');
  });*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    _darkMode = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Studify',
      theme: _darkMode == true ? ThemeData.dark() : ThemeData.light(),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text('Bir hata oluştu. Kod: ${snapshot.error.toString()}\nLütfen bu hatayı geliştiriciye bildirin. Teşekkürler.'),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done){
            if(_auth.currentUser == null){
              return LoginSignup(darkMode: _darkMode,);
            }
            else{
              return Homepage(_darkMode);
            }
          }

          return Scaffold(body: Center(child: SingleChildScrollView(),),);
        },
      ),
    );
  }
}

