
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  size(640, 360); 
  noStroke();
  rectMode(CENTER);
  
  frameRate(125);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
}

void draw() {
  background(51); 
  fill(255, 204);
  rect(mouseX, height/2, mouseY/2+10, mouseY/2+10);
  fill(255, 204);
  int inverseX = width-mouseX;
  int inverseY = height-mouseY;
  rect(inverseX, height/2, (inverseY/2)+10, (inverseY/2)+10);

  OscMessage myMessage = new OscMessage("/pos");
  myMessage.add(mouseX/(float)width);
  myMessage.add(mouseY/(float)height);
  oscP5.send(myMessage, myRemoteLocation); 
  myMessage.print();
}