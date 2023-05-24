import 'dart:io';

import 'package:asasui/app/layouts/widgets/MainAppBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '../services/AuthService.dart';
import '../services/ClientService.dart';

class ClientDocumentUpload extends StatefulWidget {
  ClientDocumentUpload({Key? key}) : super(key: key);

  @override
  State<ClientDocumentUpload> createState() => _ClientDocumentUploadState();
}

class _ClientDocumentUploadState extends State<ClientDocumentUpload> {
  String? _fileName = '';
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  // late File selectedfile;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: (_extension?.isNotEmpty ?? false)
      //       ? _extension?.replaceAll(' ', '').split(',')
      //       : null,
      //   //allowed extension to choose
      // );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      print('_fileName $_fileName');
    });
  }

  Future<dynamic> uploadClientProfileImage(context) async {
    // int? storeId = await StoreService().getStoreId();
    String clientId = await AuthService().decodeJwt('userId');
    var uploadClientProfileImageResp = await ClientService()
        .saveClientVerificationDocument(clientId, _paths?.single);
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
      Navigator.pushNamed(context, '/store');
    } else {
      // return null;
    }
  }

  // selectFile() async {
  //   //for file_pocker plugin version 2 or 2+

  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'pdf', 'mp4'],
  //     //allowed extension to choose
  //   );

  //   if (result != null) {
  //     //if there is selected file
  //     File(result.files.single.path);
  //   }

  //   setState(() {}); //update the UI so that file name is shown
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppBar(
          backOption: false,
        ),
        backgroundColor: const Color.fromARGB(245, 255, 227, 186),
        body: Center(
          child: Container(
            height: 300,
            child: Card(
              child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'Upload the document which can be used to verify your age. This is need for you to purchase age restrict product'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _openFileExplorer(),
                      child: const Text("Upload"),
                    ),
                    Container(
                      child: Text(_fileName == '' ? '' : '$_fileName'),
                    ),
                    _fileName == '' ? Container() : Text('data'),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadClientProfileImage(context);
                        // Navigator.pushNamed(context, '/panel');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Finish'), // <-- Text
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
