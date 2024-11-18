//mengimpor pustaka soundfile
import processing.sound.*;
//mendeklarasikan backgroundMusic (musik latar)
SoundFile backgroundMusic;
//mendeklarasikan deathNoise (suara mati)
SoundFile deathNoise;

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


void setup() {
  size(1000, 600);
  //menginisialisasi musik latar
  backgroundMusic = new SoundFile(this, "Dance of the Pixies.mp3");
  backgroundMusic.play();
  //menginisialisasi suara kematian
  deathNoise = new SoundFile(this, "Death Noise.wav");
  deathNoise.rate(1.10); //mengubah kecepatan pemutaran, karena processing tampaknya memutarnya sedikit terlalu lambat
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
    hero.jump();
    break;

    //melompat (menggunakan Spasi)
  case ' ': //saat tombol spasi ditekan
    hero.jump();
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
    hero.jump();
    break;

  case BACKSPACE:
    if (!isPause) {
      isPause = true;
    } else {
      isPause = false;
      backgroundMusic.play();
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
