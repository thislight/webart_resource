import 'dart:async';


abstract class Resource<K,T>{
    String address;
    Future<T> get(K entry);
    Future<Null> save(K entry,T res);
}

abstract class RemoveableResource<K,T> extends Resource<K,T>{
    Future<Null> remove(K entry);
}

class ResourceNotFound extends Error{}

class ResourceNotAccessible extends Error{}
