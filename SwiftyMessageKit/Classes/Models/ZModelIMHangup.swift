
import UIKit
import HandyJSON
import SwiftBasicKit

class ZModelIMHangup: ZModelIMEvent {
    
    /// Hunting是否完成
    var hunting_finished: Bool = false
    /// 挂断原因: 11: 主叫方取消呼叫 12: 被叫方未接 13: 被叫方拒接 21: 观众挂断 22: 主播挂断 31: 检测到通话已结束 32: 观众余额不足
    var end_reason: kEnumVideoHungup = .none
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.hunting_finished = model.hunting_finished
        self.end_reason = model.end_reason
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.hunting_finished <-- "data.hunting_finished"
        mapper <<< self.end_reason <-- "data.end_reason"
    }
}
