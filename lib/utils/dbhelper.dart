import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studify/models/photo.dart';
import 'package:studify/models/tag.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static DBHelper _dbhelper;
  static Database _database;

  final String _tableNamePhoto = 'photo';
  final String _tableNameTag = 'tag';
  final String _columnPhotoID = 'id';
  final String _columnTagID = 'id';
  final String _columnPhotoTag = 'tagID';
  final String _columnPhotoName = 'name';
  final String _columnPhotoPath = 'imagePath';
  final String _columnWhenPhotoAdded = 'addedDT';
  final String _columnWhenPhotoUploaded = 'uploadedDT';
  final String _columnPhotoOnDevice = 'onDevice';
  final String _columnPhotoOnCloud = 'onCloud';
  final String _columnTagOnDevice = 'onDevice';
  final String _columnTagOnCloud = 'onCloud';
  final String _columnTagName = 'name';
  final String _columnWhenTagCreated = 'creationDT';
  final String _columnWhenTagUploaded = 'uploadedDT';
  final String _columnWhenTagUpdated = 'updateDT';

  factory DBHelper(){
    if(_dbhelper == null){
      _dbhelper = DBHelper._internal();
      return _dbhelper;
    }
    else{
      return _dbhelper;
    }
  }

  DBHelper._internal();

  Future<Database> _getDatabase() async{
    if(_database == null){
      _database = await _initializeDatabase();
      return _database;
    }
    else{
      return _database;
    }
  }

  _initializeDatabase() async{
    Directory _path = await getApplicationDocumentsDirectory();
    String _dbPath = join(_path.path, 'studify.db');

    var _studifyDB = openDatabase(_dbPath, version: 1, onCreate: _createDatabase);
    return _studifyDB;
  }

  _createDatabase(Database db, int version) async{
    await db.execute('CREATE TABLE "$_tableNamePhoto" ( "$_columnPhotoID"	INTEGER NOT NULL UNIQUE, "$_columnPhotoName"	TEXT, "$_columnPhotoPath"	TEXT NOT NULL, "$_columnWhenPhotoAdded"	TEXT NOT NULL, "$_columnWhenPhotoUploaded"	TEXT, "$_columnPhotoTag"	INTEGER NOT NULL, "$_columnPhotoOnDevice"	INTEGER NOT NULL, "$_columnPhotoOnCloud"	INTEGER NOT NULL, FOREIGN KEY("$_columnPhotoTag") REFERENCES "$_tableNameTag"("$_columnTagID"), PRIMARY KEY("$_columnPhotoID" AUTOINCREMENT) )');
    await db.execute('CREATE TABLE "$_tableNameTag" ( "$_columnTagID"	INTEGER NOT NULL UNIQUE, "$_columnTagName"	TEXT NOT NULL UNIQUE, "$_columnWhenTagCreated"	TEXT NOT NULL, "$_columnWhenTagUpdated"	TEXT, "$_columnWhenTagUploaded"	TEXT, "$_columnTagOnDevice"	INTEGER NOT NULL, "$_columnTagOnCloud"	INTEGER NOT NULL, PRIMARY KEY("$_columnTagID" AUTOINCREMENT) )');
  }

  Future<int> addPhoto(Photo photo) async{
    var db = await _getDatabase();
    var result = await db.insert(_tableNamePhoto, photo.toMap(), nullColumnHack: '$_columnPhotoID');
    print('Ekleme işlemi başarılı.');
    return result;
  }

  Future<int> addTag(Tag tag) async{
    var db = await _getDatabase();
    var result = await db.insert(_tableNameTag, tag.toMap(), nullColumnHack: '$_columnPhotoID');
    print('Ekleme işlemi başarılı.');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllPhotos() async{
    var db = await _getDatabase();
    var result = await db.query(_tableNamePhoto, orderBy: '$_columnPhotoID DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPhotosWithID(List<int> ids) async{
    var db = await _getDatabase();
    var result = await db.query(_tableNamePhoto, where: '$_columnPhotoID = ?', whereArgs: ids);
    return result;
  }

  Future<List<Map<String, dynamic>>> getPhotosWithTagID(List<int> ids) async{
    var db = await _getDatabase();
    var result = await db.query(_tableNamePhoto, where: '$_columnPhotoTag = ?', whereArgs: ids);
    print('Operation done.');
    return result;
  }

  Future<List<Map<String, dynamic>>> getTagsWithID(List<int> ids) async{
    var db = await _getDatabase();
    var result = await db.query(_tableNameTag, where: '$_columnTagID = ?', whereArgs: ids);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTags() async{
    var db = await _getDatabase();
    var result = await db.query(_tableNameTag, orderBy: '$_columnTagID DESC');
    return result;
  }

  Future<int> updatePhoto(Photo photo) async{
    var db = await _getDatabase();
    var result = await db.update(_tableNamePhoto, photo.toMap(), where: '$_columnPhotoID = ?', whereArgs: [photo.id]);
    return result;
  }


  Future<int> updateTag(Tag tag) async{
    var db = await _getDatabase();
    var result = await db.update(_tableNameTag, tag.toMap(), where: '$_columnTagID = ?', whereArgs: [tag.id]);
    return result;
  }

  Future<int> deletePhoto(int id) async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNamePhoto, where: '$_columnPhotoID = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteTag(int id) async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNameTag, where: '$_columnTagID = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteAllOfThePhotoTable() async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNamePhoto);
    return result;
  }

  Future<int> deleteAllOfTheTagTable() async{
    var db = await _getDatabase();
    var result = await db.delete(_tableNameTag);
    return result;
  }
}

