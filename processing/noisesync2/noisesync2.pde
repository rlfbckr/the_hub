import oscP5.*;
import netP5.*;
import java.net.*;

int myscreen = -1;
int noise_seed = 1;
long sync = 0;
int slices = 40;
int slices_of_other_screens = 20;
float t = 0;
float speed = 0.00001;
float spread = 0.01;
int  maxscreen = 20;
int fr = 25;

boolean _DEBUG_ = false;
int port = 12001;

OscP5 oscP5;

void setup() {
    //size(500, 500);
    fullScreen();
    oscP5 = new OscP5(this, port);
    frameRate(fr);
    slices = 1000 / fr;
    noiseDetail(1, 9.2);
}

void draw() {
    if (myscreen == -1) {
        drawSelectScreen();
    } else {
        drawNoise();
    }
}



void drawNoise() {
    background(0);
    stroke(255);
    noFill();
    for (int ts = -slices_of_other_screens; ts < slices + slices_of_other_screens; ts++) {
        beginShape();
        for (int y = 0 ; y < 50; y++) {
            float xpos = noise( ((myscreen * slices) + ts) * 0.1, y * 0.1, now()*speed);
            vertex( map(ts, -slices_of_other_screens, slices + slices_of_other_screens,0 - (width / slices) * slices_of_other_screens, width + (width / slices) * slices_of_other_screens) + map(xpos, 0, 1, -spread, spread), map(y, 0, 49, 0, height));
        }
        endShape();
    }

    if (_DEBUG_) {
        fill(0, 255, 255);
        text("myscreen     = " + myscreen + " / " + port, 20, 20);
        text("noise_seed   = " + noise_seed, 20, 50);
        text("now()        = " + now(), 20, 80);
        text("speed        = " + speed, 20, 110);
        text("spread       = " + spread, 20, 140);
        text("fps          = " + frameRate, 20, 170);
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
    if (theOscMessage.checkAddrPattern("/s") == true) {
        if (theOscMessage.checkTypetag("i")) {
            noise_seed =  theOscMessage.get(0).intValue();
            noiseSeed(noise_seed);
            sync = millis();
        }
    }
    if (theOscMessage.checkAddrPattern("/speed") == true) {
        if (theOscMessage.checkTypetag("f")) {
            speed =  theOscMessage.get(0).floatValue();
        }
    }
    if (theOscMessage.checkAddrPattern("/spread") == true) {
        if (theOscMessage.checkTypetag("f")) {
            spread =  theOscMessage.get(0).floatValue();
        }
    }

}

long now() {
    return (millis() - sync);
}

void keyReleased() {
    if (key == 'd') {
        _DEBUG_ = !_DEBUG_;
    }
}