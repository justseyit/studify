enum PhotoSize{
  verySmall,
  small,
  medium,
  large,
  veryLarge
}

class Setting{
  static int _photoCrossAxisCount = 3;

  static PhotoSize currentPhotoSize = PhotoSize.medium;

  static int get photoCrossAxisCount => _photoCrossAxisCount;

  static void setPhotoSize(PhotoSize photoSize){
    if(photoSize == PhotoSize.verySmall){
      _photoCrossAxisCount = 5;
      currentPhotoSize = photoSize;
    }

    if(photoSize == PhotoSize.small){
      _photoCrossAxisCount = 4;
      currentPhotoSize = photoSize;
    }

    if(photoSize == PhotoSize.medium){
      _photoCrossAxisCount = 3;
      currentPhotoSize = photoSize;
    }

    if(photoSize == PhotoSize.large){
      _photoCrossAxisCount = 2;
      currentPhotoSize = photoSize;
    }

    if(photoSize == PhotoSize.veryLarge){
      _photoCrossAxisCount = 1;
      currentPhotoSize = photoSize;
    }
  }
}