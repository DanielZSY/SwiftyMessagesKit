
import UIKit
import HandyJSON
import SwiftBasicKit

/// 频道状态
class ZModelIMStatus: ZModelIMEvent {
    
    /// Hunting是否完成
    var hunting_finished: Bool = false
    /// 在线状态
    var is_online: Bool = false
    /// 呼叫状态, 1:呼叫中, 2:通话中, 3:通话已结束
    var status: Int = 0
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
        self.hunting_finished = model.hunting_finished
        self.is_online = model.is_online
        self.status = model.status
        self.direction = model.direction
        if let user = model.other_people {
            self.other_people = ZModelUserInfo.init(instance: user)
        }
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.hunting_finished <-- "data.hunting_finished"
        mapper <<< self.is_online <-- "data.is_online"
    }
}
