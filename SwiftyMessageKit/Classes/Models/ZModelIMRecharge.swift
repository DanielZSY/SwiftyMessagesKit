
import UIKit
import HandyJSON
import SwiftBasicKit

/// 通知充值
class ZModelIMRecharge: ZModelIMEvent {
    
    var id: Int = 0
    /// 通知内容，也可自行定制
    var content: String = ""
    /// ID, 1:apa, 2:gpa, 3:ppa
    var gid: Int = 0
    /// 内购ID
    var code: String = ""
    /// 金额 $
    var price: Double = 0
    /// 实得数
    var token_amount: Int = 0
    /// 原本数
    var original_token_amount: Int = 0
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.id = model.id
        self.content = model.content
        self.gid = model.gid
        self.code = model.code
        self.price = model.price
        self.token_amount = model.token_amount
        self.original_token_amount = model.original_token_amount
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.id <-- "recharge.id"
        mapper <<< self.content <-- "content"
        mapper <<< self.gid <-- "recharge.gid"
        mapper <<< self.code <-- "recharge.code"
        mapper <<< self.price <-- "recharge.price"
        mapper <<< self.token_amount <-- "recharge.token_amount"
        mapper <<< self.original_token_amount <-- "recharge.original_token_amount"
    }
}
