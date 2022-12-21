import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:to_csv/to_csv.dart' as exportCSV;

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'imu_appv2',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  double x=0, y=0, z=0, t=0;
  double xGyro=0, yGyro=0, zGyro=0;
  double xVel=0, yVel=0, zVel=0;
  double xPos=0, yPos=0, zPos=0;
  double d1=0,d2=0;
  //bool genCSV=false;

  List<List<String>> trajectoryPts = [];
  List<String> data1=[];

  List<String> header = ['x','y','z','xAcc','yAcc','zAcc'];

  @override

  void doIntegration(){
    t=0;
    xVel=0;yVel=0;zVel=0;
    xPos=0;yPos=0;zPos=0;
    trajectoryPts = [];

    const dt = Duration(milliseconds:100);
    double delT=0.1;
    double trackingPeriod=20;
    Timer.periodic(dt, (timer) {
      t=t+delT;

      //from the plots taken we see if yAcc > -9.5. it seems to indicate that the foot is on the ground
      //so every time yAcc > -9.5. all velocities are reset to zero.
      //this should eliminate some amount of drift


      if(y>-9.5 && _selections[1]){
        xVel=0;
        yVel=0;
        zVel=0;
      }else{
        xVel=xVel + x*delT;
        yVel=yVel + y*delT;
        zVel=zVel + z*delT;
      }

      xPos=xPos + xVel*delT;
      yPos=yPos + yVel*delT;
      zPos=zPos + zVel*delT;

      data1 = [xPos.toStringAsFixed(5),yPos.toStringAsFixed(5),zPos.toStringAsFixed(5),x.toStringAsFixed(5),y.toStringAsFixed(5)];
      trajectoryPts.add(data1);

      if(t>trackingPeriod){
        if(_selections[0]){
          exportCSV.myCSV(header,trajectoryPts);
        }
        timer.cancel();
      }
    });
  }

  List<bool> _selections = List.generate(2, (_)=>false);

  void initState() {
    // TODO: implement initState
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        d1 = (x).abs();
        d2 = (d1-9.8).abs();
        if(d1<d2){
          x = x+ 0.00309375 ;
        }else{
          x = x + 0.00375;
        }

        d1 = (y).abs();
        d2 = (d1-9.8).abs();
        if(d1<d2){
          y = y+ 0.235;
        }else{
          y = y - 0.0025;
        }

        d1 = (z).abs();
        d2 = (d1-9.8).abs();
        if(d1<d2){
          z = z+ 0.1175;
        }else{
          z = z + 0.01;
        }
      });
    });//get the sensor data and set then to the data types
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        xGyro = event.x;
        yGyro = event.y;
        zGyro = event.z;
      });
    });//get the sensor data and set then to the data types
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accelerometer and Gyro readings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleButtons(
                  children: [
                    Icon(Icons.file_download),
                    Icon(Icons.run_circle_outlined)
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                    });
                  },
                  color: Colors.grey,
                  selectedColor: Colors.blue
              ),
              Text("Get csv! ... Strapped to feet?", style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal),),
              ElevatedButton(
                child: Text("[0]", style: TextStyle(fontSize: 15),),
                onPressed: doIntegration
              ),
              Text(t.toStringAsFixed(5), style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal),),
              Text("Current xyz coordinates:("+xPos.toStringAsFixed(5)+","+yPos.toStringAsFixed(5)+","+zPos.toStringAsFixed(5)+")", style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal),),
              Text("velocity along xyz axes:("+xVel.toStringAsFixed(5)+","+yVel.toStringAsFixed(5)+","+zVel.toStringAsFixed(5)+")", style: TextStyle(fontSize: 13, fontStyle: FontStyle.normal),),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Accelerometer readings:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              ),
              Table(
                border: TableBorder.all(
                    width: 2.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "X axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(x.toStringAsFixed(2), //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(y.toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Z Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(z.toStringAsFixed(2),   //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Gyroscope readings:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              ),
              Table(
                border: TableBorder.all(
                    width: 2.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "X axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(xGyro.toStringAsFixed(2), //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(yGyro.toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Z Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(zGyro.toStringAsFixed(2),   //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}