
import UIKit
import HandyJSON
import BFKit.Swift
import AgoraRtmKit
import CryptoSwift
import SwiftBasicKit

/// 聊天管理类
class ZChatSDKKit: NSObject {

    /// 当前登录用户
    var loginUser: ZModelMessageKitUser {
        let loginUser = ZSettingKit.shared.user ?? ZModelUserBase.init()
        let messageUser = ZModelMessageKitUser.init(senderId: loginUser.userid, displayName: loginUser.nickname, head: loginUser.avatar, role: loginUser.role.rawValue, gender: loginUser.gender.rawValue)
        return messageUser
    }
    var agoraRtmKit: AgoraRtmKit? {
        if self.agoraKit == nil {
            self.reconnect()
        }
        return self.agoraKit
    }
    /// 消息类对象
    private var agoraKit: AgoraRtmKit?
    /// 连接状态
    private var connectionState: AgoraRtmConnectionState = .disconnected
    /// 单例模式
    public static let shared = ZChatSDKKit()
    /// 存储登录对象token
    private var token: String = ""
    
    deinit {
        self.agoraKit?.agoraRtmDelegate = nil
        self.agoraKit = nil
    }
    /// 开始连接
    final func reconnect() {
        if self.agoraKit == nil || self.connectionState != .connected {
            self.agoraKit = nil
            self.agoraKit?.agoraRtmDelegate = nil
            self.agoraKit = AgoraRtmKit.init(appId: ZReload.shared.agora_app_id, delegate: self)
        }
        if self.token.count == 0 {
            ZNetworkKit.created.startRequest(target: .get(ZAction.apichattoken.api, nil), responseBlock: { [weak self] result in
                guard let `self` = self else { return }
                if result.success, let dic = result.body as? [String: Any] {
                    self.token = dic["rtm_token"] as? String ?? ""
                    self.agoraKit?.renewToken(self.token, completion: { [weak self] (newtoken, errorCode) in
                        guard let `self` = self else { return }
                        if errorCode == AgoraRtmRenewTokenErrorCode.ok {
                            BFLog.log("renewToken success")
                        } else if errorCode == AgoraRtmRenewTokenErrorCode.notLoggedIn {
                            self.agoraKit?.login(byToken: self.token, user: ZSettingKit.shared.userId, completion: { [weak self] (errorCode) in
                                guard let `self` = self else { return }
                                if (errorCode == AgoraRtmLoginErrorCode.ok) {
                                    BFLog.log("login sdk im message success")
                                } else {
                                    BFLog.log("login sdk im message failed \(errorCode.rawValue)")
                                }
                            })
                        } else {
                            BFLog.log("renewToken error: \(errorCode.rawValue)")
                        }
                    })
                }
            })
        } else {
            self.agoraKit?.renewToken(self.token, completion: { [weak self] (newtoken, errorCode) in
                guard let `self` = self else { return }
                if errorCode == AgoraRtmRenewTokenErrorCode.ok {
                    BFLog.log("renewToken success")
                } else if errorCode == AgoraRtmRenewTokenErrorCode.notLoggedIn {
                    self.agoraKit?.login(byToken: self.token, user: ZSettingKit.shared.userId, completion: { [weak self] (errorCode) in
                        guard let `self` = self else { return }
                        if (errorCode == AgoraRtmLoginErrorCode.ok) {
                            BFLog.log("login sdk im message success")
                        } else {
                            BFLog.log("login sdk im message failed \(errorCode.rawValue)")
                        }
                    })
                } else {
                    BFLog.log("renewToken error: \(errorCode.rawValue)")
                }
            })
        }
    }
    /// 退出连接
    final func disconnect() {
        self.agoraKit?.logout(completion: { (errorCode) in
            if (errorCode == AgoraRtmLogoutErrorCode.ok) {
                BFLog.log("logout sdk im message success")
            } else {
                BFLog.log("logout sdk im message failed \(errorCode.rawValue)")
            }
        })
        self.agoraKit = nil
        self.agoraKit?.agoraRtmDelegate = nil
    }
    /// 发送消息
    private final func sendMessage(_ model: ZModelMessage) {
        if self.connectionState != .connected {
            if self.token.count == 0 {
                ZNetworkKit.created.startRequest(target: .get(ZAction.apichattoken.api, nil), responseBlock: { [weak self] result in
                    guard let `self` = self else { return }
                    if result.success, let dic = result.body as? [String: Any] {
                        self.token = dic["rtm_token"] as? String ?? ""
                        self.agoraKit?.renewToken(self.token, completion: { [weak self] (newtoken, errorCode) in
                            guard let `self` = self else { return }
                            if errorCode == AgoraRtmRenewTokenErrorCode.ok {
                                BFLog.log("renewToken success")
                            } else if errorCode == AgoraRtmRenewTokenErrorCode.notLoggedIn {
                                self.agoraKit?.login(byToken: self.token, user: ZSettingKit.shared.userId, completion: { [weak self] (errorCode) in
                                    guard let `self` = self else { return }
                                    if (errorCode == AgoraRtmLoginErrorCode.ok) {
                                        self.startSendMessage(model)
                                        BFLog.log("login sdk im message success")
                                    } else {
                                        BFLog.log("login sdk im message failed \(errorCode.rawValue)")
                                    }
                                })
                            } else {
                                BFLog.log("renewToken error: \(errorCode.rawValue)")
                            }
                        })
                    }
                })
            } else {
                self.agoraKit?.login(byToken: self.token, user: ZSettingKit.shared.userId, completion: { [weak self] (errorCode) in
                    guard let `self` = self else { return }
                    if (errorCode == AgoraRtmLoginErrorCode.ok) {
                        self.startSendMessage(model)
                        BFLog.log("login sdk im message success")
                    } else {
                        BFLog.log("login sdk im message failed \(errorCode.rawValue)")
                    }
                })
            }
        } else {
            self.startSendMessage(model)
        }
    }
    /// 开始发送文本消息
    final func startSendMessage(_ model: ZModelMessage) {
        
        let receiveid = model.message_user?.userid ?? ""
        BFLog.log("start send sdk im message \(model.message_json)")
        let rtmmsg = AgoraRtmMessage.init(text: model.message_json)
        let sendMessageOptions = AgoraRtmSendMessageOptions.init()
        sendMessageOptions.enableHistoricalMessaging = true
        sendMessageOptions.enableOfflineMessaging = true
        self.agoraKit?.send(rtmmsg, toPeer: receiveid, sendMessageOptions: sendMessageOptions, completion: { [weak self] (errorCode) in
            guard let `self` = self else { return }
            if errorCode == AgoraRtmSendPeerMessageErrorCode.ok || errorCode == AgoraRtmSendPeerMessageErrorCode.cachedByServer {
                BFLog.log("send sdk im message success: \(model.message_serviceid)")
                if model.message_issave {
                    model.message_send_state = 2
                    ZSQLiteKit.setModel(model: model)
                    
                    self.sendMessageNotify(msgid: model.message_serviceid)
                }
            } else {
                BFLog.log("send sdk im message failed \(errorCode.rawValue)")
            }
        })
    }
    /// 发送消息到服务器 need_notify 0 不需要推送 1 需要推送
    final func sendMessageToService(_ model: ZModelMessage, need_notify: Int, giftid: Int64 = 0) {
        if need_notify == 0 {
            self.sendMessage(model)
            return
        }
        if let user = model.message_user {
            // 消息记录
            let msguser = ZModelMessageRecord.init()
            msguser.message_user = user.copyable()
            switch model.message_type {
            case .gift: msguser.message = model.message + " " + ZString.lbGift.text
            default: msguser.message = model.message
            }
            msguser.message_id = model.message_id
            msguser.message_type = model.message_type
            msguser.message_time = model.message_time
            msguser.message_direction = model.message_direction
            ZSQLiteKit.setModel(model: msguser)
        }
        ZSQLiteKit.setModel(model: model)
        
        let receiveid = model.message_user?.userid ?? ""
        var dic = [String: Any]()
        dic["uuid"] = model.message_id
        if giftid > 0 { dic["giftid"] = giftid }
        dic["message"] = model.message
        dic["sendtime"] = model.message_time
        dic["messagetype"] = model.message_type.rawValue
        dic["mediaid"] = model.message_file_id
        dic["senderid"] = ZSettingKit.shared.userId
        dic["senderrole"] = (ZSettingKit.shared.user?.role ?? .user).rawValue
        dic["senderhead"] = ZSettingKit.shared.user?.avatar ?? ""
        dic["senderage"] = ZSettingKit.shared.user?.age ?? 20
        dic["sendernickname"] = ZSettingKit.shared.user?.nickname ?? ""
        BFLog.log("send service message: \(dic)")
        let json = try? dic.json()
        model.message_json = json ?? model.message
        var param = [String: Any]()
        param["recipient_id"] = receiveid
        param["need_notify"] = need_notify
        param["message"] = dic
        ZNetworkKit.created.startRequest(target: .post(ZAction.apichatmessage.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let msgid = dic["message_id"] as? Int {
                model.message_serviceid = msgid
                model.message_send_state = 1
                self.sendMessage(model)
                BFLog.log("post message to service message_id: \(msgid)")
            } else {
                ZProgressHUD.showMessage(vc: nil, text: result.message)
                BFLog.log("post message to service error: \(result.message)")
            }
        })
    }
    /// 发送推送
    final func sendMessageNotify(msgid: Int) {
        var param = [String: Any]()
        param["message_id"] = msgid
        ZNetworkKit.created.startRequest(target: .post(ZAction.apichatnotify.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                
            }
            BFLog.log("send message to notify state: \(result.success)")
        })
    }
    static func sendMessageJson(model: ZModelMessage) -> String {
        var dic = [String: Any]()
        dic["uuid"] = model.message_id
        dic["giftid"] = 0
        dic["message"] = model.message
        dic["sendtime"] = model.message_time
        dic["messagetype"] = model.message_type.rawValue
        dic["mediaid"] = model.message_file_id
        dic["senderid"] = ZSettingKit.shared.userId
        dic["senderrole"] = (ZSettingKit.shared.user?.role ?? .user).rawValue
        dic["senderhead"] = ZSettingKit.shared.user?.avatar ?? ""
        dic["senderage"] = ZSettingKit.shared.user?.age ?? 20
        dic["sendernickname"] = ZSettingKit.shared.user?.nickname ?? ""
        BFLog.log("send service message: \(dic)")
        let json = try? dic.json()
        return json ?? model.message
    }
}
extension ZChatSDKKit: AgoraRtmDelegate {
    /// 连接状态
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        self.connectionState = state
        BFLog.log("connectionStateChanged state: \(state.rawValue): reason: \(reason.rawValue)")
    }
    /// 收到点对点消息回调
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        BFLog.log("messageReceived text: \(message.text): peerId: \(peerId)")
        
        ZChatReceivedKit.setReceivedMessage(message, peerId)
    }
    /// 收到点对点图片消息回调
    func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
        BFLog.log("imageMessageReceived mediaId: \(message.mediaId): peerId: \(peerId)")
        
        ZChatReceivedKit.setReceivedMessage(message, peerId)
    }
    /// 收到点对点文件消息回调
    func rtmKit(_ kit: AgoraRtmKit, fileMessageReceived message: AgoraRtmFileMessage, fromPeer peerId: String) {
        BFLog.log("fileMessageReceived mediaId: \(message.mediaId): peerId: \(peerId)")
        
        ZChatReceivedKit.setReceivedMessage(message, peerId)
    }
    /// SDK 断线重连时触发 当前使用的 RTM Token 已超过 24 小时的签发有效期
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        self.reconnect()
    }
}
