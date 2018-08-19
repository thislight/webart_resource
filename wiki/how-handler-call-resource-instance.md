# How ResourceHandler call Resource instance
For easy programming, `ResourceHandler` does not limit Resource recviced type by "generic type", but it has three rule above while calling functions of `Resource`.
1. `Resource.get` will recvice json of request as argument
2. Arguments of `Resource.save` have type `dynamic`, but the handler can return 400 error to client if it thown a `TypeError` or a `RequestFormatError`
3. Like `Resource.get`, `RemoveableResource.remove` will get the json of request

## Tips of ResourceHandler
- `ResourceHandler`'s method `PUT` just call `POST`, they have same behavior.
- If you just change one value by `POST` method, in request's json, you can use "target", "query" or "key" as key to define target, use "resource", "data" or "value" as key to define value.Like json in above:
````json
{
    "query": "something",
    "value": "something else"
}
````
- You can change multiple values in single request by `POST` method, just put a object that has key-value pair and named as "changes" or "$set". There is a example:
````json
{
    "$set": {
        "key1": "value1",
        "key2": "value2"
    }
}
````

