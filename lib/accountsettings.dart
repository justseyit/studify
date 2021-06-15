import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AccSettings extends StatefulWidget {
  bool _darkMode;
  AccSettings({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  _AccSettingsState createState() => _AccSettingsState();
}

class _AccSettingsState extends State<AccSettings> {
  final ImagePicker _picker = ImagePicker();
  bool _ppIsChanged;
  bool _passwordExpanded;
  File _image;
  bool _male;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _oldPassController;
  TextEditingController _newPassController;
  TextEditingController _newPassVerifyController;
  GlobalKey<FormState> _formKey;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _newPassVerifyController = TextEditingController();
    _ppIsChanged = false;
    _passwordExpanded = false;
    _nameController.text = _auth.currentUser.displayName;
    _emailController.text = _auth.currentUser.email;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  'Hesap',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'JetBrainsMono-Regular'
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/15,),
            Container(
              height: MediaQuery.of(context).size.height*(7.9/10),
              child: SingleChildScrollView(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //PP
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Text(
                                'Profil Resmi',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'JetBrainsMono-Regular'
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 70,
                          child: _ppIsChanged == true ? Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: _image != null ? BoxFit.cover : BoxFit.cover,
                                image: _image != null ? FileImage(_image) : AssetImage('assets/images/user64px.png'),
                              ),
                            ),
                          ) : Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_auth.currentUser.photoURL ?? 'https://github.com/seyitahmetgkc/lessonsapi/raw/master/user64px.png'),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit_outlined),
                              onPressed: () async{
                                await _getImageFromGallery();
                              },
                              splashRadius: 20,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: (){
                                setState(() {
                                  _image = null;
                                  _ppIsChanged = true;
                                });
                              },
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/10,),
                        //Name
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width*(1.3/4),
                                child: AutoSizeText(
                                  'İsim',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
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
                                    controller: _nameController,
                                    style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18),
                                    cursorColor: widget._darkMode == true ? Colors.white : Colors.black,
                                    decoration: InputDecoration(
                                        focusColor: widget._darkMode == true ? Colors.white : Colors.black,
                                        fillColor: widget._darkMode == true ? Colors.white : Colors.black,
                                        hoverColor: widget._darkMode == true ? Colors.white : Colors.black,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero
                                    ),
                                      validator: (value){
                                        if(value.length < 3 || value == null || value == '' || value.isEmpty){
                                          return 'Geçerli bir isim girmelisiniz.';
                                        }

                                        return null;
                                    }
                                  ),
                              ),
                            ],
                          ),
                        ),
                        //Gender
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width*(1.3/4),
                                child: AutoSizeText(
                                  'Cinsiyet',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              _male != null ? Container(
                                width: MediaQuery.of(context).size.width*(1.2/3),
                                child: Row(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: (){
                                        setState(() {
                                          _male = true;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/8,
                                        height: MediaQuery.of(context).size.width/8,
                                        decoration: _male ? BoxDecoration(
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(100),
                                          color: widget._darkMode == true ? Colors.white : Colors.black,
                                        ) : BoxDecoration(
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Icon(Icons.male_outlined, color: widget._darkMode == true ? _male  == true ? Colors.black : Colors.white : _male == true ? Colors.white : Colors.black,),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/10,),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: (){
                                        setState(() {
                                          _male = false;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/8,
                                        height: MediaQuery.of(context).size.width/8,
                                        decoration: _male ? BoxDecoration(
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(100),
                                        ) : BoxDecoration(
                                            border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                            borderRadius: BorderRadius.circular(100),
                                            color: widget._darkMode == true ? Colors.white : Colors.black,
                                        ),
                                        child: Icon(Icons.female_outlined, color: widget._darkMode == true ? _male == true ? Colors.white : Colors.black : _male == true ? Colors.black : Colors.white,),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(
                                width: MediaQuery.of(context).size.width*(1.2/3),
                                child: Row(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: (){
                                        setState(() {
                                          _male = true;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/8,
                                        height: MediaQuery.of(context).size.width/8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Icon(Icons.male_outlined),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width/10,),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: (){
                                        setState(() {
                                          _male = false;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width/8,
                                        height: MediaQuery.of(context).size.width/8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Icon(Icons.female_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Email
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
                              Container(
                                width: MediaQuery.of(context).size.width*(1.3/4),
                                child: AutoSizeText(
                                  'E-posta',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'JetBrainsMono-Regular'
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width/10,),
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
                                  controller: _emailController,
                                  style: TextStyle(fontFamily: 'JetBrainsMono-Regular', fontSize: 18),
                                  validator: (value){
                                    bool valid = EmailValidator.validate(value);
                                    if(!valid){
                                      return 'Geçerli bir e-posta adresi girmelisiniz.';
                                    }
                                    return null;
                                  },
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
                        ),
                        //Password
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Container(
                            child: ExpansionTileCard(
                              onExpansionChanged: (value){
                                _passwordExpanded = value;
                              },
                              borderRadius: BorderRadius.circular(12),
                              baseColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                              expandedColor: widget._darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
                              elevation: 0,
                              contentPadding: EdgeInsets.zero,
                              expandedTextColor: widget._darkMode == true ? Colors.white : Colors.black,
                              shadowColor: widget._darkMode == true ? Colors.white : Colors.black,
                              trailing: SizedBox(width:0),
                              animateTrailing: false,
                              title: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*(1.3/4),
                                    child: AutoSizeText(
                                      'Parola',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'JetBrainsMono-Regular'
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/10,),
                                  Container(
                                    height: MediaQuery.of(context).size.height/12,
                                    width: MediaQuery.of(context).size.width*(1.2/3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: widget._darkMode == true ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*(0.9),
                                        child: AutoSizeText(
                                          'Eğer parolanızı güncellemek istemiyorsanız ayarları kaydetmek için bu açılır pencereyi kapalı tutunuz.',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'JetBrainsMono-Regular'
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Old Pass
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*(1.3/4),
                                        child: AutoSizeText(
                                          'Eski Parola',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'JetBrainsMono-Regular'
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
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
                                          controller: _oldPassController,
                                          validator: (value){
                                            if(value == null || value == '' || value.isEmpty || value.length < 8){
                                              return 'Geçerli bir parola girmelisiniz.';
                                            }

                                            if(value.length < 8){
                                              return 'Parolanız en az 8 karakterden oluşmalıdır.';
                                            }

                                            if(_passwordExpanded == false){
                                              return null;
                                            }
                                            return null;
                                          },
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
                                ),
                                //New Pass
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*(1.3/4),
                                        child: AutoSizeText(
                                          'Yeni Parola',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'JetBrainsMono-Regular'
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
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
                                          controller: _newPassController,
                                          validator: (value){
                                            if(value == null || value == '' || value.isEmpty || value.length < 8){
                                              return 'Geçerli bir parola girmelisiniz.';
                                            }

                                            if(value.length < 8){
                                              return 'Parolanız en az 8 karakterden oluşmalıdır.';
                                            }

                                            if(value != _newPassVerifyController.text){
                                              return 'Parolalar eşleşmiyor.';
                                            }

                                            if(_passwordExpanded == false){
                                              return null;
                                            }

                                            return null;
                                          },
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
                                ),
                                //Verify Pass
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*(1.3/4),
                                        child: AutoSizeText(
                                          'Yeni Parolayı Onayla',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'JetBrainsMono-Regular'
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/10,),
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
                                          controller: _newPassVerifyController,
                                          validator: (value){
                                            if(value == null || value == '' || value.isEmpty || value.length < 8){
                                              return 'Geçerli bir parola girmelisiniz.';
                                            }

                                            if(value.length < 8){
                                              return 'Parolanız en az 8 karakterden oluşmalıdır.';
                                            }

                                            if(value != _newPassController.text){
                                              return 'Parolalar eşleşmiyor.';
                                            }

                                            if(_passwordExpanded == false){
                                              return null;
                                            }

                                            return null;
                                          },
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async{
                                if(_formKey.currentState.validate()){
                                  if(_passwordExpanded == true){
                                    var user = _auth.currentUser;
                                    var credential = EmailAuthProvider.credential(
                                      email: _auth.currentUser.email,
                                      password: _oldPassController.text,
                                    );

                                    user.reauthenticateWithCredential(credential).then((value){
                                      _auth.currentUser.updatePassword(_newPassController.text).then((value){
                                        _showMessage(title: 'İşlem Başarılı', message: 'Parolanız başarıyla güncellendi.');
                                      });
                                    }).catchError((err){
                                      _showMessage(title: 'Hata', message: '${err.toString()}');
                                    });
                                  }

                                  if(_nameController.text != _auth.currentUser.displayName){
                                    _auth.currentUser.updateProfile(displayName: _nameController.text);
                                  }

                                  if(_emailController.text != _auth.currentUser.email){
                                    _auth.currentUser.updateEmail(_emailController.text);
                                    _showVerifyEmailDialog();
                                  }

                                  if(_male != null){
                                    _male ? _firestore.collection('users').doc('${_auth.currentUser.uid}').update({'gender':'male'}):
                                    _firestore.collection('users').doc('${_auth.currentUser.uid}').update({'gender':'female'});
                                  }

                                  if(_ppIsChanged == true){
                                    if(_image != null){
                                      await _uploadImageToFirebase(_auth.currentUser.uid, _image);
                                    }else{
                                      _auth.currentUser.updateProfile(photoURL: 'https://github.com/seyitahmetgkc/lessonsapi/raw/master/user64px.png');
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width/8,
                                height: MediaQuery.of(context).size.width/8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: widget._darkMode == true ? Colors.white : Colors.black,),
                                  color: widget._darkMode == true ? Colors.white : Colors.black,
                                ),
                                child: Icon(
                                  Icons.done,
                                  size: 30,
                                  color: widget._darkMode == true ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Tamam')),
              ],
            )
          ],
        );
      },
    );
  }

  _getImageFromGallery() async {
    _picker.getImage(source: ImageSource.gallery).then((value){
      if (value != null) {
        _image = File(value.path);
        setState(() {
          _ppIsChanged = true;
        });
      } else {
        print('No image selected.');
        setState(() {
          _ppIsChanged = false;
        });
      }
    });
  }

  Future _uploadImageToFirebase(String uid, File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('UserFiles').child('$uid').child('pp.png');
    ref.putFile(file).then((value)async{
      String pplink = await value.ref.getDownloadURL();
      _auth.currentUser.updateProfile(photoURL: pplink);
      print('completed');
    });


    /*FirebaseStorage.instance.ref().child('user_files').child('$uid').child('pp.png').putFile(file).then((value){
      print(value.ref.getDownloadURL());
    });*/
  }

  _showVerifyEmailDialog() {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('E-posta adresinizi doğrulayın.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
            content: Text('Yeni e-posta adresinize bir doğrulama bağlantısı gönderdik. Lütfen size gönderilen bağlantıyı kullanarak e-posta adresinizi doğrulayın.', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('Tamam', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

}
