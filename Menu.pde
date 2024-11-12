class Menu {
  //deklarasi koordinat button
  int xButton1 = 370;
  int xButton2 = 370;
  int yButton1 = 300;
  int yButton2 = 380;
  
  //status jika kursor diluar button 
  boolean overBox1 = false;
  boolean overBox2 = false;

  //deklarasi ukuran button
  int wSize = 200;
  int hSize = 50;

  void display() {
    background(180);
    textSize(40);
    text("GEOMETRY DASH GAME", 270, 100);

    rect(xButton1, yButton1, wSize, hSize);
    rect(xButton2, yButton2, wSize, hSize);

    // perkondisian jika kursor diluar button
    if (mouseX >= xButton1 && mouseX <= xButton1+wSize && mouseY >= yButton1 && mouseY <= yButton1+hSize) {
      overBox1 = true;
    } else {
      overBox1 = false;
    }

    if (mouseX >= xButton2 && mouseX <= xButton2+wSize && mouseY >= yButton2 && mouseY <= yButton2+hSize) {
      overBox2 = true;
    } else {
      overBox2 = false;
    }
  }
}
