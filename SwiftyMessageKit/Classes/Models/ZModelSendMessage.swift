
import UIKit
import HandyJSON
import SwiftBasicKit

/// 自定义消息结构 - 与安卓互通的结构体
class ZModelSendMessage: NSObject, ZModelCopyable, HandyJSON {
    
    /// 礼物ID
    var giftid: Int = 0
    var senderid: String = ""
    var senderhead: String = ""
    var sendernickname: String = ""
    var senderrole: zUserRole = .user
    var sendergender: zUserGender = .female
    var senderage: Int = 0
    var messagetype: zMessageType = .text
    var messageid: String = ""
    var message: String = ""
    var mediaid: String = ""
    var mediapath: String = ""
    var mediasize: Double = 0
    var sendtime: TimeInterval = 0
    /// 是否能拨打回去
    var can_call_back: Bool = false
    
    required override init() {
        super.init()
    }
    required init(instance: ZModelSendMessage) {
        super.init()
        
        self.giftid = instance.giftid
        self.senderid = instance.senderid
        self.senderhead = instance.senderhead
        self.sendernickname = instance.sendernickname
        self.senderrole = instance.senderrole
        self.sendergender = instance.sendergender
        self.senderage = instance.senderage
        self.messagetype = instance.messagetype
        self.messageid = instance.messageid
        self.message = instance.message
        self.mediaid = instance.mediaid
        self.mediapath = instance.mediapath
        self.mediasize = instance.mediasize
        self.sendtime = instance.sendtime
        self.can_call_back = instance.can_call_back
    }
    func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.senderid <-- "senderid"
    }
}
