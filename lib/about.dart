import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final String aboutTitle ='UYGULAMA\nHAKKINDA';
  final String purposeTitle ='Uygulamanın Amacı';
  final String purposeText = 'Bu uygulama, Seyit Ahmet Gökçe tarafından Kırıkkale Üniversitesi Bilgisayar Mühendisliği Bölümü 2020-2021 eğitim-öğretim yılı 3. sınıf 2. dönem "Proje-2" dersinin projesi olarak yapılmıştır.';
  final String appearanceTitle ='Uygulamanın İşlevleri';
  final String appearanceText = 'Bu uygulamanın işlevlerini şu şekilde sıralayabiliriz:\n\n-Fotoğrafları Etiketlere Dahil Etme: Uygulamaya dahil edilen fotoğraflar, etiketlere göre kategorilendirilebilir.\n\n-Fotoğrafları Buluta Yedekleme: Uygulamaya dahil edilen fotoğraflar buluta yedeklenebilir.\n\n-Etiketler İle Fotoğraf Arama: Uygulama içinde bulunan arama çubuğu sayesinde, fotoğrafları atadığınız etiketleri kolayca bulabilirsiniz.\n\n-Etiket Yönetimi: Dilediğiniz kadar etiket oluşturup silebilir ya da düzenleyebilirsiniz.\n\n-Fotoğraf Yönetimi: Dilediğiniz kadar fotoğraf ekleyip silebilir ya da düzenleyebilirsiniz.\n\n';
  final String personalDataTitle = 'KİŞİSEL VERİLER HAKKINDA';
  final String personalDataText ='Bu uygulama, fotoğrafları senkronize edebilmek için sizin bilgilerinize ihtiyaç duyar. Bu veriler; senkronizasyon zamanı, son giriş zamanı, cihazdaki dosyanın yolu ve adıdır. Ayrıca sunucuda e posta adresleri ve profil resmi referansı ile kendisi, yedeklenen fotoğrafların referansı ile kendisi, yedeklenen etiketler ve diğer birtakım meta veriler tutulmaktadır.';
  final String unresponsibilityTitle = 'SORUMLULUK REDDİ BEYANI';
  final String unresponsibilityText = 'Bu uygulama, işleri kolaylaştırmak için yapıldı. Ders zamanı ya da bildirimi, ders programı, uygulama içi hata kaynaklı program aksamaları, uygulamanın kaynak kodlarına ya da kaynak dosyalarına erişilerek bunların değiştirilmesi durumunda oluşacak sorunlar, bellekte tutulan bilgilerin ve kalıcı/geçici dosyaların değiştirilmesi nedeniyle oluşacak sorunlar da dahil tüm durumlarda doğacak zararlardan geliştirici hiçbir şekilde sorumluluk kabul etmez. Lütfen bir hata bulmanız halinde geliştiriciye bu hatayı bildiriniz. Teşekkürler.';
  bool _darkMode;
  About({Key key, @required bool darkMode}) : super(key: key){
    this._darkMode = darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkMode == true ? Color.fromARGB(255, 16,16,16) : ThemeData.light().scaffoldBackgroundColor,
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
                  'Hakkında',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'JetBrainsMono-Regular'
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/15,),
            Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height - 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  /*border: Border.all(
                      color: Colors.black87,
                      width: 2
                  ),*/
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 16,),
                        Text(
                          aboutTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "JetBrainsMono-Bold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          purposeTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "JetBrainsMono-Bold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          purposeText,
                          style: TextStyle(
                            //fontSize: 25,
                            fontFamily: "JetBrainsMono-Light",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          appearanceTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "JetBrainsMono-Bold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          appearanceText,
                          style: TextStyle(
                            //fontSize: 25,
                            fontFamily: "JetBrainsMono-Light",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          personalDataTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "JetBrainsMono-Bold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          personalDataText,
                          style: TextStyle(
                            //fontSize: 25,
                            fontFamily: "JetBrainsMono-Light",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          unresponsibilityTitle,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "JetBrainsMono-Bold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16,),
                        Text(
                          unresponsibilityText,
                          style: TextStyle(
                            //fontSize: 25,
                            fontFamily: "JetBrainsMono-Light",
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
