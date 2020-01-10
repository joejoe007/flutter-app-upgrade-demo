import 'dart:convert';

import 'package:flutter_app_upgrade_example/models/app_upgrade_model.dart';
import 'package:http/http.dart';

class RemoteDataSource {
  Future<AppUpgradeModel> getAppUpgrade() async {
    final response = await get("https://my-json-server.typicode.com/jotyy/json-app-upgrade/data");

    if (response.statusCode == 200) {
      final model = AppUpgradeModel.fromJson(jsonDecode(response.body));

      return model;
    } else {
      throw ServerException();
    }
  }
}

class ServerException implements Exception {}