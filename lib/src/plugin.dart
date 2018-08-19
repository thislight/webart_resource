import './resource.dart';
import './handler.dart';
import './verify.dart';
import 'package:webart/webart.dart';

class ResourcePlugin implements Plugin{
    bool _requiredVerify;

    ResourcePlugin([VerifyInterface interface]){
        VerifyManager.interface = interface;
        if (interface == null){
            _requiredVerify = false;
        } else {
            _requiredVerify = true;
        }
    }

  @override
  void init(Application app) {
    var resources = app.C['resources'] ?? {};
    for (Resource res in resources){
        bool isRemoveable = false;
        if (res is RemoveableResource){
            isRemoveable = true;
        }
        var handler = new ResourceHandler(res, _requiredVerify, isRemoveable);
        app.C['routes'][res.address] = handler;
    }
  }
}
