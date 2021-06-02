
import UIKit
import HandyJSON
import SwiftBasicKit

/// 呼叫事件
class ZModelIMCall: ZModelIMEvent {
    
    /// 呼叫方向, 0:呼出, 1:呼入
    var direction: Int = 0
    /// 对方信息
    var other_people: ZModelUserInfo?
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.direction = model.direction
        if let user = model.other_people {
            self.other_people = ZModelUserInfo.init(instance: user)
        }
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.direction <-- "data.direction"
        mapper <<< self.other_people <-- "data.other_people"
    }
}
