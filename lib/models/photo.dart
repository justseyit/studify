import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:studify/models/tag.dart';
import 'package:studify/utils/dbhelper.dart';

class Photo{
  int _id;
  String _name;
  String _imagePath;
  DateTime _addedDT;
  DateTime _uploadedDT;
  Tag _tag;
  bool _isOnDevice;
  bool _isOnCloud;
  int _width;
  int _height;

  int get width => _width;

  int get height => _height;

  DateTime get uploadedDT => _uploadedDT;

  bool get isOnDevice => _isOnDevice;

  set isOnDevice(bool value) {
    _isOnDevice = value;
  }

  bool get isOnCloud => _isOnCloud;

  set isOnCloud(bool value) {
    if(value == true){
      this._uploadedDT = DateTime.now();
    }
    _isOnCloud = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  DateTime get addedDT => _addedDT;

  set addedDT(DateTime value) {
    _addedDT = value;
  }

  Tag get tag => _tag;

  set tag(Tag value) {
    _tag = value;
  }

  _setTagID(int tagID){
    DBHelper _ = DBHelper();
    _.getTagsWithID([tagID]).then((value){
      _tag = Tag.fromMap(value[0]);
    });
    return _tag;
  }

  _setImageSize(){
    Image image = Image.file(File(_imagePath));
    Completer<ui.Image> completer = Completer<ui.Image>();

    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _){
      completer.complete(info.image);
    }));

    completer.future.then((image){
      _width = image.width;
      _height = image.height;
      //print(image.width);
      //print(image.height);
    });
  }

  Photo.withID({
    @required int id,
    @required String name,
    @required String imagePath,
    @required Tag tag,
    @required DateTime added,
    @required bool onDevice,
    @required bool onCloud}){
    this._id = id;
    this._name = name;
    this._imagePath = imagePath;
    this._tag = tag;
    this._addedDT = added;
    this._isOnDevice = onDevice;
    this._isOnCloud = onCloud;
    _setImageSize();
  }

  Photo({
    @required String name,
    @required String imagePath,
    @required Tag tag,
    @required DateTime added,
    @required bool onDevice,
    @required bool onCloud}){
    this._id = id;
    this._name = name;
    this._imagePath = imagePath;
    this._tag = tag;
    this._addedDT = added;
    this._isOnDevice = onDevice;
    this._isOnCloud = onCloud;
    _setImageSize();
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['name'] = name;
    map['addedDT'] = _addedDT.toString();
    map['tagID'] = _tag.id;
    map['imagePath'] = _imagePath;
    map['uploadedDT'] = _uploadedDT != null ? _uploadedDT.toString() : null;
    map['onDevice'] = _isOnDevice == true ? 1 : 0;
    map['onCloud'] = _isOnCloud == true ? 1 : 0;
    print('$_name için tag id: ${tag.id}');
    return map;
  }

  //TODO: Implement tag with 'fromMap' method.
  Photo.fromMap(Map map){
    this._id = map['id'];
    this._name = map['name'] ?? '';
    this._addedDT = map['addedDT'] == null || map['addedDT'].isEmpty || map['addedDT'] == '' || map['addedDT'].length == 0 ? null : DateTime.parse(map['addedDT']);
    this._imagePath = map['imagePath'];
    this._uploadedDT = map['uploadedDT'] == null || map['uploadedDT'].isEmpty || map['uploadedDT'] == '' || map['uploadedDT'].length == 0 ? null : DateTime.parse(map['uploadedDT']);
    this._isOnDevice = map['onDevice'] == 1 ? true : false;
    this._isOnCloud = map['onCloud'] == 1 ? true : false;
    _setImageSize();
    _setTagID(map['tagID']);
  }

  
}