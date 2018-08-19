import 'dart:async';
import 'package:webart/webart.dart';
import 'package:webart_resource/webart_resource.dart';


class ExampleResource implements RemoveableResource{
    String address = "example";
    Map<String,Map<String,dynamic>> memories;

    ExampleResource(){
        memories = {};
    }

  @override
  Future<Map> get(Map entry) async {
      String key = entry['key'];
    var res = memories[key];
    if (res == null) throw new ResourceNotFound();
    return res;
  }

  @override
  Future<dynamic> remove(Map entry) async {
    String key = entry['key'];
    memories.remove(key);
    return;
  }

  @override
  Future<dynamic> save(String entry, Map res) async {
    memories[entry] = res;
    return;
  }
}

main() async{
    var app = new Application(new Config({
        'routes': {},
        'resources': [
            new ExampleResource()
        ]
    }));
    app.use(new ResourcePlugin());
    await app.start('127.0.0.1', 8089);
}
