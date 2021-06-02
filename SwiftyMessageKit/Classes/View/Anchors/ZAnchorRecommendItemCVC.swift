
import UIKit
import SwiftBasicKit

class ZAnchorRecommendItemCVC: ZBaseCVC {
    
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 10.scale, 173.scale, 252.scale))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: .clear, radius: 10.scale, width: 0)
        return z_temp
    }()
    private lazy var z_imageonline: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(5.scale, 7.scale, 57.scale, 20.scale))
        
        return z_temp
    }()
    private lazy var z_imagedown: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, z_imagephoto.height - 69.scale, z_imagephoto.width, 69.scale))
        z_temp.image = Asset.defaultTransparent.image.down
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(10.scale, 18.scale, z_imagedown.width - 20.scale, 25.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagecountry: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10.scale, 46.scale, 18.scale, 14.scale))
        
        return z_temp
    }()
    private lazy var z_lbcountry: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(31.scale, z_imagecountry.y - 5.scale, 70.scale, 24.scale))
        z_temp.textColor = "#BFBDBE".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(101.scale, 47.scale, 10.scale, 12.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(116.scale, z_imagecoins.y - 6.scale, 55.scale, 24.scale))
        z_temp.textColor = "#BFBDBE".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(z_imagephoto)
        z_imagephoto.addSubview(z_imageonline)
        z_imagephoto.addSubview(z_imagedown)
        z_imagedown.addSubview(z_lbusername)
        z_imagedown.addSubview(z_imagecountry)
        z_imagedown.addSubview(z_lbcountry)
        z_imagedown.addSubview(z_imagecoins)
        z_imagedown.addSubview(z_lbcoins)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    final func func_setcvcmodel(model: ZModelUserInfo) {
        // 无国籍显示白白
        z_imagecountry.image = model.countrycode.count == 2 ? UIImage.assetImage(named: model.countrycode.uppercased()) : UIImage()
        z_imagephoto.setImageWitUrl(strUrl: model.avatar, placeholder: Asset.defaultAvatar.image)
        z_lbusername.text = model.nickname + "," + model.age.str
        z_lbcoins.text = model.price.str + "/" + ZString.lbMin.text
        z_lbcountry.text = model.country
        z_imageonline.onlineImage(online: model.is_online, busy: model.is_busy)
    }
}
