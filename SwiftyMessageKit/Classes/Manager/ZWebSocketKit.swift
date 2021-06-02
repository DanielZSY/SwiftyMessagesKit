
import UIKit
import BFKit
import HandyJSON
import Starscream
import SwiftBasicKit

/// IM状态管理
final class ZWebSocketKit: NSObject {
    /// 呼叫频道ID
    public var callid: Int = 0
    /// 呼叫事件类型
    public var callevent: kEnumSocketEvent = .connect
    /// 连接id
    public var client_id: String { return self.clientId }
    /// 连接状态
    public var is_connected: Bool { return self.isConnected }
    /// 是否显示消息通知页面
    public var isShowMultipleView: Bool = true
    /// 单例模式
    public static let shared = ZWebSocketKit()
    /// IM聊天
    private var webSocket: WebSocket?
    /// 连接状态
    private var isConnected: Bool = false
    /// 连接编码
    private var clientId: String = ""
    /// 心跳定时器
    private var pingTimer: Timer?
    /// 心跳默认数据
    private var pingData: String = "."
    /// 保持心跳频率
    private var pingTime: TimeInterval = 10
    /// 是否收到上次的回执Ping
    private var isReceiptPing: Bool = true
    /// 开始连接
    public final func reconnect() {
        if self.isConnected || !ZSettingKit.shared.isLogin { return }
        let url = URL.init(string: ZKey.service.wss)!
        var request = URLRequest.init(url: url)
        //request.timeoutInterval = 10
        //let uid = ZSettingKit.shared.userId
        //request.setValue(String(uid), forHTTPHeaderField: "uid")
        //let token = ZSettingKit.shared.token
        //request.setValue(token, forHTTPHeaderField: "Authorization")
        //request.setValue("13", forHTTPHeaderField: "Sec-WebSocket-Version")
        self.webSocket = WebSocket.init(request: request)
        self.webSocket?.delegate = self
        self.webSocket?.connect()
        BFLog.debug("reconnect")
    }
    /// 断开连接
    public final func disconnect() {
        self.webSocket?.disconnect()
        self.webSocket?.delegate = nil
        self.webSocket = nil
        self.isConnected = false
        BFLog.debug("disconnect")
    }
    /// 发送消息
    public final func sendMessage(model: ZModelMessage) {
        self.webSocket?.write(string: model.message, completion: {
            BFLog.debug("message send completion")
        })
    }
    /// 保持心跳
    public final func sendPing() {
        if !self.isReceiptPing { self.isConnected = false }
        self.reconnect()
        self.checkBindStatus()
        if let data = self.pingData.dataValue {
            self.isReceiptPing = false
            self.webSocket?.write(ping: data, completion: {
                BFLog.debug("ping send completion")
            })
        }
        self.sendMessage()
    }
    /// 发送默认消息
    private final func sendMessage() {
        self.webSocket?.write(string: self.pingData, completion: {
            BFLog.debug("message send completion")
        })
    }
    /// 检测是否绑定上
    public final func checkBindStatus() {
        if !ZBindKit.shared.isBindSuccess {
            ZWebSocketKit.shared.disconnect()
            ZWebSocketKit.shared.reconnect()
        }
    }
}
extension ZWebSocketKit: WebSocketDelegate {
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected = true
            self.isReceiptPing = true
            ZBindKit.shared.isBindSuccess = false
            BFLog.debug("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            self.isConnected = false
            ZBindKit.shared.isBindSuccess = false
            BFLog.debug("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            BFLog.debug("websocket Received text: \(text)")
            guard let event = ZModelIMEvent.deserialize(from: text) else { return }
            self.callid = event.call_id
            self.callevent = event.event_code
            switch event.event_code {
            case .connect:
                guard let model = ZModelIMConnection.deserialize(from: text) else { return }
                self.clientId = model.client_id
                ZBindKit.bindPush(clientId: self.clientId)
            case .call:
                guard let model = ZModelIMCall.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .response:
                guard let model = ZModelIMAnswer.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .hangup:
                guard let model = ZModelIMHangup.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .cmd:
                guard let model = ZModelIMCMD.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .isonline, kEnumSocketEvent.update:
                guard let model = ZModelIMStatus.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .gift:
                guard let model = ZModelIMGift.deserialize(from: text) else { return }
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model)
            case .balance:
                guard let model = ZModelIMBalance.deserialize(from: text) else { return }
                if let user = ZSettingKit.shared.user, var dic = user.rawData {
                    user.balance = Double(model.balance)
                    dic["balance"] = user.balance
                    ZSettingKit.shared.updateUser(dic: dic)
                }
                NotificationCenter.default.post(name: Notification.Names.UserBalanceChange, object: model.copyable())
                NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: model.copyable())
            default: break
            }
        case .binary(let data):
            BFLog.debug("websocket binary data: \(data.count)")
        case .ping(let data):
            BFLog.debug("websocket ping data: \(data?.count ?? 0)")
        case .pong(let data):
            self.isReceiptPing = data?.count == self.pingData.count
            BFLog.debug("websocket pong data: \(data?.count ?? 0), isbindsuccess: \(ZBindKit.shared.isBindSuccess), client_id: \(self.client_id)")
        case .viabilityChanged(_):
            self.isConnected = false
            ZBindKit.shared.isBindSuccess = false
            BFLog.debug("websocket viabilityChanged")
        case .reconnectSuggested(_):
            BFLog.debug("websocket reconnectSuggested")
        case .cancelled:
            self.isConnected = false
            ZBindKit.shared.isBindSuccess = false
            BFLog.debug("websocket cancelled")
        case .error(let error):
            self.isConnected = false
            ZBindKit.shared.isBindSuccess = false
            BFLog.debug("websocket error: \(error?.localizedDescription ?? "")")
        }
    }
}
