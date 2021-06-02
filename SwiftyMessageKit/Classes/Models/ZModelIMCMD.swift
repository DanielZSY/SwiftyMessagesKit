
import UIKit
import HandyJSON
import SwiftBasicKit

/// 自定义命令
class ZModelIMCMD: ZModelIMEvent {
    
    var content: [String: Any]?
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.content = model.content
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.content <-- "data.content"
    }
}
