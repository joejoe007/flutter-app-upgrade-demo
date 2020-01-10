import 'package:flutter/material.dart';
import 'package:flutter_app_upgrade_example/datasource/remote_data_source.dart';
import 'package:flutter_app_upgrade_example/models/app_upgrade_model.dart';
import 'package:flutter_app_upgrade_example/widget/upgrade_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Upgrade',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'App Upgrade'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            getAppUpgrade(context);
          },
          color: Colors.indigoAccent,
          child: Text("CHECK UPGRADE", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Future getAppUpgrade(BuildContext context) async {
    final remoteDataSource = RemoteDataSource();
    final response = await remoteDataSource.getAppUpgrade();
    showDialog(context: context,
      barrierDismissible: response.upgradeType != 0,
      builder: (_) => UpdateDialog(
        title: response.appName,
        content: response.upgradeDesc,
        apkUrl: response.downloadUrl,
        version: response.appVersion,
      )
    );
  }
}

