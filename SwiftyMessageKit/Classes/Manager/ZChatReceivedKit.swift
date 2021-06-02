
import UIKit
import BFKit
import AgoraRtmKit
import SwiftBasicKit

class ZChatReceivedKit: NSObject {
    
    /// 处理接收到的消息
    internal static func setReceivedMessage(_ model: AgoraRtmMessage, _ sendid: String) {
        guard let modelMessage = ZModelSendMessage.deserialize(from: model.text) else { return }
        guard modelMessage.senderid == sendid else { return }
        switch modelMessage.messagetype {
        case .image: ZChatReceivedKit.setMessageImage(modelMessage)
        case .audio: ZChatReceivedKit.setMessageFile(modelMessage)
        default: ZChatReceivedKit.saveMessage(modelMessage)
        }
    }
}
extension ZChatReceivedKit {
    /// 保存消息体
    private static func saveMessage(_ model: ZModelSendMessage) {
        model.messageid = kRandomId
        
        let user = ZModelUserBase()
        user.userid = model.senderid
        user.avatar = model.senderhead
        user.nickname = model.sendernickname
        user.role = model.senderrole
        user.gender = model.sendergender
        user.age = model.senderage
        ZSQLiteKit.setModel(model: user)
        
        // 消息记录
        let msguser = ZModelMessageRecord()
        msguser.message_user = user.copyable()
        switch model.messagetype {
        case .gift: msguser.message = model.message + " " + ZString.lbGift.text
        default: msguser.message = model.message
        }
        msguser.message_id = model.messageid
        msguser.message_type = model.messagetype
        msguser.message_direction = .receive
        msguser.message_time = model.sendtime
        ZSQLiteKit.setModel(model: msguser)
        
        // 单条消息
        let msg = ZModelMessage()
        msg.message_user = user.copyable()
        msg.message_userid = model.senderid
        msg.message = model.message
        msg.message_id = model.messageid
        msg.message_type = msguser.message_type
        msg.message_direction = msguser.message_direction
        msg.message_time = msguser.message_time
        msg.message_file_id = model.mediaid
        msg.message_file_path = model.mediapath
        msg.message_file_size = model.mediasize
        msg.message_can_call_back = model.can_call_back
        ZSQLiteKit.setModel(model: msg)
        
        if ZWebSocketKit.shared.isShowMultipleView {
            ZMessageGlobalView.init().modelMessage = model
        }
        NotificationCenter.default.post(name: Notification.Names.ReceivedNewMessage, object: msg.copyable())
    }
    /// 保存图片消息
    private static func setMessageImage(_ model: ZModelSendMessage) {
        let fileLocalUrl = ZLocalFileApi.imagePath
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        BFLog.debug("request: \(request.pointee), pointer: \(capacity)")
        ZChatSDKKit.shared.agoraRtmKit?.downloadMedia(model.mediaid, toFile: fileLocalUrl.path, withRequest: request, completion: { (requestId, error) in
            BFLog.debug("requestId: \(requestId)")
            if error == .ok {
                model.mediapath = fileLocalUrl.lastPathComponent
                model.message = ZString.messageisaPhoto.text
                ZChatReceivedKit.saveMessage(model)
            }
        })
    }
    /// 保存文件消息
    private static func setMessageFile(_ model: ZModelSendMessage) {
        let fileLocalUrl = ZLocalFileApi.wavFilePath
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        BFLog.debug("request: \(request.pointee), pointer: \(capacity)")
        ZChatSDKKit.shared.agoraRtmKit?.downloadMedia(model.mediaid, toFile: fileLocalUrl.path, withRequest: request, completion: { (requestId, error) in
            BFLog.debug("requestId: \(requestId)")
            if error == .ok {
                model.mediapath = fileLocalUrl.lastPathComponent
                model.message = ZString.messageisaAudio.text
                ZChatReceivedKit.saveMessage(model)
            }
        })
    }
}
