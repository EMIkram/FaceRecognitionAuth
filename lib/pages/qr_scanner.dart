import 'dart:io';

import 'package:FaceNetAuthentication/Utils/Utils.dart';
import 'package:FaceNetAuthentication/pages/home.dart';
import 'package:FaceNetAuthentication/pages/sign-in.dart';
import 'package:FaceNetAuthentication/services/facenet.service.dart';
import 'package:FaceNetAuthentication/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'db/database.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  CameraDescription cameraDescription;
  List<CameraDescription> cameras;
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  /// takes the front camera
  @override
  void initState() {
  _startServices();


    // TODO: implement initState
    super.initState();
  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
      //TODO: push to the face sign in page
          Utils.push(context, MyHomePage());
        },
        child: Icon(Icons.app_registration),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(

            padding: EdgeInsets.all(50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.green,
                      width: 3
                  )
              ),
              child: GestureDetector(
                onTap: (){
                },
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ),
          (result != null)
              ? Expanded(
            child: Text(
                'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}'),
          )
              : Text('Scan a code'),

        ],
      ),
    );
  }

  void _startServices() async{
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
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      Utils.push(context, SignIn(
        cameraDescription: cameraDescription,
        // authID: result.code,
      ));
    });
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
