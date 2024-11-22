class Particle {
  float x, y;
  float speedX, speedY;
  float size;
  float alpha;
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-1, 1);
    this.speedY = random(-3, -1);  // Moving upward
    this.size = random(2, 4);
    this.alpha = 255;
  }
  
  void update() {
    x += speedX;
    y += speedY;
    alpha -= 1.5;
  }
  
  void display() {
    noStroke();
    fill(0, 255, 0, alpha);
    circle(x, y, size);
  }
  
  boolean isDead() {
    return alpha <= 0;
  }
}

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
  
  // Background elements
  color[] sunColors;
  PImage bgTexture;
  PImage titleText;
  boolean assetsLoaded = false;
  
  Menu() {
    particles = new ArrayList<Particle>();
    
    // Initialize sun gradient colors
    sunColors = new color[]{
      color(255, 50, 150),  // Pink
      color(255, 100, 200), // Light pink
      color(150, 50, 255)   // Purple
    };
  }
  
  void loadAssets() {
    if (!assetsLoaded) {
      // Load images - update path according to your project structure
      bgTexture = loadImage("data/bg.jpg");
      titleText = loadImage("data/txt.png");
      assetsLoaded = true;
    }
  }
  
  void update() {
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
      particles.add(new Particle(random(width), height - 50));
    }
    
    // Update hover states
    updateHoverStates();
  }
  
  void display() {
    if (!assetsLoaded) {
      loadAssets();
    }
    
    // Draw starry background
    if (bgTexture != null) {
      image(bgTexture, 0, 0, width, height);
    } else {
      background(40, 45, 60);  // Fallback background
    }
    
    // Draw sun
    drawRetroSun();
    
    // Draw grid
    drawGrid();
    
    // Draw mountain landscape
    drawMountains();
    
    // Display particles
    for (Particle p : particles) {
      p.display();
    }
    
    // Draw title
    if (titleText != null) {
      image(titleText, width/2 - titleText.width/2, 50);
    }
    
    // Draw buttons
    update();
    drawButton("PLAY", xButton1, yButton1, overBox1);
    drawButton("SETTINGS", xButton2, yButton2, overBox2);
  }
  
  void drawRetroSun() {
    // Draw sun circle
    noStroke();
    for (int i = 0; i < 3; i++) {
      fill(sunColors[i]);
      ellipse(width/2, height/2 - 50, 200 - i*20, 200 - i*20);
    }
    
    // Draw sun lines
    stroke(150, 50, 255, 100);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float y = height/2 - 30 + i * 10;
      line(width/2 - 100, y, width/2 + 100, y);
    }
  }
  
  void drawGrid() {
    stroke(0, 150, 255, 100);
    strokeWeight(1);
    
    // Draw horizontal lines
    for (int i = 0; i < 20; i++) {
      float y = height - 50 + i * 20;
      line(0, y, width, y);
    }
    
    // Draw vertical lines
    for (int i = 0; i < width/20; i++) {
      float x = i * 20;
      line(x, height - 50, x, height);
    }
  }
  
  void drawMountains() {
    stroke(0, 255, 0);
    strokeWeight(2);
    noFill();
    
    // Draw wireframe mountains
    beginShape();
    for (int x = 0; x < width; x += 50) {
      float y = noise(x * 0.01) * 100 + height/2;
      vertex(x, y);
      
      // Add internal lines for wireframe effect
      if (x > 0) {
        for (int i = 1; i < 3; i++) {
          float prevY = noise((x-50) * 0.01) * 100 + height/2;
          line(x-50, prevY, x, y);
        }
      }
    }
    endShape();
  }
  
  void drawButton(String label, int x, int y, boolean isHovered) {
    pushStyle();
    
    // Button background
    strokeWeight(3);
    if (isHovered) {
      fill(255, 50, 150);
      stroke(255, 100, 200);
    } else {
      fill(200, 50, 150);
      stroke(150, 50, 100);
    }
    
    // Custom button shape with retro style
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
    fill(255);
    noStroke();
    text(label, x + wSize/2, y + hSize/2);
    
    popStyle();
  }
  
  void updateHoverStates() {
    overBox1 = mouseX >= xButton1 && mouseX <= xButton1+wSize && 
               mouseY >= yButton1 && mouseY <= yButton1+hSize;
    overBox2 = mouseX >= xButton2 && mouseX <= xButton2+wSize && 
               mouseY >= yButton2 && mouseY <= yButton2+hSize;
  }
}
