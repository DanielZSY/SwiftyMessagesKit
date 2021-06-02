
import UIKit
import SwiftBasicKit

class ZBalanceButton: UIButton {

    var text: String = "" {
        didSet {
            z_lbcoins.text = text
            let lbw = text.getWidth(z_lbcoins.font, height: z_lbcoins.height)
            z_imagecoins.x = self.width - lbw - 5 - z_imagecoins.width
        }
    }
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, self.height/2 - 19.scale/2, 17.scale, 19.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(20.scale, 0, self.width - 20.scale, self.height))
        z_temp.boldSize = 14
        z_temp.textColor = "#FFFFFF".color
        z_temp.textAlignment = .right
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.adjustsImageWhenHighlighted = false
        self.addSubview(z_imagecoins)
        self.addSubview(z_lbcoins)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
