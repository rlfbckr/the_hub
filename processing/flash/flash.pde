import processing.sound.*;
import oscP5.*;
import netP5.*;


WhiteNoise noise;

boolean state = true;
long flash_start = 0;
int flash_duration = 0;
int myscreen = -1;
int  maxscreen = 20;
OscP5 oscP5;
float amp = 0;

void setup() {
    fullScreen();
//    size(500, 500);
    oscP5 = new OscP5(this, 12001);
    noise = new WhiteNoise(this);
    noise.play();
    noise.amp(0);
}

void draw() {
    if (myscreen == -1) {
        textAlign(RIGHT, BOTTOM);
        drawSelectScreen();
    } else {
        textAlign(CENTER, CENTER);
        drawFlash();
    }

}



void drawFlash() {
    if (state == true) {
        background(255);
        textSize(200);
        fill(0);
        text(myscreen, width / 2, (height / 2) - 40);
    } else {
        background(0);
        textSize(200);
        fill(255);
        text(myscreen, width / 2, (height / 2) - 40);
    }
    if (abs(millis() - flash_start) > flash_duration ) {
        state = false;
        noise.amp(0);
    }
}


void drawSelectScreen() {
    background(0);
    fill(255, 255, 255);
    textSize(60);
    text("Please Select your Screen:", width / 2, 100);
    textSize(20);

    for (int i = 0; i < maxscreen; i++) {
        stroke(255);
        fill(0);
        if ((mouseX > 100 + (i * 40)) && (mouseX < 100 + (i * 40) + 30)) {
            fill(255, 0, 0);
            if (mousePressed) {
                myscreen = i;
            }
        }
        rect(100 + (i * 40), 150, 30, 30);
        fill(255);
        text(i, 100 + (i * 40) + 13, 172);

    }

}

void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern("/f") == true) {
        if (theOscMessage.checkTypetag("ii")) {
            int target_screen =  theOscMessage.get(0).intValue();
            if (target_screen == -1 || target_screen == myscreen) {
                flash_duration =  theOscMessage.get(1).intValue();
                state = true;
                noise.amp(1);
                flash_start = millis();
            }
        }
    }

}

