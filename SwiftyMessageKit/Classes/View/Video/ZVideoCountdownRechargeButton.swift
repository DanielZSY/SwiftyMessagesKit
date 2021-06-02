
import UIKit
import SwiftBasicKit

class ZVideoCountdownRechargeButton: UIButton {

    var z_modelRecharge: ZModelIMRecharge? {
        didSet {
            guard let model = z_modelRecharge else { return }
            z_lbcoins.text = model.token_amount.str
            z_lbprice.text = model.price.strDouble
            startProgress()
        }
    }
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width/2 - 45.scale/2, 10.scale, 45.scale, 30.scale))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FEC919".color
        z_temp.fontSize = 13
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var z_lbprice: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.width/2 - 45.scale/2, self.height - 10.scale - 22.scale, 45.scale, 22.scale))
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.fontSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(self.width/2 - 45.scale/2, self.height/2 - 45.scale/2, 45.scale, 45.scale))
        z_temp.image = Asset.iconDiamond3.image
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var viewProgressBar: ZCircularProgressBar = {
        let z_temp = ZCircularProgressBar.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.lineWidth = 5.scale
        z_temp.progress = 60
        z_temp.maxprogress = 60
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    private lazy var viewContent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(10.scale, 10.scale, self.width - 20.scale, self.height - 20.scale))
        z_temp.backgroundColor = "#6F37E7".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0
        self.isHidden = true
        self.addSubview(viewContent)
        self.addSubview(viewProgressBar)
        self.addSubview(z_lbcoins)
        self.addSubview(z_lbprice)
        self.addSubview(z_imageicon)
        self.sendSubviewToBack(viewContent)
        self.sendSubviewToBack(viewProgressBar)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private final func startProgress() {
        if self.alpha == 1 { return }
        self.viewProgressBar.startProgress()
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let `self` = self else { return }
            self.alpha = 1
        })
        DispatchQueue.DispatchAfter(after: 60, handler: { [weak self] in
            guard let `self` = self else { return }
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let `self` = self else { return }
                self.alpha = 0
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.isHidden = true
            })
        })
    }
}
