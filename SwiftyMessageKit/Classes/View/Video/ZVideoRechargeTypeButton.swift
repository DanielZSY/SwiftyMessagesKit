
import UIKit
import SwiftBasicKit

class ZVideoRechargeTypeButton: UIButton {
    
    var z_isselect: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.z_isselect {
                    self.z_imageselect.alpha = 1
                    self.z_imagenormal.alpha = 0
                } else {
                    self.z_imageselect.alpha = 0
                    self.z_imagenormal.alpha = 1
                }
            })
        }
    }
    var z_model: ZModelPurchase? {
        didSet {
            guard let model = z_model else { return }
            z_imageselect.setImageWitUrl(strUrl: model.select, placeholder: UIImage.init(color: "#311E35".color))
            z_imagenormal.setImageWitUrl(strUrl: model.normal, placeholder: UIImage.init(color: "#271048".color))
            z_imageselect.contentMode = .scaleToFill
            z_imagenormal.contentMode = .scaleToFill
        }
    }
    private lazy var z_imageselect: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.alpha = 0
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    private lazy var z_imagenormal: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.alpha = 0
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(z_imageselect)
        self.addSubview(z_imagenormal)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
