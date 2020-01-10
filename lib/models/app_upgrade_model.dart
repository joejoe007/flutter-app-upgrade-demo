class AppUpgradeModel {
    final String appName;
    final String appVersion;
    final String upgradeDesc;
    final int upgradeType;
    final String downloadUrl;

    AppUpgradeModel({this.appName, this.appVersion, this.upgradeDesc, this.upgradeType, this.downloadUrl});

    factory AppUpgradeModel.fromJson(Map<String, dynamic> json) {
        return AppUpgradeModel(
            appName: json['appName'], 
            appVersion: json['appVersion'], 
            upgradeDesc: json['upgradeDesc'], 
            upgradeType: json['upgradeType'], 
            downloadUrl: json['downloadUrl'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['appName'] = this.appName;
        data['appVersion'] = this.appVersion;
        data['upgradeDesc'] = this.upgradeDesc;
        data['upgradeType'] = this.upgradeType;
        data['downloadUrl'] = this.downloadUrl;
        return data;
    }
}