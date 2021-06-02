
import UIKit
import HandyJSON
import SwiftBasicKit

class ZModelIMConnection: ZModelIMEvent {
    
    var client_id: String = ""
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        guard let model = instance as? Self else { return }
        
        self.event_code = model.event_code
        self.call_id = model.call_id
        self.type = model.type
        self.client_id = model.client_id
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.client_id <-- "data.client_id"
    }
}
