//
//  UnityBridgeManager.m
//  UnityBridgeManager
//
//  Created by zhanxun on 2024/4/25.
//  Copyright © 2024 zhanxun. All rights reserved.
//  因为C#可以调用C和C++代码，而C和C++可以调用Objective-C代码，所以我们将.m后缀改为.mm，这样，我们就可以在里面编写C和C++代码了

#import <Foundation/Foundation.h>
#import <string.h>

/// Unity传string参数过来,返回值通过UnitySendMessage方法返回给Unity
extern "C" void sendIOSStringAndThenReturnVoid(const char *message)
{
    NSString *string = [[NSString alloc] initWithUTF8String: message];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"回消息给Unity" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         参数一：要调用的Unity的节点名
         参数二：要调用的Unity的方法名
         参数三：要传递给Unity的值
         */
        const char *nodeName = "MainScene";
        const char *methodName = "ReceiveStringFromUnitySendMessage";
        const char *replyMessage = [@"你好Unity，我是iOS(Unity传string参数过来,返回值通过UnitySendMessage方法返回给Unity)" UTF8String];
        UnitySendMessage(nodeName, methodName, replyMessage);
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];
}

/// Unity传string参数过来,返回值通过return方法返回给Unity
extern "C" const char * sendIOSStringAndThenReturnString(const char *message)
{
    NSString *string = [[NSString alloc] initWithUTF8String: message];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];

    const char *replyMessage = [@"你好Unity，我是iOS(Unity传string参数过来,返回值通过return方法返回给Unity)" UTF8String];
    /// 需要调用strdup()函数分配c内存再返回给unity,不然闪退(strdup函数需要引入#import <string.h>)
    return strdup(replyMessage);
}

/// Unity传int参数过来,返回值通过return方法返回给Unity
extern "C" const int sendIOSIntAndThenReturnInt(int value)
{
    NSString *string = [[NSString alloc] initWithFormat:@"%d%@",value,@"(Unity传int参数过来,返回值通过return方法返回给Unity)"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];

    int replyValue = 88888;
    return replyValue;
}

/// Unity传float参数过来,返回值通过UnitySendMessage方法和ruturn方法返回给Unity
extern "C" const float sendIOSFloatAndThenReturnFloat(float value)
{
    NSString *string = [[NSString alloc] initWithFormat:@"%f%@",value,@"Unity传float参数过来,返回值通过UnitySendMessage方法和ruturn方法返回给Unity"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"回消息给Unity" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         参数一：要调用的Unity的节点名
         参数二：要调用的Unity的方法名
         参数三：要传递给Unity的值
         */
        const char *nodeName = "MainScene";
        const char *methodName = "ReceiveFloatFromUnitySendMessage";
        const char *replyMessage = "88888.88";
        UnitySendMessage(nodeName, methodName, replyMessage);
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];

    return 88888.98;
}

/*********************************华丽分割线，以下为HandlerEvent回调(函数回调)示例*********************************/

/// 如果c#调用oc函数时需要一个回调，需要先声明回调参数类型：
typedef void (*HandlerEvent) (const char *message);

/// Unity传string参数过来,返回值通过HandlerEvent方法返回给Unity
extern "C" void sendIOSStringAndThenHandlerEventString(HandlerEvent handler, const char *message)
{
    NSString *string = [[NSString alloc] initWithUTF8String: message];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"回消息给Unity" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        const char *replyMessage = [@"你好Unity，我是iOS(Unity传string参数过来,返回值通过HandlerEvent方法返回给Unity)" UTF8String];
        if (handler != nil)
        {
           handler(replyMessage);
        }
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];
}

/// Unity传string参数过来,返回值通过HandlerEvent和return方法返回给Unity
extern "C" const char * sendIOSStringAndThenHandlerEventAndReturnString(HandlerEvent handler, const char *message)
{
    NSString *string = [[NSString alloc] initWithUTF8String: message];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到消息" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"回消息给Unity" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        const char *replyMessage = [@"你好Unity，我是iOS(Unity传string参数过来,返回值通过“HandlerEvent”和return方法返回给Unity)" UTF8String];
        if (handler != nil)
        {
           handler(replyMessage);
        }
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController presentViewController:alert animated:YES completion:nil];
    
    const char *replyMessage = [@"你好Unity，我是iOS(Unity传string参数过来,返回值通过HandlerEvent和”return“方法返回给Unity)" UTF8String];
    /// 需要调用strdup()函数分配c内存再返回给unity,不然闪退(strdup函数需要引入#import <string.h>)
    return strdup(replyMessage);
}
