import processing.sound.*;
//mendeklarasikan backsound
SoundFile backgroundMusic;
//mendeklarasikan sfx sound
SoundFile sfxJump;
SoundFile sfxDeath;

//mendeklarasikan hero (pemain)
Player hero;

//mendeklarasikan obstacles (rintangan)
Obstacle[] obstacles = new Obstacle[300]; //Seperti yang mungkin Anda duga, ya, ada BANYAK rintangan.
//Perlu diperhatikan bahwa tidak semua 300 objek rintangan sebenarnya digunakan, tetapi lebih baik memiliki lebih banyak daripada kurang,
//untuk berjaga-jaga jika Anda ingin menambahkan lebih banyak rintangan.

//deklarasi class game
Game game = new Game();

//deklarasi class menu
Menu menu = new Menu();

boolean isPlaying = false; //kondisi sebelum masuk kedalam game
boolean isPause = false; //kondisi untuk mem-pause game
PImage img; // inisiasi PImage
PFont font; // insiasi font



void setup() {
  size(1000, 600, P3D);

  img = loadImage("image.jpg"); // mengambil gambar yang sudah ditambahkan ke directory 'data'

  font = createFont("Press Start 2P", 32); // memilig font yang tersedia di dekstop dan memberi parameter smooth nya
  textFont(font); // mengganti font yang sebelum nya sudah dipilih

  //menginisialisasi musik latar
  backgroundMusic = new SoundFile(this, "backgroundmusic.mp3");
  backgroundMusic.play();
  backgroundMusic.amp(0.2); //amplitudo di gunakan untuk mengatur volume (scale 0-1)
  backgroundMusic.rate(1.25); // mengatur kecepatan pemutaran sound
  //menginisialisasi suara kematian
  sfxJump = new SoundFile(this, "jump.mp3");
  sfxDeath = new SoundFile(this, "death.mp3");
  //menginisialisasi hero (pemain)
  hero = new Player(150, 524, 50); //memiliki parameter x, y, dan ukuran; y dan ukuran sebaiknya tidak diubah
  //menginisialisasi rintangan
  for (int i = 0; i < 300; i++) {
    obstacles[i] = new Obstacle(1000); //disetel ke 1000, yang merupakan tepi kanan layar
  }
}

void draw() {
  if (!isPlaying) {

    menu.display();
  } else {
    if (!isPause) {


      game.display();
    } else {

      game.pause();
    }
  }
}

void keyPressed() {
  switch(key) {
    //melompat (menggunakan W)
  case 'w': //saat 'w' ditekan
    if (isPlaying) {
      hero.jump();
    }

    break;

    //melompat (menggunakan Spasi)
  case ' ': //saat tombol spasi ditekan
    if (isPlaying) {
      hero.jump();
    }
    break;


  case 'r':
    if (isPause) {
      game.reset();
      game.display();
      isPause = false;
    }

  case 'p':
    if (isPause) {
      isPlaying = false;
      isPause = false;
      game.reset();
      menu.display();
    }
  }
  switch(keyCode) {
    //melompat (menggunakan Panah Atas)
  case UP: //saat 'Panah Atas' ditekan

    if (isPlaying) {
      hero.jump();
    }

    break;

  case BACKSPACE:
    if (!isPause && isPlaying) {
      isPause = true;
      if (backgroundMusic.isPlaying()) {
        backgroundMusic.pause();
      }
    } else {
      isPause = false;
      if (!backgroundMusic.isPlaying()) {
        backgroundMusic.amp(0.2);
        backgroundMusic.play();
      }
    }
  }
}

void mouseClicked() {
  if (menu.overBox1) {
    isPlaying = true;
  }

  if (menu.overBox2) {
    print("test");
  }
}
