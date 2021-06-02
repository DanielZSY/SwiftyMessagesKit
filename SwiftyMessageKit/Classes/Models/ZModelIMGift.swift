
import UIKit
import HandyJSON
import SwiftBasicKit

/// 收到礼物事件
class ZModelIMGift: ZModelIMEvent {
    
    /// 礼物ID
    var gift_id: Int = 0
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.gift_id = model.gift_id
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.gift_id <-- "data.gift_id"
    }
}
