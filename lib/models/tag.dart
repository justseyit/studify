import 'package:flutter/material.dart';

class Tag{
  int _id;
  String _name;
  DateTime _creationDT;
  DateTime _updateDT;
  DateTime _uploadedDT;
  bool _isOnDevice;
  bool _isOnCloud;

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

  DateTime get updateDT => _updateDT;

  DateTime get uploadedDT => _uploadedDT;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    this._updateDT = DateTime.now();
  }

  DateTime get creationDT => _creationDT;

  Tag.withID({@required int id, @required String name, @required DateTime created, DateTime updated, @required bool onDevice, @required bool onCloud}){
    this._id = id;
    this._name = name;
    this._creationDT = created;
    this._updateDT = updated;
    this._isOnDevice = onDevice;
    this._isOnCloud = onCloud;
  }

  Tag({@required String name, @required DateTime created, DateTime updated, @required bool onDevice, @required bool onCloud}){
    this._name = name;
    this._creationDT = created;
    this._updateDT = updated;
    this._isOnDevice = onDevice;
    this._isOnCloud = onCloud;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['name'] = name;
    map['creationDT'] = _creationDT != null ? _creationDT.toString() : null;
    map['updateDT'] = _updateDT != null ? _updateDT.toString() : null;
    map['uploadedDT'] = _uploadedDT != null ? _uploadedDT.toString() : null;
    map['onDevice'] = _isOnDevice == true ? 1 : 0;
    map['onCloud'] = _isOnCloud == true ? 1 : 0;
    return map;
  }

  Tag.fromMap(Map map){
    this._id = map['id'];
    this._name = map['name'] ?? '';
    this._creationDT = map['creationDT'] == null || map['creationDT'].isEmpty || map['creationDT'] == '' || map['creationDT'].length == 0 ? null : DateTime.parse(map['creationDT']);
    this._updateDT = map['updateDT'] == null || map['updateDT'].isEmpty || map['updateDT'] == '' || map['updateDT'].length == 0 ? null : DateTime.parse(map['updateDT']);
    this._uploadedDT = map['uploadedDT'] == null || map['uploadedDT'].isEmpty || map['uploadedDT'] == '' || map['uploadedDT'].length == 0 ? null : DateTime.parse(map['uploadedDT']);
    this._isOnDevice = map['onDevice'] == 1 ? true : false;
    this._isOnCloud = map['onCloud'] == 1 ? true : false;
  }

  @override
  bool operator ==(covariant Tag other){
    return (other.isOnCloud == this._isOnCloud && other.isOnDevice == this._isOnDevice && other.id == this._id && other.name == this._name && other.creationDT == this._creationDT && other.updateDT == this._updateDT && other.uploadedDT == this._uploadedDT);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;




}