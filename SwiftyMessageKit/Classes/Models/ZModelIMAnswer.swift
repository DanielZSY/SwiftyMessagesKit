
import UIKit
import HandyJSON
import SwiftBasicKit

/// 应答事件
class ZModelIMAnswer: ZModelIMEvent {
    
    /// aappid
    var aappid: String = ""
    /// 频道ID
    var channel_id: String = ""
    /// 频道Token
    var channel_token: String = ""
    /// 被叫者
    var callee: ZModelUserInfo?
    /// 是否可见
    var issee: Bool = true
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.issee = model.issee
        self.aappid = model.aappid
        self.channel_id = model.channel_id
        self.channel_token = model.channel_token
        if let user = model.callee {
            self.callee = ZModelUserInfo.init(instance: user)
        }
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.aappid <-- "data.aaid"
        mapper <<< self.channel_id <-- "data.channel_id"
        mapper <<< self.channel_token <-- "data.channel_token"
        mapper <<< self.callee <-- "data.callee"
    }
}
