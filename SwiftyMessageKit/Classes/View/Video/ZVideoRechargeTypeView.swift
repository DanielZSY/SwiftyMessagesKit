
import UIKit
import SwiftBasicKit

class ZVideoRechargeTypeView: UIView {
    
    var z_currentPage: Int = 1 {
        didSet {
            switch z_currentPage {
            case 1:
                z_btntype1.z_isselect = true
                z_btntype2.z_isselect = false
            case 2:
                z_btntype1.z_isselect = false
                z_btntype2.z_isselect = true
            default: break
            }
        }
    }
    var z_arrayType: [ZModelPurchase]? {
        didSet {
            guard let types = z_arrayType else { return }
            z_btntype1.isSelected = false
            z_btntype2.isSelected = true
            for (i, item) in types.enumerated() {
                switch i {
                case 0:
                    z_btntype1.z_model = item
                case 1:
                    z_btntype2.z_model = item
                default: break
                }
            }
        }
    }
    var z_onbuttontypeclick: ((_ row: Int) -> Void)?
    private lazy var z_btntype1: ZVideoRechargeTypeButton = {
        let btnw = (self.width - 15.scale*3)/2
        let z_temp = ZVideoRechargeTypeButton.init(frame: CGRect.init(15.scale, 5.scale, btnw, self.height - 10.scale))
        z_temp.tag = 1
        z_temp.z_isselect = false
        return z_temp
    }()
    private lazy var z_btntype2: ZVideoRechargeTypeButton = {
        let btnw = (self.width - 15.scale*3)/2
        let z_temp = ZVideoRechargeTypeButton.init(frame: CGRect.init(z_btntype1.x + z_btntype1.width + 15.scale, 5.scale, btnw, self.height - 10.scale))
        z_temp.tag = 2
        z_temp.z_isselect = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_btntype1)
        self.addSubview(z_btntype2)
        self.backgroundColor = .clear
        
        z_btntype1.addTarget(self, action: "func_btntypeclick:", for: .touchUpInside)
        z_btntype2.addTarget(self, action: "func_btntypeclick:", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btntypeclick(_ sender: ZVideoRechargeTypeButton) {
        z_currentPage = sender.tag
        z_onbuttontypeclick?(sender.tag)
    }
}
