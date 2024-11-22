class Game {
  //mendeklarasikan variabel global
  int timer = second(); //digunakan untuk skor dan mengatur waktu rintangan
  int deathCounter = 0; //digunakan untuk melacak kematian (dapat direset secara manual juga)
  int highScore = 0; //membuat penghitung yang digunakan untuk menampilkan skor tertinggi pemain
  int fade = 0; //digunakan untuk efek memudar ke gelap saat pemain menang

  boolean isOver = false; //digunakan untuk mengecek game selesai

  boolean buttonPressed = false;
  boolean soundOn = true; 
  boolean sfxOn = true;


  void pause() {

    background(0);


    // tombol sound off / on
    float boxX = width / 2;
    float boxY = height / 2;

    float blockWidth = 190;
    float blockHeight = 75;
    float blockDepth = 50;

    pushMatrix();
    translate(boxX, boxY, 0);
    if (buttonPressed) {
      fill(255, 50, 150); // Tombol ditekan
      soundOn = false;
    } else {
      fill(200, 50, 150);
      soundOn = true;
    }
    stroke(0);
    box(blockWidth, blockHeight, blockDepth); // Gambar balok dengan dimensi tertentu



    if (soundOn) {
      translate(-85, 10, 50);
      fill(0); // Warna teks
      textSize(16);
      text("SOUND : ON", 0, 0); // Teks di posisi tengah tombol
      if (!backgroundMusic.isPlaying()) {
        backgroundMusic.play();
        backgroundMusic.amp(0.5);
        sfxOn = true;
      }
    } else {
      translate(-85, 10, 50);
      fill(0); // Warna teks
      textSize(16);
      text("SOUND : OFF", 0, 0); // Teks di posisi tengah tombol
      if (backgroundMusic.isPlaying()) {
        backgroundMusic.pause();
        sfxOn = false;
      }
    }

    popMatrix();



    // Reuse the particle initialization from Menu
    if (!menu.initialized) {
      menu.init();
    }

    // Load background and assets if not already loaded
    if (!menu.assetsLoaded) {
      menu.loadAssets();
    }

    // Display background
    if (menu.bgTexture != null) {
      image(menu.bgTexture, 0, 0, width, height);
    } else {
      background(40, 45, 60);
    }

    // Update and display particles
    for (Point3D p : menu.particles) {
      p.update();
      p.display();
    }

    // Display pause image text
    PImage pauseText = loadImage("pause.png");
    if (pauseText != null) {
      float maxWidth = width * 0.90;
      float maxHeight = height * 0.65;

      float scaleW = maxWidth / pauseText.width;
      float scaleH = maxHeight / pauseText.height;
      float scale = min(scaleW, scaleH);

      float textWidth = pauseText.width * scale;
      float textHeight = pauseText.height * scale;

      float textX = (width - textWidth) / 2;
      float textY = (height ) - textHeight - 250;

      image(pauseText, textX, textY, textWidth, textHeight);
    }

    // Draw buttons
    int buttonWidth = 200;
    int buttonHeight = 50;
    int buttonX = (width - buttonWidth) / 2;

    // Button hover states
    boolean overRestartButton = mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
      mouseY >= 350 && mouseY <= 350 + buttonHeight;
    boolean overMainMenuButton = mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
      mouseY >= 420 && mouseY <= 420 + buttonHeight;

    // Draw Restart button
    pushStyle();
    if (overRestartButton) {
      noStroke();
      fill(255, 50, 150);
    } else {
      noStroke();
      fill(200, 50, 150);
    }
    strokeWeight(2);
    rect(buttonX, 350, buttonWidth, buttonHeight, 10);

    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("RESTART", buttonX + buttonWidth/2, 350 + buttonHeight/2);
    popStyle();

    // Draw Main Menu button
    pushStyle();
    if (overMainMenuButton) {
      fill(255, 50, 150);
      noStroke();
    } else {
      fill(200, 50, 150);
      noStroke();
    }
    strokeWeight(2);
    rect(buttonX, 420, buttonWidth, buttonHeight, 10);

    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("MENU", buttonX + buttonWidth/2, 420 + buttonHeight/2);
    popStyle();
  }

  // Add this method to handle button clicks during pause
  void pauseMousePressed() {
    int buttonWidth = 200;
    int buttonHeight = 50;
    int buttonX = (width - buttonWidth) / 2;

    // Restart button
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
      mouseY >= 350 && mouseY <= 350 + buttonHeight) {
      reset();
      display();
      isPause = false;
    }

    // Main Menu button
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth &&
      mouseY >= 420 && mouseY <= 420 + buttonHeight) {
      isPlaying = false;
      isPause = false;
      reset();
      menu.display();
    }
  }

  void display() {

    push();
    //latar belakang
    scenery();

    //rintangan
    for (int i = 0; i < 300; i++) {
      obstacles[i].move(4); //menginisialisasi kecepatan gerak untuk semua rintangan
    }
    obstacleSpawn(); //memunculkan rintangan (berdasarkan timer)
    collision(); //memeriksa tabrakan antara rintangan dan hero (pemain)

    //hero (pemain)
    hero.display();
    hero.physics();

    //timer, papan skor, dan tampilan kontrol
    timer();

    if (!isOver) {
      scoreboard();
      displayControls();
    }

    pop();
  }

  void collision() {
    //tabrakan dengan paku
    for (int i = 0; i < 300; i++) {
      if (hero.getX() > obstacles[i].spikeGetX1() && hero.getX() < obstacles[i].spikeGetX2()) {
        if (hero._PlayerY > obstacles[i].spikeGetY1() && hero._PlayerY < obstacles[i].spikeGetY2()) {
          println("tertusuk Paku");
          if (game.sfxOn) {// untuk mengecek tombol sound on/off
            sfxDeath.play();
          }

          backgroundMusic.stop();
          delay(2900);
          reset();
        }
      }
      //tabrakan dengan kotak
      if (hero.getX() > obstacles[i].squareGetX1() && hero.getX() < obstacles[i].squareGetX2()) {
        //jika pemain menabrak bagian depan kotak
        if (hero._PlayerY > obstacles[i].squareGetY1() && hero._PlayerY < obstacles[i].squareGetY2()) {
          println("tertabrak Kotak");
          if (game.sfxOn) { // untuk mengecek tombol sound on/off
            sfxDeath.play();
          }
          backgroundMusic.stop();
          delay(2900); // mendelay selama 2.9 detik
          reset();
        }
        if (hero.getY() < obstacles[i].squareGetY1()) { //jika pemain menabrak bagian atas kotak
          hero._startY = obstacles[i].squareGetY1()-26;
        }
      }
      if (hero.getX() > obstacles[i].squareGetX2() && !obstacles[i]._ignore) { //mereset nilai "lantai"
        hero._startY = 524;
        obstacles[i].ignore(); //mengatur _ignore ke true
      }
    }
  }

  void timer() { //timer digunakan untuk menentukan skor dan pemunculan rintangan
    //Catatan untuk diri sendiri: panjang lagu adalah 12000 pada timer
    timer += 1;
    //println(timer); //cetak timer, berguna saat Anda menambahkan rintangan di pemunculan
  }

  void reset() { //mereset permainan kembali ke awal
    //memutar ulang musik dari awal
    if(soundOn){
      backgroundMusic.play();
      backgroundMusic.amp(0.5);
    }
    
    //mereset timer
    timer = 0;
    //mereset rintangan
    for (int i = 0; i < 300; i++) {
      obstacles[i] = new Obstacle(1000);
    }
    //mereset "lantai"
    hero._startY = 524;
    //meningkatkan penghitung kematian (digunakan untuk melacak kematian)
    deathCounter += 1;
    //mereset efek memudar saat menang
    fade = 0;
  }

  void scoreboard() { //papan skor yang melacak jarak terjauh yang ditempuh
    if (timer > highScore) {
      highScore = timer;
    }
    textAlign(CENTER);
    //tampilan skor tertinggi
    textSize(15);
    fill(255);
    text("Skor Tertinggi: "+highScore/60, 800, 50); //skor tertinggi dibagi 60 sehingga setiap detik = 1 poin
    //tampilan penghitung kematian
    fill(255);
    textSize(15);
    text(deathCounter, 500, 60);
  }

  void displayControls() {
    //menampilkan kontrol hingga timer mencapai 250, yaitu hingga menemui rintangan pertama
    if (timer < 250) {
      textAlign(CENTER);
      textSize(12);
      fill(255);
      text("LOMPAT: PANAH ATAS, W, atau SPASI", 220, 50);
      text("BACKSPACE: PAUSE GAME", 220, 80);
    } else { //menampilkan skor saat ini
      textAlign(CENTER);
      textSize(15);
      fill(255);
      text("Skor saat ini: "+timer/60, 200, 50);
    }
  }

  void scenery() {
    background(20, 24, 82);

    //latar papan score
    push();
    fill(0);
    noStroke();
    rect(0, 0, 1000, 90);

    pop();

    push();
    translate(0, 100);

    // gambar bulan
    push();
    fill(255, 255, 150); // Warna kuning terang untuk bulan
    arc(697, 117, 100, 100, radians(45), radians(225)); // menentukan nilai radians berdasarkan besaran derajat
    pop();

    // gambar awan
    push();
    cloudCircle(118, 118, 60);
    cloudEllipse(369, 118, 50);
    cloudEllipse(868, 118, 55);
    pop();


    // gambar rumah
    push();
    noStroke();
    fill(#D68759);
    quad(455, 327, 500, 327, 530, 350, 430, 350);
    fill(#AA0D05);
    rect(441, 350, 80, 40);
    pop(); //akhir gambar rumah


    // gambar bukit
    push();

    fill(#729BBC);
    //stroke(255);
    //noFill();
    beginShape();
    vertex(0, 412);
    vertex(182, 285);
    vertex(235, 215);
    curveVertex(235, 215);
    curveVertex(235, 215);
    curveVertex(269, 195);
    curveVertex(293, 219);
    curveVertex(293, 219);
    vertex(293, 219);
    vertex(302, 254);
    vertex(418, 372);
    vertex(592, 392);
    vertex(689, 348);
    bezierVertex(809, 227, 873, 263, 921, 361);
    vertex(965, 399);
    vertex(1000, 411);
    vertex(1000, 557);
    vertex(0, 557);
    vertex(0, 412);
    endShape();

    pop();



    // gambar bintang dan rasi bintang
    push();
    stars(207, 54);
    stars(210, 85);
    stars(305, 57);
    stars(425, 54);
    stars(485, 76);
    stars(538, 105);
    stars(525, 27);
    stars(276, 125);
    stars(55, 43);
    stars(696, 32);
    stars(771, 42);
    stars(750, 72);
    stars(820, 31);
    stars(29, 88);
    stars(926, 33);
    stars(967, 82);

    //rasi bintang
    push();
    strokeCap(ROUND);
    stroke(#FFEC12);
    strokeWeight(2);
    line(525, 26, 538, 104);
    line(538, 104, 486, 76);
    line(486, 76, 426, 54);
    line(426, 54, 304, 55);
    line(304, 55, 277, 125);
    line(304, 55, 211, 83);
    pop();

    pop();

    pop();


    // lantai player
    push();
    noStroke();
    fill(#06CB3F);
    rect(0, 552, 1000, 20);
    fill(#A05C0A);
    rect(0, 570, 1000, 50);
    pop();
  }

  void gameComplete() {
    //memudar ke hitam dengan bertindak sebagai peningkatan alpha untuk rect yang menutupi layar
    translate(0, 0, 10);
    noStroke();
    fill(0, 0, 0, fade);
    rectMode(CENTER);
    rect(500, 300, 1000, 600);
    fade += 1;
    //teks "Anda Menang"
    textAlign(CENTER);
    textSize(50);
    fill(random(255), random(255), random(255));
    text("Anda Menang!", 500, 300);
  }




  void cloudCircle(float x, float y, float size) {
    noStroke();
    fill(255); // Warna putih untuk awan
    circle(x, y, size);               // Lingkaran utama
    circle(x - size * 0.5, y, size * 0.7); // Lingkaran kiri
    circle(x + size * 0.5, y, size * 0.7); // Lingkaran kanan
    circle(x, y - size * 0.4, size * 0.8); // Lingkaran atas
  }



  void cloudEllipse(float x, float y, float size) {
    noStroke();
    fill(255); // Warna putih untuk awan
    ellipse(x, y, size, size);               // Lingkaran utama
    ellipse(x - size * 0.5, y, size * 0.7, size * 0.7); // Lingkaran kiri
    ellipse(x + size * 0.5, y, size * 0.7, size * 0.7); // Lingkaran kanan
    ellipse(x, y - size * 0.4, size * 0.8, size * 0.8); // Lingkaran atas
  }


  void stars(int x, int y) {
    stroke(#FFEC12);
    strokeWeight(8);
    point(x, y);
  }



  void obstacleSpawn() {//memunculkan rintangan berdasarkan timer (bagian kode ini sangat panjang)

    if (timer > 150) {
      obstacles[1].spike(550);
    }
    if (timer > 250) {
      obstacles[2].spike(550);
    }
    if (timer > 350) {
      obstacles[3].spike(550);
    }
    if (timer > 450) {
      obstacles[4].spike(550);
    }
    if (timer > 525) {
      obstacles[5].spike(550);
    }
    if (timer > 600) {
      obstacles[6].spike(550);
    }
    //===============(600 = 10s)===============
    if (timer > 675) {
      obstacles[7].spike(550);
    }
    if (timer > 682) {
      obstacles[8].spike(550);
    }
    if (timer > 750) {
      obstacles[1].square(525);
    }
    if (timer > 780) {
      obstacles[2].square(475);
    }
    if (timer > 810) {
      obstacles[3].square(425);
    }
    if (timer > 845) {
      obstacles[4].square(375);
    }
    if (timer > 850) {
      obstacles[9].spike(550);
    }
    if (timer > 858) {
      obstacles[10].spike(550);
    }
    if (timer > 866) {
      obstacles[11].spike(550);
    }
    if (timer > 874) {
      obstacles[12].spike(550);
    }
    if (timer > 880) {
      obstacles[5].square(375);
    }
    if (timer > 882) {
      obstacles[13].spike(550);
    }
    if (timer > 930) {
      obstacles[6].square(375);
    }
    if (timer > 965) {
      obstacles[14].spike(550);
    }
    if (timer > 1005) {
      obstacles[15].spike(550);
    }
    if (timer > 1080) {
      obstacles[7].square(525);
    }
    if (timer > 1120) {
      obstacles[8].square(475);
    }
    if (timer > 1160) {
      obstacles[9].square(525);
    }
    if (timer > 1200) {
      obstacles[10].square(475);
    }
    //===============(1200 = 20s)===============
    if (timer > 1240) {
      obstacles[11].square(525);
    }
    if (timer > 1276) {
      obstacles[16].spike(450);
    }
    if (timer > 1280) {
      obstacles[12].square(475);
    }
    if (timer > 1330) {
      obstacles[13].square(525);
    }
    if (timer > 1338) {
      obstacles[17].spike(550);
    }
    if (timer > 1346) {
      obstacles[18].spike(550);
    }
    if (timer > 1354) {
      obstacles[19].spike(550);
    }
    if (timer > 1362) {
      obstacles[20].spike(550);
    }
    if (timer > 1450) {
      obstacles[14].square(525);
    }
    if (timer > 1500) {
      obstacles[15].square(475);
    }
    if (timer > 1524) {
      obstacles[16].square(525);
    }
    if (timer > 1572) {
      obstacles[21].spike(550);
    }
    if (timer > 1650) {
      obstacles[22].spike(550);
    }
    if (timer > 1658) {
      obstacles[23].spike(550);
    }
    if (timer > 1730) {
      obstacles[26].spike(550);
    }
    if (timer > 1738) {
      obstacles[27].spike(550);
    }
    //===============(1800 = 30s)===============
    if (timer > 1830) {
      obstacles[29].spike(550);
    }
    if (timer > 1838) {
      obstacles[30].spike(550);
    }
    if (timer > 1940) {
      obstacles[33].spike(550);
    }
    if (timer > 2000) {
      obstacles[34].spike(550);
    }
    if (timer > 2008) {
      obstacles[35].spike(550);
    }
    if (timer > 2080) {
      obstacles[38].spike(550);
    }
    if (timer > 2088) {
      obstacles[39].spike(550);
    }
    if (timer > 2160) {
      obstacles[17].square(525);
    }
    if (timer > 2200) {
      obstacles[18].square(475);
    }
    if (timer > 2220) {
      obstacles[40].spike(500);
      obstacles[41].spike(550);
    }
    if (timer > 2240) {
      obstacles[19].square(475);
    }
    if (timer > 2275) {
      obstacles[20].square(425);
    }
    if (timer > 2310) {
      obstacles[21].square(375);
    }
    if (timer > 2345) {
      obstacles[22].square(325);
    }
    if (timer > 2365) {
      obstacles[23].square(375);
    }
    if (timer > 2400) {
      obstacles[24].square(325);
    }
    //===============(2400 = 40s)===============
    if (timer > 2414) {
      obstacles[42].spike(550);
    }
    if (timer > 2422) {
      obstacles[43].spike(550);
    }
    if (timer > 2430) {
      obstacles[44].spike(550);
    }
    if (timer > 2438) {
      obstacles[45].spike(550);
    }
    if (timer > 2550) {
      obstacles[25].square(525);
    }
    if (timer > 2590) {
      obstacles[26].square(475);
    }
    if (timer > 2630) {
      obstacles[27].square(525);
    }
    if (timer > 2670) {
      obstacles[28].square(475);
    }
    if (timer > 2706) {
      obstacles[46].spike(550);
    }
    if (timer > 2714) {
      obstacles[47].spike(550);
    }
    if (timer > 2760) {
      obstacles[29].square(525);
    }
    if (timer > 2800) {
      obstacles[30].square(475);
    }
    if (timer > 2840) {
      obstacles[31].square(525);
    }
    if (timer > 2880) {
      obstacles[32].square(475);
    }
    if (timer > 2916) {
      obstacles[48].spike(550);
    }
    if (timer > 2924) {
      obstacles[49].spike(550);
    }
    if (timer > 2970) {
      obstacles[33].square(525);
    }
    //===============(3000 = 50s)===============
    if (timer > 3010) {
      obstacles[34].square(475);
    }
    if (timer > 3050) {
      obstacles[35].square(525);
    }
    if (timer > 3090) {
      obstacles[36].square(475);
    }
    if (timer > 3125) {
      obstacles[37].square(425);
    }
    if (timer > 3130) {
      obstacles[50].spike(550);
    }
    if (timer > 3138) {
      obstacles[51].spike(550);
    }
    if (timer > 3146) {
      obstacles[52].spike(550);
    }
    if (timer > 3154) {
      obstacles[53].spike(550);
    }
    if (timer > 3160) {
      obstacles[38].square(375);
    }
    if (timer > 3250) {
      obstacles[55].spike(550);
    }
    if (timer > 3258) {
      obstacles[56].spike(550);
    }
    if (timer > 3274) {
      obstacles[39].square(525);
    }
    if (timer > 3282) {
      obstacles[57].spike(550);
    }
    if (timer > 3290) {
      obstacles[58].spike(550);
    }
    if (timer > 3350) {
      obstacles[59].spike(550);
    }
    if (timer > 3358) {
      obstacles[60].spike(550);
    }
    if (timer > 3374) {
      obstacles[40].square(525);
    }
    if (timer > 3382) {
      obstacles[61].spike(550);
    }
    if (timer > 3390) {
      obstacles[62].spike(550);
    }
    if (timer > 3450) {
      obstacles[63].spike(550);
    }
    if (timer > 3458) {
      obstacles[64].spike(550);
    }
    if (timer > 3474) {
      obstacles[41].square(525);
    }
    if (timer > 3482) {
      obstacles[65].spike(550);
    }
    if (timer > 3490) {
      obstacles[66].spike(550);
    }
    if (timer > 3540) {
      obstacles[67].spike(550);
    }
    if (timer > 3548) {
      obstacles[68].spike(550);
    }
    if (timer > 3564) {
      obstacles[42].square(525);
    }
    if (timer > 3572) {
      obstacles[69].spike(550);
    }
    if (timer > 3580) {
      obstacles[70].spike(550);
    }
    if (timer > 3800) {
      gameComplete();
      isOver = true;
    }
    if (timer > 4100) {
      delay(2000);
      isOver = false;
      reset();
    }
  }
}
