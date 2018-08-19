# webart_resource
A simple way to reorganize resources in your web application.

## STATUS: Alpha Version!
It just a easy work for now, please don't use it in production if you do not know what you are doing.

## STATUS: Offer Dart 1.x support only
`webart` still only offer dart 1.x support, so this plugin could not run on dart 2 strong mode.  
But it looks like useless that upgrade to dart 2 if you are using dart in backend.

# How to use
1. Include it in your `pubspec.yaml`
````
dependencies:
  webart: ^0.2.6
  webart_resource: ^0.0.1
````
2. Import it in your code
````
import "package:webart_resource/webart_resource.dart";
````
3. Define some resources
````
class MyResource implements Resource<Map,Map>{ ... }
````
4. Put them in your config
````
var app = new Application(new Config({
    'routes':{ ... },
    'resources': [
        new MyResource(),
        new OtherResource()
    ]
}));
````
5. Use `ResourcePlugin`
````
app.use(new ResourcePlugin());
````
There is a example in 'example/example.dart' that has more infomation.

## Documents
Aren't finished yet.

## License
Copyright 2018 thisLight

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
