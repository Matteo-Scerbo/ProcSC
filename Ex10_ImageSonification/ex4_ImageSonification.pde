
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


PImage img;
color c;


void setup()
{
  size(900,600);
  img = loadImage("img.jpg");
  
    frameRate(125);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
}



void draw()
{  
  image(img,0,0);
  c = img.get(mouseX,mouseY);
   //println("hue: "+hue(c)+" - saturation: "+saturation(c)+" brightness :"+brightness(c));
   
  OscMessage myMessage = new OscMessage("/color");
  myMessage.add(hue(c)/256); /* add an int to the osc message */
  myMessage.add(saturation(c)/256); /* add a float to the osc message */
  myMessage.add(brightness(c)/256); /* add a float to the osc message */
  oscP5.send(myMessage, myRemoteLocation); 
  myMessage.print();
   
   
}