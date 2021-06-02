
import UIKit
import SwiftBasicKit

class ZVideoRechargeItemCVC: ZBaseCVC {
    
    var z_modelRecharge: ZModelRecharge? {
        didSet {
            self.func_contentchange()
        }
    }
    var z_modelPurchase: ZModelPurchase?
    override var tag: Int {
        didSet {
            switch tag {
            case 0:
                z_viewcontent.border(color: "#7037E9".color, radius: 15.scale, width: 3.scale)
            default:
                z_viewcontent.border(color: .clear, radius: 15.scale, width: 3.scale)
            }
        }
    }
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(15.scale, 15.scale, 100.scale, 138.scale))
        z_temp.backgroundColor = "#100D13".color
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_viewcontent.width/2 - 25.scale/2, 27.scale, 25.scale, 30.scale))
        z_temp.image = Asset.iconDiamond2.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_imagecoins.y + z_imagecoins.height, z_viewcontent.width, 33.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.textAlignment = .center
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbprice: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(z_viewcontent.width/2 - 41.scale, z_viewcontent.height - 27.scale - 20.scale, 82.scale, 27.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.textAlignment = .center
        z_temp.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 27.scale/2, width: 0)
        return z_temp
    }()
    private lazy var z_lboff: UILabel = {
        let z_temp = UILabel.init(frame: z_imageoff.bounds)
        z_temp.boldSize = 12
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        return z_temp
    }()
    private lazy var z_imageoff: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, 67.scale, 19.scale))
        z_temp.isHidden = true
        z_temp.image = Asset.btnPurple.image
        z_temp.backgroundColor = "#100D13".color
        let z_temp_path = UIBezierPath.init(roundedRect: z_temp.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize.init(width: 19.scale, height: 19.scale))
        let z_temp_mask = CAShapeLayer.init()
        z_temp_mask.path = z_temp_path.cgPath
        z_temp.layer.mask = z_temp_mask
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewcontent)
        z_viewcontent.addSubview(z_imagecoins)
        z_viewcontent.addSubview(z_lbcoins)
        z_viewcontent.addSubview(z_lbprice)
        z_viewcontent.addSubview(z_imageoff)
        z_imageoff.addSubview(z_lboff)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private final func func_contentchange() {
        guard let modelp = self.z_modelPurchase else { return }
        guard let modelr = self.z_modelRecharge else { return }
        let givetoken = modelr.token_amount - modelr.original_token_amount
        z_imageoff.isHidden = givetoken <= 0
        z_lbprice.text = "$" + modelr.price.strDouble
        if givetoken > 0 {
            let token = modelr.original_token_amount.str
            let otoken = " +" + givetoken.str
            let atttoken = NSMutableAttributedString.init(string: token + otoken)
            atttoken.addAttributes([NSAttributedString.Key.foregroundColor: "#E9E9E9".color], range: NSRange.init(location: 0, length: token.count))
            z_lbcoins.textColor = "#FFC64D".color
            z_lbcoins.attributedText = atttoken
            let givescale = (Double(givetoken) / Double(modelr.original_token_amount)) * 100
            z_lboff.text = givescale.str + "%" + ZString.lbOFF.text
        } else {
            z_lbcoins.textColor = "#E9E9E9".color
            z_lbcoins.text = modelr.original_token_amount.str
            z_lboff.text = ""
        }
    }
}
