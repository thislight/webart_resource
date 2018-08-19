import 'dart:async';
import 'package:webart/webart.dart';

abstract class VerifyInterface{
    Future<String> newToken(Map<String,String> headers);
    Future<bool> verify(String token);
}

class VerifyManager{
    static VerifyInterface interface;
}

class VerifyHandler extends RequestHandlerBase{
    Future get(Request request) async{
        try {
            String token = await VerifyManager.interface.newToken(request.headers);
            request.response.ok({
                'ok': true,
                'token': token,
            });
        } on VerifyFail {
            request.response.error(401,{
                'ok': false,
            });
        } catch(e) {
            logger.info("A error thown when creating token.",e);
            request.response.error(500);
        }
    }

    Future post(Request request) async{
        try {
            String head = request.headers['Authorization'];
            if (head == null || head.isEmpty){
                request.response.error(400);
                return;
            }
            List _l = head.split(" ");
            String method = _l[0];
            String token = _l[1];
            if (method != 'Token' || token == null || token.isEmpty) {
                request.response.error(400);
                return;
            }
            bool passed = await VerifyManager.interface.verify(token);
            request.response.ok({
                'ok': true,
                'pass': passed
            });
        } on VerifyFail {
            request.response.error(401,{
                'ok': false
            });
        } catch(e) {
            logger.info("A error thown when verify token",e);
            request.response.error(500);
        }
    }
}

Future<bool> verifyToken(String head) async{
    if (head == null || head.isEmpty){
        return false;
    }
    List _l = head.split(" ");
    String method = _l[0];
    String token = _l[1];
    if (method != 'Token' || token == null || token.isEmpty){
        return false;
    }
    return await VerifyManager.interface.verify(token);
}

class VerifyFail extends Error{}
