import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studify/homepage.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginSignup extends StatefulWidget {
  bool _darkMode;
  LoginSignup({Key key, @required bool darkMode}) : super(key: key) {
    this._darkMode = darkMode;
  }

  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _registered = true;
  var _registerNameController = TextEditingController();
  var _registerEmailController = TextEditingController();
  var _registerPasswordController = TextEditingController();
  var _registerPasswordVerifyController = TextEditingController();
  var _loginEmailController = TextEditingController();
  var _loginPasswordController = TextEditingController();
  var _registerFormKey = GlobalKey<FormState>();
  var _loginFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 16,16,16),
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        body: Container(
          child: _registered ? _loginUI() : _registerUI(),
        ),
        /*FutureBuilder(
          future: _initialization,
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text('Bir hata oluştu. Kod: ${snapshot.error.toString()}'),
              );
            }

            if(snapshot.connectionState == ConnectionState.done){
              _auth.authStateChanges().listen((User user) {
                if(user != null){
                  print('Kullanıcı oturum açtı.');
                  if(once){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
                    once = false;
                  }
                }else{
                  print('Kullanıcı oturumu kapattı.');
                }
              });
              return _registered ? _loginUI() : _registerUI();
            }

            return Center(child: CircularProgressIndicator(),);
          },
        ),*/
      ),
    );
  }

  Widget _loginUI() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Container(
                      width: MediaQuery.of(context).size.width/8,
                      height: MediaQuery.of(context).size.width/8,
                      child: Icon(Icons.arrow_back_ios_outlined, size: 30,),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 27,27,27),
                          width: 3
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: 16,),*/
                    Text('Giriş Yap', style: TextStyle(fontSize: 40, fontFamily: 'JetBrainsMono-ExtraBold'),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/10,),
              Text('Google ile giriş yapın: ', style: TextStyle(fontFamily: 'JetBrainsMono-Regular')),
              SizedBox(height: MediaQuery.of(context).size.height/40,),
              InkWell(
                onTap: (){
                  _loginWithGoogle();
                },
                child: Container(
                  child: Center(child: Image.asset('assets/images/googlelogo.png', width: 30, height: 30,)),
                  width: MediaQuery.of(context).size.width*(4/5),
                  height: MediaQuery.of(context).size.height/15,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255,30,30,30),
                    border: Border.all(
                        color: Color.fromARGB(255,35,35,35),
                        width: 3
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/20,),
              Text('Ya da e-posta ve parola ile giriş yapın: ', style: TextStyle(fontFamily: 'JetBrainsMono-Regular')),
              SizedBox(height: MediaQuery.of(context).size.height/40,),
              Form(
                key: _loginFormKey,
                child: Container(
                  width: MediaQuery.of(context).size.width*(4/5),
                  //height: MediaQuery.of(context).size.height*(3/5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //E-mail
                      TextFormField(
                        style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
                        keyboardType: TextInputType.emailAddress,
                        controller: _loginEmailController,
                        validator: (value){
                          bool valid = EmailValidator.validate(value);
                          if(!valid){
                            return 'Geçerli bir e-posta adresi girmelisiniz.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.alternate_email_outlined),
                          hintText: 'E-posta',
                          hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          labelText: 'E-posta',
                          labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                        ),
                      ),
                      SizedBox(height: 8,),
                      //Password
                      TextFormField(
                        style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),
                        obscureText: true,
                        obscuringCharacter: '•',
                        controller: _loginPasswordController,
                        validator: (value){
                          if(value == null || value == '' || value.isEmpty || value.length < 8){
                            return 'Geçerli bir parola girmelisiniz.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: 'Parola',
                          hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          labelText: 'Parola',
                          labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                        ),
                      ),
                      SizedBox(height: 8,),
                      ElevatedButton(
                        onPressed: () async{
                          _loginFormKey.currentState.save();
                          if(_loginFormKey.currentState.validate()){
                            _loginWithEmailAndPassword(_loginEmailController.text, _loginPasswordController.text).then((value){
                              if(value == true){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homepage(widget._darkMode ?? true)));
                              }
                            });
                            _loginPasswordController.text = '';
                            _loginEmailController.text = '';
                          }
                        },
                        child: Text("Giriş Yap", style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold')),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Bir hesabınız yok mu? ', style: TextStyle(fontSize: 12, fontFamily: 'JetBrainsMono-Light'),),
                          InkWell(
                            child: Text('Kaydolun.', style: TextStyle(fontSize: 12, color: Colors.blue, fontFamily: 'JetBrainsMono-Light'),),
                            onTap: (){
                              setState(() {
                                _loginPasswordController.text = '';
                                _loginEmailController.text = '';
                                _registered = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerUI() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Container(
                        width: MediaQuery.of(context).size.width/8,
                        height: MediaQuery.of(context).size.width/8,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 30,),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 27,27,27),
                              width: 3
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(width: 16,),*/
                      Text('Kaydol', style: TextStyle(fontSize: 40, fontFamily: 'JetBrainsMono-ExtraBold'),),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/10,),
                Text('Google ile kaydolun: ', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
                SizedBox(height: MediaQuery.of(context).size.height/40,),
                InkWell(
                  onTap: (){
                    _loginWithGoogle();
                  },
                  child: Container(
                    child: Center(child: Image.asset('assets/images/googlelogo.png', width: 30, height: 30,)),
                    width: MediaQuery.of(context).size.width*(4/5),
                    height: MediaQuery.of(context).size.height/15,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255,30,30,30),
                      border: Border.all(
                          color: Color.fromARGB(255,35,35,35),
                          width: 3
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/20,),
                Text('Ya da e-posta ve parola ile kaydolun: ', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
                SizedBox(height: MediaQuery.of(context).size.height/40,),
                Form(
                  key: _registerFormKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width*(4/5),
                    //height: MediaQuery.of(context).size.height*(3/5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Ad-Soyad
                        TextFormField(
                          style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
                          controller: _registerNameController,
                          validator: (value){
                            if(value.length < 3 || value == null || value == '' || value.isEmpty){
                              return 'Geçerli bir isim girmelisiniz.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              hintText: 'Ad & Soyad',
                              hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                              labelText: 'Ad & Soyad',
                              labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          ),
                        ),
                        SizedBox(height: 8,),
                        //E-mail
                        TextFormField(
                          style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
                          keyboardType: TextInputType.emailAddress,
                          controller: _registerEmailController,
                          validator: (value){
                            bool valid = EmailValidator.validate(value);
                            if(!valid){
                              return 'Geçerli bir e-posta adresi girmelisiniz.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                            hintText: 'E-posta',
                            hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            labelText: 'E-posta',
                            labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          ),
                        ),
                        SizedBox(height: 8,),
                        //Password
                        TextFormField(
                          style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
                          obscureText: true,
                          obscuringCharacter: '•',
                          controller: _registerPasswordController,
                          validator: (value){
                            if(value == null || value == '' || value.isEmpty || value.length < 8){
                              return 'Geçerli bir parola girmelisiniz.';
                            }

                            if(value.length < 8){
                              return 'Parolanız en az 8 karakterden oluşmalıdır.';
                            }

                            if(value != _registerPasswordVerifyController.text){
                              return 'Parolalar eşleşmiyor.';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Parola',
                            hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            labelText: 'Parola',
                            labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          ),
                        ),
                        SizedBox(height: 8,),
                        //PasswordVerify
                        TextFormField(
                          style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),
                          obscureText: true,
                          obscuringCharacter: '•',
                          controller: _registerPasswordVerifyController,
                          validator: (value){
                            if(value == null || value == '' || value.isEmpty || value.length < 8){
                              return 'Geçerli bir parola girmelisiniz.';
                            }

                            if(value.length < 8){
                              return 'Parolanız en az 8 karakterden oluşmalıdır.';
                            }

                            if(value != _registerPasswordController.text){
                              return 'Parolalar eşleşmiyor.';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Parola tekrarı',
                            hintStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                            labelText: 'Parola tekrarı',
                            labelStyle: TextStyle(fontFamily: 'JetBrainsMono-Light'),
                          ),
                        ),
                        SizedBox(height: 8,),
                        ElevatedButton(
                          onPressed: () async{
                            _registerFormKey.currentState.save();
                            if(_registerFormKey.currentState.validate()){
                              await _registerWithNameAndEmailAndPassword(_registerNameController.text, _registerEmailController.text, _registerPasswordController.text);
                              _registerNameController.text = '';
                              _registerEmailController.text = '';
                              _registerPasswordController.text = '';
                              _registerPasswordVerifyController.text = '';
                            }
                          },
                          child: Text("Kaydol", style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Zaten bir hesabınız var mı? ', style: TextStyle(fontSize: 12, fontFamily: 'JetBrainsMono-Light'),),
                            InkWell(
                              child: Text('Giriş yapın.', style: TextStyle(fontSize: 12, color: Colors.blue, fontFamily: 'JetBrainsMono-Light'),),
                              onTap: (){
                                setState(() {
                                  _registerNameController.text = '';
                                  _registerEmailController.text = '';
                                  _registerPasswordController.text = '';
                                  _registerPasswordVerifyController.text = '';
                                  _registered = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerWithNameAndEmailAndPassword(String displayName, String email, String password) async{
    try{
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _credential.user.updateProfile(displayName: displayName);
      _firestore.collection('users').doc('${_auth.currentUser.uid}');
      _firestore.collection('users').doc('${_auth.currentUser.uid}').set({
        'registered': FieldValue.serverTimestamp(),
        'verified': false,
        'lastLogin': FieldValue.serverTimestamp(),
        'name': '${_auth.currentUser.displayName}',
        'email': '${_auth.currentUser.email}'
      });
      await _credential.user.sendEmailVerification();
      if(_auth.currentUser != null){
        await _auth.signOut();
        _showVerifyEmailDialog();
      }
      print('Kullanıcı başarıyla oluşturuldu:');
      print(_credential.user.toString());
      print('E-posta adresinizi doğrulayın.');
    }catch(e){
      print('Kullanıcı kaydı sırasında bir hata oluştu: $e');
    }
  }

  _loginWithGoogle() async{
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      // Once signed in, return the UserCredential
      var cred = await _auth.signInWithCredential(credential);
      _firestore.collection('users').doc('${_auth.currentUser.uid}');
      _firestore.collection('users').doc('${_auth.currentUser.uid}').set({
        'registered': FieldValue.serverTimestamp(),
        'verified': true,
        'lastLogin': FieldValue.serverTimestamp(),
        'name': '${_auth.currentUser.displayName}',
        'email': '${_auth.currentUser.email}'
      });
      return cred;
    }catch(e){
      print('Google login işlemi sırasında bir hata oluştu: $e');
    }
  }

  _loginWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(!userCredential.user.emailVerified){
        userCredential.user.sendEmailVerification();
        _auth.signOut();
        _showVerifyEmailDialog();
        return Future.value(false);
      }else{
        _firestore.collection('users').doc('${_auth.currentUser.uid}').update({
          'verified': true,
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('Giriş yapıldı.');
        return Future.value(true);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Girdiğiniz e-posta ya da parola hatalı.');
      } else{
        print('FirebaseAuthException hatası: $e');
      }
    }catch(e){
      print('E-posta ve parola ile login sırasında bir hata oluştu: $e');
    }
  }

  _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('E-posta adresinizi doğrulayın.', style: TextStyle(fontFamily: 'JetBrainsMono-ExtraBold'),),
          content: Text('E-posta adresinize bir doğrulama bağlantısı gönderdik. Giriş yapmak için lütfen size gönderilen bağlantıyı kullanarak e-posta adresinizi doğrulayın. Eğer herhangi bir bağlantı almadıysanız, kodun tekrar gönderilmesi için tekrar giriş yapın. Eğer birden fazla bağlantı aldıysanız yalnızca en son gönderilen bağlantı geçerlidir.', style: TextStyle(fontFamily: 'JetBrainsMono-Regular'),),
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
