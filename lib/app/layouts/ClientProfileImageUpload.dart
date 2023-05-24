import 'dart:io';

import 'package:asasui/app/layouts/widgets/MainAppBar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';
import '../services/ClientService.dart';

class ClientProfileImageUpload extends StatefulWidget {
  ClientProfileImageUpload({Key? key}) : super(key: key);

  @override
  State<ClientProfileImageUpload> createState() =>
      _ClientProfileImageUploadState();
}

class _ClientProfileImageUploadState extends State<ClientProfileImageUpload> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  Future<dynamic> uploadClientProfileImage() async {
    // int? storeId = await StoreService().getStoreId();
    String clientId = await AuthService().decodeJwt('userId');
    var uploadClientProfileImageResp =
        await ClientService().saveClientProfilePicture(clientId, image);
    print('uploadClientProfileImage res body');
    print(uploadClientProfileImageResp.data.toString());
    var test = uploadClientProfileImageResp.data['data'];
    if (uploadClientProfileImageResp.statusCode == 200) {
      // print('test obj');
      // print(test['productName']);
      // cartList = storeDetailResponse.data['data'];
      // Provider.of<LocalDataService>(context, listen: false).changeQuantityDialog(true);
      // Navigator.pop(context, 'Update');
      // return uploadClientProfileImageResp.data['data'];
      Navigator.pushNamed(context, '/verification/document/upload');
    } else {
      // return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        backOption: false,
      ),
      backgroundColor: const Color.fromARGB(245, 255, 227, 186),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 300,
                width: 400,
                child: controller == null
                    ? Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(controller!)),
            ElevatedButton.icon(
              //image capture button
              onPressed: () async {
                try {
                  if (controller != null) {
                    //check if contrller is not null
                    if (controller!.value.isInitialized) {
                      //check if controller is initialized
                      image = await controller!.takePicture(); //capture image
                      setState(() {
                        //update UI
                      });
                    }
                  }
                } catch (e) {
                  print(e); //show error
                }
              },
              icon: Icon(Icons.camera),
              label: Text("Capture"),
            ),
            Container(
              //show captured image
              padding: EdgeInsets.all(30),
              child: image == null
                  ? Text("No image captured")
                  : Image.file(
                      File(image!.path),
                      height: 300,
                    ),
              //display captured image
            ),
            ElevatedButton(
              onPressed: () {
                uploadClientProfileImage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Next'), // <-- Text
                  SizedBox(
                    width: 25,
                  ),
                  Icon(
                    // <-- Icon
                    Icons.arrow_forward,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
