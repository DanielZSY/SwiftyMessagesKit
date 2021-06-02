
import UIKit
import BFKit
import SnapKit
import SwiftBasicKit

class ZAnchorEvaluationRatingButton: UIButton {
    
    private lazy var imageIcon: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init(self.width/2 - (36/2).scale, 0, (36).scale, (36).scale))
        return item
    }()
    private lazy var imageIconS: UIImageView = {
        let item = UIImageView.init(frame: self.imageIcon.frame)
        item.alpha = 0
        return item
    }()
    private lazy var lbValue: UILabel = {
        let item = UILabel.init(frame: CGRect.init(0, self.height - (20).scale, self.width, (20).scale))
        item.textAlignment = .center
        item.boldSize = 12
        item.textColor = "#515158".color
        return item
    }()
    private lazy var lbValueS: UILabel = {
        let item = UILabel.init(frame: self.lbValue.frame)
        item.alpha = 0
        item.textAlignment = .center
        item.boldSize = 12
        item.textColor = "#3F08C2".color
        return item
    }()
    
    override var tag: Int {
        didSet {
            switch self.tag {
            case 1:
                self.imageIcon.image = Asset.evaVeryBad.image
                self.imageIconS.image = Asset.evaVeryBadS.image
                self.lbValue.text = ZString.lbVerybad.text
                self.lbValueS.text = ZString.lbVerybad.text
            case 2:
                self.imageIcon.image = Asset.evaBad.image
                self.imageIconS.image = Asset.evaBadS.image
                self.lbValue.text = ZString.lbBad.text
                self.lbValueS.text = ZString.lbBad.text
            case 3:
                self.imageIcon.image = Asset.evaGeneral.image
                self.imageIconS.image = Asset.evaGeneralS.image
                self.lbValue.text = ZString.lbGeneral.text
                self.lbValueS.text = ZString.lbGeneral.text
            case 4:
                self.isSelected = true
                self.imageIcon.image = Asset.evaGood.image
                self.imageIconS.image = Asset.evaGoodS.image
                self.lbValue.text = ZString.lbGood.text
                self.lbValueS.text = ZString.lbGood.text
            case 5:
                self.imageIcon.image = Asset.evaVeryGood.image
                self.imageIconS.image = Asset.evaVeryGoodS.image
                self.lbValue.text = ZString.lbVeryGood.text
                self.lbValueS.text = ZString.lbVeryGood.text
            default: break
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.25, animations: {
                    self.imageIcon.alpha = 0
                    self.imageIconS.alpha = 1
                    self.lbValue.alpha = 0
                    self.lbValueS.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.imageIcon.alpha = 1
                    self.imageIconS.alpha = 0
                    self.lbValue.alpha = 1
                    self.lbValueS.alpha = 0
                })
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageIcon)
        self.addSubview(self.imageIconS)
        self.addSubview(self.lbValue)
        self.addSubview(self.lbValueS)
    }
}
