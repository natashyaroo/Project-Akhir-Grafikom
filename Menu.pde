class Menu {
  // Button coordinates and dimensions
  int xButton1 = 370;
  int xButton2 = 370;
  int yButton1 = 300;
  int yButton2 = 380;
  int wSize = 200;
  int hSize = 50;
  
  // Hover states
  boolean overBox1 = false;
  boolean overBox2 = false;
  
  // Particle system
  ArrayList<Particle> particles;
  float rotation = 0;
  
  Menu() {
    particles = new ArrayList<Particle>();
  }
  
  void update() {
    rotation += 0.02;
    
    // Update particles
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    
    // Add new particles
    if (frameCount % 5 == 0) {
      particles.add(new Particle(random(width), random(height)));
    }
    
    // Update hover states
    updateHoverStates();
  }
  
  void updateHoverStates() {
    // Check if mouse is over play button
    if (mouseX >= xButton1 && mouseX <= xButton1+wSize && 
        mouseY >= yButton1 && mouseY <= yButton1+hSize) {
      overBox1 = true;
    } else {
      overBox1 = false;
    }
    
    // Check if mouse is over settings button
    if (mouseX >= xButton2 && mouseX <= xButton2+wSize && 
        mouseY >= yButton2 && mouseY <= yButton2+hSize) {
      overBox2 = true;
    } else {
      overBox2 = false;
    }
  }
  
  void display() {
    background(40, 45, 60);
    
    // Display particles
    for (Particle p : particles) {
      p.display();
    }
    
    // Title with geometric background
    pushMatrix();
    translate(width/2, 80);
    rotate(rotation);
    noFill();
    strokeWeight(3);
    stroke(120, 255, 120, 100);
    polygon(0, 0, 80, 5);
    popMatrix();
    
    // Title text
    textAlign(CENTER);
    textSize(50);
    fill(120, 255, 120);
    strokeWeight(4);
    stroke(50, 200, 50);
    text("GEOMETRY DASH", width/2, 120);
    
    // Draw buttons
    update();
    drawButton("PLAY", xButton1, yButton1, overBox1);
    drawButton("SETTINGS", xButton2, yButton2, overBox2);
    
    // Version text
    textAlign(LEFT);
    textSize(12);
    fill(120, 255, 120);
    noStroke();
    text("v1.0", 10, height - 10);
  }
  
  void drawButton(String label, int x, int y, boolean isHovered) {
    pushStyle();
    
    // Button background
    strokeWeight(3);
    if (isHovered) {
      fill(100, 255, 100);
      stroke(50, 200, 50);
    } else {
      fill(80, 200, 80);
      stroke(40, 160, 40);
    }
    
    // Custom button shape
    beginShape();
    vertex(x, y + 5);
    vertex(x + 5, y);
    vertex(x + wSize - 5, y);
    vertex(x + wSize, y + 5);
    vertex(x + wSize, y + hSize - 5);
    vertex(x + wSize - 5, y + hSize);
    vertex(x + 5, y + hSize);
    vertex(x, y + hSize - 5);
    endShape(CLOSE);
    
    // Button text
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(isHovered ? 40 : 255);
    noStroke();
    text(label, x + wSize/2, y + hSize/2);
    
    popStyle();
  }
  
  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}

class Particle {
  float x, y;
  float speedX, speedY;
  float size;
  float alpha;
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2);
    this.speedY = random(-2, 2);
    this.size = random(2, 6);
    this.alpha = 255;
  }
  
  void update() {
    x += speedX;
    y += speedY;
    alpha -= 2;
  }
  
  void display() {
    noStroke();
    fill(120, 255, 120, alpha);
    circle(x, y, size);
  }
  
  boolean isDead() {
    return alpha <= 0;
  }
}
