
import UIKit
import SwiftBasicKit

class ZGiftItemButton: UIButton {
    
    var z_model: ZModelGift? {
        didSet {
            funcContentChange()
        }
    }
    private lazy var z_imagegift: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 47.scale/2, 0, 47.scale, 62.scale))
        z_temp.image = Asset.giftImg01.image
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 15.scale, z_lbgiftcoins.y + 3.5.scale, 13.scale, 15.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbgiftname: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, 80.scale, self.width, 22.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.textAlignment = .center
        return z_temp
    }()
    private lazy var z_lbgiftcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width/2, z_lbgiftname.y + z_lbgiftname.height, self.width, 22.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagegift)
        self.addSubview(z_imagecoins)
        self.addSubview(z_lbgiftname)
        self.addSubview(z_lbgiftcoins)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func funcContentChange() {
        guard let model = self.z_model else { return }
        self.z_lbgiftname.text = model.name
        self.z_lbgiftcoins.text = model.price.str
        switch model.id {
        case 1:
            z_imagegift.image = Asset.giftImg01.image
            z_lbgiftname.text = ZString.lbIcecream.text
        case 2:
            z_imagegift.image = Asset.giftImg02.image
            z_lbgiftname.text = ZString.lbLollipop.text
        case 3:
            z_imagegift.image = Asset.giftImg03.image
            z_lbgiftname.text = ZString.lbRose.text
        case 4:
            z_imagegift.image = Asset.giftImg04.image
            z_lbgiftname.text = ZString.lbKiss.text
        case 5:
            z_imagegift.image = Asset.giftImg05.image
            z_lbgiftname.text = ZString.lbBanana.text
        case 6:
            z_imagegift.image = Asset.giftImg06.image
            z_lbgiftname.text = ZString.lbDiamond.text
        case 7:
            z_imagegift.image = Asset.giftImg07.image
            z_lbgiftname.text = ZString.lbCrown.text
        case 8:
            z_imagegift.image = Asset.giftImg08.image
            z_lbgiftname.text = ZString.lbLuxurycar.text
        default: break
        }
        let imageW = z_imagegift.image?.size.width ?? (80).scale
        let imageH = z_imagegift.image?.size.height ?? (65).scale
        let imageX = self.width/2 - imageW/2
        let imageY = (80).scale/2 - imageH/2
        self.z_imagegift.frame = CGRect.init(imageX, imageY, imageW, imageH)
        self.z_lbgiftcoins.width = self.z_lbgiftcoins.text!.getWidth(z_lbgiftcoins.font, height: z_lbgiftcoins.height)
        self.z_lbgiftcoins.x = self.width/2 - self.z_lbgiftcoins.width/2 + self.z_imagecoins.width/2 + 4.scale
        self.z_imagecoins.x = self.z_lbgiftcoins.x - self.z_imagecoins.width - 4.scale
    }
}
