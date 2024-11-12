class Obstacle{
  //atribut
  int _startX;
  int _spikeX;
  int _spikeY;
  int _squareX;
  int _squareY;
  int _speed;
  boolean _ignore;
  
  Obstacle(int x){ //hanya memiliki satu argumen, di mana startX, squareX, dan spikeX diatur sesuai
    _startX = x;
    _squareX = _startX;
    _spikeX = _startX;
    _ignore = false;
  }
  
  void spike(int y){ //rintangan berbentuk paku (mematikan dari depan dan atas)
    _spikeY = y; //koordinat y dari rintangan, diatur sesuai dengan argumen dalam konstruktor
    strokeWeight(2);
    stroke(150);
    fill(0);
    triangle(_spikeX, _spikeY, _spikeX+30, _spikeY, _spikeX+15, _spikeY-50);
    _spikeX -= _speed;
  }
  
  void square(int y){ //rintangan berbentuk kotak (mematikan dari depan, aman di atas)
    _squareY = y; //koordinat y dari rintangan, diatur sesuai dengan argumen dalam konstruktor
    rectMode(CENTER);
    strokeWeight(2);
    stroke(150);
    fill(0);
    rect(_squareX, _squareY, 50, 50); 
    _squareX -= _speed;
  }
  
  void ignore(){ //digunakan untuk membuat objek Player dapat melompat di atas rintangan berbentuk kotak
    _ignore = true;
  }
  
//metode get untuk digunakan saat memeriksa tabrakan dengan objek Player
  //untuk rintangan berbentuk paku
  int spikeGetX1(){
    return _spikeX+5; //mengembalikan koordinat depan dari paku
  }
  int spikeGetX2(){
    return _spikeX+75; //mengembalikan koordinat belakang dari paku
  }
  int spikeGetY1(){
    return _spikeY-50; //mengembalikan koordinat atas dari paku
  }
  int spikeGetY2(){
    return _spikeY; //mengembalikan koordinat bawah dari paku
  }
  
  //untuk rintangan berbentuk kotak
  int squareGetX1(){ //mengembalikan koordinat depan dari kotak
    return _squareX-25;
  }
  int squareGetX2(){ //mengembalikan koordinat belakang dari kotak
    return _squareX+75;
  }
  int squareGetY1(){ //mengembalikan koordinat atas dari kotak
    return _squareY-25;
  }
  int squareGetY2(){ //mengembalikan koordinat bawah dari kotak
    return _squareY+25;
  }
  
  void move(int speed){ //menentukan kecepatan pergerakan rintangan di sepanjang sumbu x
    _speed = speed;
  }
}
