
import UIKit
import HandyJSON
import SwiftBasicKit

/// 余额变动
class ZModelIMBalance: ZModelIMEvent {
    
    /// 余额
    var balance: Int = 0
    /// 视频开始时间
    var started_at: TimeInterval = 0
    /// 余额所属时刻
    var balance_at: TimeInterval = 0
    /// hunting是否完成
    var hunting_finished: Bool = false
    /// 0: 其他 1:充值 2:通话 3:消息
    var biz_code: Int = 0
    /// 呼叫方向, 0:呼出, 1:呼入
    var biz_direction: Int = 0
    /// 计费分钟
    var biz_duration: Int = 0
    /// 通话ID
    var biz_call_id: Int = 0
    /// 用户花费金币或主播获得金币
    var biz_token: Int = 0
    /// 通话用户花费金币或主播获得金币
    var biz_call_token: Int = 0
    /// 送礼用户花费金币或主播获得金币
    var biz_gift_token: Int = 0
    /// 用户剩余可通话时长,秒
    var biz_remind_duration: Int = 0
    /// 用户总通话时长
    var biz_total_duration: Int = 0
    /// 是否处于免费通话阶段
    var biz_is_in_free: Bool = false
    /// 通知充值, 有的话需要通知，没有就不用通知
    var biz_notify_recharge: ZModelIMRecharge?
    /// 通话对象
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
        self.balance = model.balance
        self.started_at = model.started_at
        self.balance_at = model.balance_at
        self.hunting_finished = model.hunting_finished
        self.biz_code = model.biz_code
        self.biz_direction = model.biz_direction
        self.biz_duration = model.biz_duration
        self.biz_call_id = model.biz_call_id
        self.biz_token = model.biz_token
        self.biz_call_token = model.biz_call_token
        self.biz_gift_token = model.biz_gift_token
        self.biz_remind_duration = model.biz_remind_duration
        self.biz_total_duration = model.biz_total_duration
        self.biz_is_in_free = model.biz_is_in_free
        if let recharge = model.biz_notify_recharge {
            self.biz_notify_recharge = ZModelIMRecharge.init(instance: recharge)
        }
        if let user = model.other_people {
            self.other_people = ZModelUserInfo.init(instance: user)
        }
    }
    override func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.event_code <-- "event_code"
        mapper <<< self.call_id <-- "data.biz.id"
        mapper <<< self.type <-- "data.biz.type"
        mapper <<< self.other_people <-- "data.biz.other_people"
        mapper <<< self.balance <-- "data.balance"
        mapper <<< self.started_at <-- "data.biz.started_at"
        mapper <<< self.balance_at <-- "data.balanced_at"
        mapper <<< self.hunting_finished <-- "data.biz.hunting_finished"
        mapper <<< self.biz_code <-- "data.biz_code"
        mapper <<< self.biz_direction <-- "data.biz.direction"
        mapper <<< self.biz_duration <-- "data.biz.duration"
        mapper <<< self.biz_call_id <-- "data.biz.id"
        mapper <<< self.biz_token <-- "data.biz.token"
        mapper <<< self.biz_call_token <-- "data.biz.call_token"
        mapper <<< self.biz_gift_token <-- "data.biz.gift_token"
        mapper <<< self.biz_remind_duration <-- "data.biz.remind_duration"
        mapper <<< self.biz_is_in_free <-- "data.biz.is_in_free"
        mapper <<< self.biz_notify_recharge <-- "data.biz.notify_recharge"
    }
}
