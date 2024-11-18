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

    pointLight(0, 255, 0, mouseX, mouseY, 200);
    pointLight(0, 0, 255, xButton1, yButton1, 50);



    //text("X: "+mouseX+"   Y: "+mouseY, 50, 50);

    pushMatrix();
    textSize(40);
    text("GEOMETRY DASH GAME", 270, 100);
    popMatrix();

    rect(xButton1, yButton1, wSize, hSize);

    push();

    fill(0);
    text("PLAY", 422, 338);

    pop();

    // perkondisian jika kursor diluar button
    if (mouseX >= xButton1 && mouseX <= xButton1+wSize && mouseY >= yButton1 && mouseY <= yButton1+hSize) {
      overBox1 = true;
    } else {
      overBox1 = false;
    }
  }
}
