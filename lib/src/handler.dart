import 'dart:async';
import './verify.dart';
import 'package:webart/webart.dart';
import './resource.dart';


class ResourceHandler<T extends Resource> extends RequestHandlerBase{
    bool _requiredVerify;
    bool isRemoveableResource;
    T resource;

    ResourceHandler(this.resource,this._requiredVerify,this.isRemoveableResource);

    Future get(Request request) async{
        if (_requiredVerify){
            if (!(await _doVerify(request.headers['Authorization']))){
                request.response.error(401);
                return;
            }
        }
        Map json;
        try {
            json = await request.asJson();
        } catch (e){
            request.response.error(400);
            logger.finest("A error thown: $e");
            return;
        }
        try {
            var res = await resource.get(json);
            request.response.ok({
                'ok': true,
                'result': res,
            });
        } on ResourceNotFound {
            request.response.error(404);
            return;
        } on ResourceNotAccessible {
            _onResourceNotAccessible(request);
            return;
        } on RequestFormatError {
            request.response.error(400);
        } catch(e){
            _onUnkownError(request, e);
            return;
        }
    }

    Future post(Request request) async{
        if (this._requiredVerify && !(await _doVerify(request.headers['Authorization']))){
            request.response.error(401);
            return;
        }
        Map changes;
        try {
            var json = await request.asJson();
            var query = json['target'] ?? json['query'] ?? json['key'];
            var res = json['resource'] ?? json['data'] ?? json['value'];
            if ((query == null) && (res == null)){
                changes = json['changes'] ?? json['\$set'] ?? {};
            } else {
                changes = {};
                changes[query] = res;
            }
        } catch(e){
            request.response.error(400);
            return;
        }
        try{
            if(changes.isNotEmpty)
                changes.forEach((query,res) async => await resource.save(query,res));
            request.response.ok({
                'ok': true,
            });
        } on ResourceNotAccessible {
            _onResourceNotAccessible(request);
            return;
        } on TypeError {
            request.response.error(400);
            return;
        } on RequestFormatError {
            request.response.error(400);
        } catch(e){
            _onUnkownError(request,e);
            return;
        }
    }

    Future delete(Request request) async{
        if (_requiredVerify){
            if (!(await _doVerify(request.headers['Authorization']))){
                request.response.error(401);
                return;
            }
        }
        if (!isRemoveableResource){
            request.response.error(405);
            return;
        }
        Map json;
        try {
            json = await request.asJson();
        } catch (e){
            request.response.error(400);
            return;
        }
        try {
            var res = await (resource as RemoveableResource).remove(json);
            request.response.ok({
                'ok': true,
                'result': res,
            });
        } on ResourceNotFound {
            request.response.error(404);
            return;
        } on ResourceNotAccessible {
            _onResourceNotAccessible(request);
            return;
        } catch(e){
            _onUnkownError(request, e);
            return;
        }
    }

    Future put(Request request) => post(request);

    Future<bool> _doVerify(String head) => verifyToken(head);

    void _onUnkownError(Request request,dynamic e){
        logger.info("A error thown while resource $resource processing: $e");
        request.response.error(500);
    }

    void _onResourceNotAccessible(Request request){
        request.response.error(406,{
            'ok':false,
            'error': 'ResourceNotAccessible'
        });
    }

    String toString() => '$runtimeType:$resource';
}
