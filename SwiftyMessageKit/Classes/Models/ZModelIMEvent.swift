
import UIKit
import HandyJSON
import SwiftBasicKit

private let kZGRDBReferenceRowKey: String = "referenceRow"
/// IM事件
class ZModelIMEvent: NSObject, HandyJSON, ZModelCopyable {
    
    /// 事件
    var event_code: kEnumSocketEvent = .connect
    /// 视频通话ID, 假主播呼叫时此字段为null
    var call_id: Int = 0
    /// 通话类型, 1:普通, 2:Hunting
    var type: Int = 0
    
    required override init() {
        super.init()
    }
    required init<T: ZModelIMEvent>(instance: T) {
        super.init()
        
        self.event_code = instance.event_code
        self.call_id = instance.call_id
        self.type = instance.type
    }
    func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.event_code <-- "event_code"
        mapper <<< self.call_id <-- "data.call_id"
        mapper <<< self.type <-- "data.type"
    }
    func toDictionary() -> [String: Any]? {
        var dic = self.toJSON()
        dic?.removeValue(forKey: kZGRDBReferenceRowKey)
        return dic
    }
}
