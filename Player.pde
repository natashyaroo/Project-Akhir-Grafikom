class Player {
  //atribut (dipengaruhi oleh argumen)
  int _PlayerX; //posisi x dari objek pemain
  int _PlayerY; //posisi y dari objek pemain
  int _PlayerSize; //ukuran dari objek pemain
  int _startY; //posisi y awal dari objek pemain, digunakan untuk menentukan di mana "lantai" berada

  //atribut (tidak dipengaruhi oleh argumen)
  int gravity = 6; //gravitasi yang memengaruhi objek pemain
  int jumpCounter = 0; //penghitung yang digunakan untuk menentukan berapa lama lompatan berlangsung
  int jumpCounterLimit = 20; //batas untuk jumpCounter
  boolean isJumping = false; //boolean yang digunakan untuk memicu lompatan
  float jumpAngle = 0; //sudut di mana objek pemain berputar
  float incrementAngle = PI/20; //inkrementasi sudut saat lompatan terjadi
  boolean notInAir = true; //digunakan untuk menentukan kapan objek pemain diizinkan melompat
  int s = second();

  Player(int x, int y, int size) { //objek Player memiliki tiga argumen: posisi x & y dan ukuran
    //menyetel atribut agar sama dengan argumen yang dilewatkan
    _PlayerX = x;
    _PlayerY = y;
    _PlayerSize = size;
    _startY = y; //digunakan untuk menentukan kapan gravitasi aktif
  }

  void jump() { //membuat Player melompat, ini akan dikendalikan oleh pemain game
    if (notInAir) { //jika pemain ada di tanah == true
      isJumping = true; //mengatur boolean ke true, yang memicu lompatan di "physics()"
      
        sfxJump.cue(0.1); // memulai sesuai detik pada file sound
        sfxJump.play();
      
    }
  }

  void physics() { //ditempatkan dalam "draw()" untuk terus diperbarui
    //gravitasi
    if (_PlayerY < _startY) { //jika posisi y objek pemain lebih kecil dari posisi y awal
      _PlayerY += gravity; //meningkatkan posisi y objek pemain dengan gravitasi
      notInAir = false; //objek pemain tidak di udara, menghentikan "jump()" dari bekerja
    } else {
      notInAir = true; //jika pemain berada di "lantai" = true, memungkinkan "jump()" berfungsi
    }

    //lompatan dipicu oleh metode "jump()"
    if (isJumping) {
      _PlayerY -= 12; //meningkatkan posisi y pemain, mensimulasikan lompatan
      jumpCounter += 1; //meningkatkan jumpCounter, yang menentukan kapan lompatan berhenti
    }
    if (jumpCounter >= jumpCounterLimit) { //ketika penghitung mencapai batas, lompatan berhenti
      isJumping = false;
      jumpCounter = 0; //penghitung diatur ulang
    }
    //berputar saat di udara
    if (!notInAir) {
      jumpAngle += incrementAngle; //meningkatkan jumpAngle, mengaktifkan rotasi dalam "display()"
    }
    if (notInAir) {
      jumpAngle = 0; //mengatur ulang jumpAngle sehingga objek Player selalu sejajar saat di "lantai"
    }
  }

  //metode get untuk digunakan saat memeriksa tabrakan dengan rintangan
  int getX() {
    return _PlayerX + _PlayerSize/2; //mengembalikan lokasi koordinat depan pemain
  }
  int getY() {
    return _PlayerY + _PlayerSize/2; //mengembalikan lokasi koordinat bawah pemain
  }

  void display() { //ditempatkan dalam "draw()" untuk terus diperbarui
    pushMatrix(); //matriks diperlukan untuk mengandung transformasi rotasi

    rectMode(CENTER); //mengatur rectMode
    translate(_PlayerX, _PlayerY,1); //mengatur 0,0 menjadi di dalam dirinya sendiri, digunakan untuk rotasi yang benar
    rotate(jumpAngle); //selalu berputar, tetapi jumpAngle diatur ke 0, yang berarti tidak berputar

    strokeWeight(2);
    stroke(22, 85, 60);
    fill(53, 240, 165);
    square(0, 0, _PlayerSize);

    popMatrix(); //matriks diperlukan untuk mengandung transformasi rotasi
  }
}
