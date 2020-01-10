import 'dart:io';

import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateDialog extends StatefulWidget {
  final String title;
  final String content;
  final String apkUrl;
  final String version;

  const UpdateDialog(
      {Key key, this.title, this.content, this.apkUrl, this.version})
      : super(key: key);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  String _hint = "立即更新";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 340,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              width: 300,
              height: 310,
              padding: const EdgeInsets.only(
                  left: 20.0, top: 36.0, bottom: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text('v1.0.1'),
                    SizedBox(height: 12.0),
                    Expanded(
                      child: Text(
                        widget.content,
                        style: TextStyle(
                            fontSize: 14.0, color: Colors.grey[600], height: 2),
                      ),
                    ),
                    Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(23),
                        color: Colors.indigoAccent,
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.6),
                        child: Ink(
                          child: InkWell(
                            onTap: () async {
                              _upgrade();
                            },
                            borderRadius: BorderRadius.circular(23),
                            child: Container(
                              width: 120,
                              height: 46,
                              child: Center(
                                child: Text(
                                  _hint,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/image/upgrade.png',
                width: 100,
              ),
            )
          ],
        ),
      ),
    ));
  }

  _upgrade() async {
    var per = await _checkPermission(context);
    if (!per) {
      return;
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;


    try {
      OtaUpdate().execute(widget.apkUrl).listen((OtaEvent event){
        switch(event.status) {
          case OtaStatus.DOWNLOADING:
            setState(() {
              this._hint = "下载中 ${event.value}%";
            });
            break;
          case OtaStatus.INSTALLING:
            InstallPlugin.installApk(appDocPath, 'top.jotyy.flutter_app_upgrade_example');
            break;
          default:
            break;
        }
      });
    } catch (_) {}
  }

  Future<bool> _checkPermission(BuildContext context) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}