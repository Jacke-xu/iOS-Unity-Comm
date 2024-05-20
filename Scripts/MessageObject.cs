using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Runtime.InteropServices;

public class MessageObject : MonoBehaviour
{
    public Text SendMessageView;
    public Text ReceiveMessageView;

    [DllImport("__Internal")]
    /// 给iOS传string参数,返回值通过iOS的UnitySendMessage方法返回给Unity
    private static extern void sendIOSStringAndThenReturnVoid(string message);

    [DllImport("__Internal")]
    /// 给iOS传string参数,返回值通过iOS的return方法返回给Unity
    private static extern string sendIOSStringAndThenReturnString(string message);

    [DllImport("__Internal")]
    /// 给iOS传int参数,返回值通过iOS的return方法返回给Unity
    private static extern int sendIOSIntAndThenReturnInt(int value);

    [DllImport("__Internal")]
    /// 给iOS传float参数,返回值通过iOS的UnitySendMessage方法和ruturn方法返回给Unity
    private static extern float sendIOSFloatAndThenReturnFloat(float value);

    /// 向iOS发送一条string消息，返回值通过ReceiveStringFromUnitySendMessage方法接收
    public void sendStringAndThenReturnVoid()
    {
#if UNITY_IOS
        string sendString = "你好iOS，我是Unity(给iOS传string参数,返回值通过iOS的UnitySendMessage方法返回给Unity)";
        Debug.Log(sendString);
        if (SendMessageView != null)
        {
            SendMessageView.text = sendString;
        }
        sendIOSStringAndThenReturnVoid(sendString);
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /// iOS通过UnitySendMessage方式向Unity发送一条string消息
    public void ReceiveStringFromUnitySendMessage(string message)
    {
        Debug.Log(message);
        if (ReceiveMessageView != null)
        {
            ReceiveMessageView.text = message;
        }
    }

    /// 向iOS发送一条string消息，返回值通过Return方式接收
    public void sendStringAndThenReturnString()
    {
#if UNITY_IOS
        string sendString = "你好iOS，我是Unity(给iOS传string参数,返回值通过iOS的return方法返回给Unity)";
        Debug.Log(sendString);
        if (SendMessageView != null)
        {
            SendMessageView.text = sendString;
        }
        string result = sendIOSStringAndThenReturnString(sendString);
        Debug.Log(result);
        if (ReceiveMessageView != null)
        {
            ReceiveMessageView.text = result;
        }
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /// 向iOS发送一条int消息，返回值通过Return方式接收
    public void sendIntAndThenReturnInt()
    {
#if UNITY_IOS
        int sendInt = 99999;
        Debug.Log(sendInt);
        if (SendMessageView != null)
        {
            SendMessageView.text = sendInt.ToString();
        }
        int result = sendIOSIntAndThenReturnInt(sendInt);
        Debug.Log(result);
        if (ReceiveMessageView != null)
        {
            ReceiveMessageView.text = result.ToString();
        }
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /// 向iOS发送一条float消息，返回值通过ReceiveStringFromUnitySendMessage方法接收
    public void sendFloatAndThenReturnFloat()
    {
#if UNITY_IOS
        float sendFloat = 99998.99f;
        Debug.Log(sendFloat);
        if (SendMessageView != null)
        {
            SendMessageView.text = sendFloat.ToString("f");
        }
        float result = (float)sendIOSFloatAndThenReturnFloat(sendFloat);
        Debug.Log(result);
        if (ReceiveMessageView != null)
        {
            ReceiveMessageView.text = result.ToString("f");
        }
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /// iOS通过UnitySendMessage方式向Unity发送一条String消息
    public void ReceiveFloatFromUnitySendMessage(string value)
    {
        Debug.Log(value);
        if (ReceiveMessageView != null)
        {
            ReceiveMessageView.text = value;
        }
    }

    /*********************************华丽分割线，分割线内为HandlerEvent回调(函数回调)示例*********************************/

    /// 如果需要iOS的回调，声明一个回调函数类型
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate void HandlerEvent(string message);

    [DllImport("__Internal")]
    /// 给iOS传string参数,返回值通过HandlerEvent方法返回给Unity
    private static extern void sendIOSStringAndThenHandlerEventString(HandlerEvent handlerEvent, string message);

    [DllImport("__Internal")]
    /// 给iOS传string参数,返回值通过HandlerEvent和return方法返回给Unity
    private static extern string sendIOSStringAndThenHandlerEventAndReturnString(HandlerEvent handlerEvent, string message);

    /// 使用MonoPInvokeCallback将handlerEvent方法标记为回调方法，此处必须用static修饰，否则调用iOS与iOS回调都不会成功。
    [AOT.MonoPInvokeCallback(typeof(HandlerEvent))]
    private static void HandlerEventDelegate(string message)
    {
        /// 这里处理iOS的Handler回调事件
		Debug.Log("iOS端查看UnityHandler回调事件日志：" + message);
    }

    /// 向iOS发送一条string消息，返回值通过HandlerEvent方式接收
    public void sendStringAndThenHandlerEventString()
    {
#if UNITY_IOS
            string sendString = "你好iOS，我是Unity(给iOS传string参数,返回值通过HandlerEvent方法返回给Unity)";
            Debug.Log(sendString);
            if (SendMessageView != null)
            {
            SendMessageView.text = sendString;
            }

        HandlerEvent handler = new HandlerEvent(HandlerEventDelegate);
        sendIOSStringAndThenHandlerEventString(handler, sendString);
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /// 向iOS发送一条string消息，返回值通过HandlerEvent和“return”方式接收
    public void sendStringAndThenHandlerEventAndReturnString()
    {
#if UNITY_IOS
            string sendString = "你好iOS，我是Unity(给iOS传string参数,返回值通过HandlerEvent和return方法返回给Unity)";
            Debug.Log(sendString);
            if (SendMessageView != null)
            {
            SendMessageView.text = sendString;
            }
            HandlerEvent handler = new HandlerEvent(HandlerEventDelegate);
            string result = sendIOSStringAndThenHandlerEventAndReturnString(handler, sendString);
            Debug.Log(result);
            if (ReceiveMessageView != null)
            {
            ReceiveMessageView.text = "Return回调：" + result;
            }
#else
        Debug.Log("其他语言待写入");
#endif
    }

    /*********************************华丽分割线，分割线内为HandlerEvent回调(函数回调)示例*********************************/
}
