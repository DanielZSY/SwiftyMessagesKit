
import UIKit
import SwiftBasicKit

class ZVideoBlurEffectView: UIView {

    private lazy var z_imageicon: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init(self.width/2 - 33/2, self.height/2 - 24/2, 33, 24))
        item.image = Asset.iconSeeW.image.withRenderingMode(.alwaysTemplate)
        item.tintColor = "#FFFFFF".color
        return item
    }()
    private lazy var z_lbtitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init(0, self.height/2 + 24, self.width, 25))
        item.textAlignment = .center
        item.textColor = "#FFFFFF".color
        item.boldSize = 14
        item.text = ZString.lbClose.text
        return item
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.border(color: .clear, radius: 10, width: 0)
        self.backgroundColor = "#000000".color.withAlphaComponent(0.95)
        self.addSubview(self.z_imageicon)
        self.addSubview(self.z_lbtitle)
    }
    final func func_changeframe(vframe: CGRect) {
        self.frame = vframe
        if vframe.size.width == kScreenWidth {
            self.z_imageicon.tintColor = "#b8b7b9".color
            self.border(color: .clear, radius: 0, width: 0)
            self.z_imageicon.frame = CGRect.init(vframe.size.width/2 - 88/2, 168 + kStatusHeight, 88, 64)
            self.z_lbtitle.frame = CGRect.init(0, self.z_imageicon.y + self.z_imageicon.height + 18.scale, vframe.size.width, 25)
            self.z_lbtitle.text = ZString.lbVideoCloseBigTips.text
        } else {
            self.z_imageicon.tintColor = "#FFFFFF".color
            self.border(color: .clear, radius: 10, width: 0)
            self.z_imageicon.frame = CGRect.init(vframe.size.width/2 - 33/2, vframe.size.height/2 - 24/2, 33, 24)
            self.z_lbtitle.frame = CGRect.init(0, self.z_imageicon.y + self.z_imageicon.height + 18.scale, vframe.size.width, 25)
            self.z_lbtitle.text = ZString.lbClose.text
        }
    }
}
