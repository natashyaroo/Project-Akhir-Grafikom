// Kelas Menu yang mengatur tampilan menu utama
class Menu {
  // Koordinat dan dimensi tombol
  int xButton1 = 370;  // Posisi X tombol pertama
  int xButton2 = 370;  // Posisi X tombol kedua
  int yButton1 = 340;  // Posisi Y tombol pertama
  int yButton2 = 420;  // Posisi Y tombol kedua
  int wSize = 200;     // Lebar tombol
  int hSize = 50;      // Tinggi tombol
  
  // Status hover (apakah mouse berada di atas tombol)
  boolean overBox1 = false;
  boolean overBox2 = false;
  
  // Elemen-elemen latar belakang
  PImage bgTexture;    // Gambar latar belakang
  PImage titleText;    // Gambar teks judul
  boolean assetsLoaded = false; // Status apakah aset (gambar) sudah dimuat
  
  // Array untuk partikel (objek Point3D)
  ArrayList<Point3D> particles;
  boolean initialized = false; // Status inisialisasi partikel
  
  // Array warna untuk partikel
  color[] particleColors = {
    color(30, 144, 255),   // Biru
    color(255, 223, 0),    // Kuning
    color(147, 112, 219),  // Ungu
    color(50, 205, 50),    // Hijau
    color(255, 140, 0),    // Orange
    color(255, 69, 0)      // Merah
  };
  
  // Konstruktor Menu
  Menu() {
    particles = new ArrayList<Point3D>(); // Inisialisasi ArrayList untuk partikel
  }
  
  // Inisialisasi partikel jika belum dilakukan
  void init() {
    if (!initialized) {
      // Membuat partikel
      for (int i = 0; i < 150; i++) { // Mengurangi jumlah partikel agar lebih efisien
        particles.add(new Point3D(
          random(width),         // x acak
          random(height),        // y acak
          random(-100, 100),     // z acak
          particleColors[int(random(particleColors.length))] // Warna acak
        ));
      }
      initialized = true; // Tandai bahwa partikel sudah diinisialisasi
    }
  }
  
  // Memuat aset gambar seperti latar belakang dan teks judul
  void loadAssets() {
    if (!assetsLoaded) {
      bgTexture = loadImage("data/bg.jpg"); // Memuat gambar latar belakang
      titleText = loadImage("data/txt.png"); // Memuat gambar teks judul
      assetsLoaded = true; // Tandai bahwa aset sudah dimuat
    }
  }
  
  // Menampilkan elemen-elemen menu
  void display() {
    if (!initialized) {
      init(); // Inisialisasi partikel jika belum dilakukan
    }
    
    if (!assetsLoaded) {
      loadAssets(); // Memuat aset gambar jika belum dilakukan
    }
    
    // Menampilkan gambar latar belakang
    if (bgTexture != null) {
      image(bgTexture, 0, 0, width, height); // Menampilkan latar belakang
    } else {
      background(40, 45, 60); // Jika gambar latar tidak ditemukan, gunakan warna latar belakang default
    }
    
    // Mengupdate dan menampilkan partikel
    for (Point3D p : particles) {
      p.update(); // Mengupdate posisi partikel
      p.display(); // Menampilkan partikel
    }
    
    // Menampilkan gambar teks judul dengan skala yang sesuai
    if (titleText != null) {
      float maxWidth = width * 0.90;
      float maxHeight = height * 0.65;
      
      float scaleW = maxWidth / titleText.width; // Skala berdasarkan lebar
      float scaleH = maxHeight / titleText.height; // Skala berdasarkan tinggi
      float scale = min(scaleW, scaleH); // Pilih skala yang lebih kecil agar teks muat di layar
      
      float titleWidth = titleText.width * scale;
      float titleHeight = titleText.height * scale;
      
      // Menempatkan teks judul di tengah layar
      float titleX = (width - titleWidth) / 2 - 30;
      float titleY = (yButton1 + yButton2) / 2 - titleHeight - 20;
      
      image(titleText, titleX, titleY, titleWidth, titleHeight); // Menampilkan teks judul
    }
    
    // Menampilkan tombol-tombol dengan status hover yang diupdate
    updateHoverStates();
    drawButton("PLAY", xButton1, yButton1, overBox1); // Tombol Play
    drawButton("EXIT", xButton2, yButton2, overBox2); // Tombol Exit
  }
  
  // Fungsi untuk menggambar tombol dengan label tertentu
  void drawButton(String label, int x, int y, boolean isHovered) {
    pushStyle();
    
    // Mengatur warna tombol tergantung status hover
    if (isHovered) {
      fill(255, 50, 150); // Warna saat hover
      stroke(255, 100, 200); // Garis batas saat hover
    } else {
      fill(200, 50, 150); // Warna saat tidak hover
      stroke(150, 50, 100); // Garis batas saat tidak hover
    }
    
    // Menggambar tombol berbentuk persegi panjang
    strokeWeight(2);
    rect(x, y, wSize, hSize, 10); // Tombol dengan radius sudut 10
    
    // Menambahkan teks pada tombol
    fill(255); // Warna teks putih
    textSize(32); // Ukuran teks
    textAlign(CENTER, CENTER); // Posisi teks di tengah tombol
    text(label, x + wSize/2, y + hSize/2); // Menampilkan teks tombol
    
    popStyle();
  }
  
  // Memperbarui status hover tombol
  void updateHoverStates() {
    // Mengecek apakah mouse berada di atas tombol pertama atau kedua
    overBox1 = mouseX >= xButton1 && mouseX <= xButton1 + wSize && 
               mouseY >= yButton1 && mouseY <= yButton1 + hSize;
    overBox2 = mouseX >= xButton2 && mouseX <= xButton2 + wSize && 
               mouseY >= yButton2 && mouseY <= yButton2 + hSize;
  }
  
  // Menangani klik mouse untuk keluar jika tombol Exit ditekan
  void mousePressed() {
    if (overBox2) {
      exit(); // Keluar dari aplikasi jika tombol Exit ditekan
    }
  }
}

// Kelas Point3D untuk mendefinisikan partikel 3D
class Point3D {
  float x, y, z; // Posisi partikel
  float speed;    // Kecepatan partikel bergerak
  float breathingAngle; // Sudut untuk efek pernapasan (gerakan berdenyut)
  float size;     // Ukuran partikel
  color particleColor; // Warna partikel
  
  // Konstruktor untuk membuat partikel
  Point3D(float x, float y, float z, color c) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.speed = random(0.3, 1.2); // Kecepatan acak untuk gerakan partikel
    this.breathingAngle = random(TWO_PI); // Sudut acak untuk efek pernapasan
    this.size = random(2, 4);      // Ukuran acak partikel
    this.particleColor = c;        // Warna partikel yang diterima
  }
  
  // Mengupdate posisi partikel dan efek pernapasan
  void update() {
    y -= speed; // Menggerakkan partikel ke atas (mengurangi posisi Y)
    
    // Efek pernapasan (perubahan ukuran secara sinusoidal)
    breathingAngle += 0.05; // Memperbarui sudut pernapasan
    float breathingEffect = sin(breathingAngle) * 0.5; // Efek pernapasan
    size = 2 + breathingEffect; // Mengubah ukuran partikel berdasarkan efek pernapasan
    
    // Reset posisi saat partikel melewati bagian atas layar
    if (y < 0) {
      y = height; // Partikel muncul kembali di bagian bawah layar
      x = random(width); // Posisi acak untuk x
    }
    
    // Menambahkan gerakan horizontal yang halus
    x += sin(breathingAngle * 0.5) * 0.3; // Menambahkan gerakan horizontal acak
    
    // Menjaga partikel tetap dalam batas layar
    if (x < 0) x = width;
    if (x > width) x = 0;
  }
  
  // Menampilkan partikel di layar
  void display() {
    float screenX = x;
    float screenY = y;
    
    // Efek kedalaman berdasarkan posisi Z
    float depthEffect = map(z, -100, 100, 0.5, 1.5); // Mapping nilai Z ke efek kedalaman
    
    pushStyle();
    stroke(particleColor, 200); // Warna partikel dengan transparansi
    strokeWeight(size * depthEffect); // Mengatur ketebalan garis berdasarkan efek kedalaman
    point(screenX, screenY); // Menampilkan partikel sebagai titik
    popStyle();
  }
}
