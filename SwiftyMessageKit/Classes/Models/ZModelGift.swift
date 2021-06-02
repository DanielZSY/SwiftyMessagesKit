
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

class ZModelGift: ZModelBase {
    
    var price: Int = 0
    var name: String = ""
    
    required init() {
        super.init()
    }
    required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.id = model.id
        self.price = model.price
    }
    required init(row: Row) {
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.id <-- "id"
        mapper <<< self.name <-- "name"
        mapper <<< self.price <-- "price"
    }
}
