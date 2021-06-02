
import UIKit
import SwiftBasicKit

class ZGiftItemCVC: ZBaseCVC {
    
    var z_model: ZModelGift? {
        didSet {
            z_viewgift.z_model = self.z_model
        }
    }
    private lazy var z_viewgift: ZGiftItemButton = {
        let z_temp = ZGiftItemButton.init(frame: self.contentView.bounds)
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.z_viewgift)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
