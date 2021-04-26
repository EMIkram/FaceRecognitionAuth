import 'package:FaceNetAuthentication/Utils/Utils.dart';
import 'package:FaceNetAuthentication/pages/db/database.dart';
import 'package:FaceNetAuthentication/pages/home.dart';
import 'package:FaceNetAuthentication/pages/qr_scanner.dart';
import 'package:FaceNetAuthentication/pages/sign-in.dart';
import 'package:FaceNetAuthentication/services/facenet.service.dart';
import 'package:FaceNetAuthentication/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerator extends StatefulWidget {
  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  TextEditingController _controller = TextEditingController();
  String _qrString ;
  _startServices() async {
    List<CameraDescription> cameras = await availableCameras();
    /// takes the front camera
    cameraDescription = cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();
  }

  @override
  void initState() {
    _startServices();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.auto_fix_high),
        onPressed: (){
          Utils.push(context, SignIn(cameraDescription: cameraDescription));
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.qr_code), onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScanner()),
            );
          })
        ],
        title: Text("Softech QR Generator"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50,),
            _qrString==null? Container(
              padding: EdgeInsets.all(50),
              color: Colors.black12,
              height: 240,width: 240,):
            Container(
              height: 240,
              child: QrImage(
                data: _qrString,
                version: 3,
                size: 250,
                gapless: true,
                embeddedImage: AssetImage('assets/Sbs.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (text){
                  setState(() {
                    text==''?
                    _qrString=null:
                    _qrString=text;
                  });
                },
                controller: _controller,
                decoration: InputDecoration(
                    labelText: "Generate QR",
                    border: OutlineInputBorder(),
                    hintText: 'Input and generate QR'
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScanner()),
              );
            }, child: Text("Scan QR")),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
