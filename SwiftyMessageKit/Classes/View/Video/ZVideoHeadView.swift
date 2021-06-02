
import UIKit
import SwiftBasicKit

class ZVideoHeadView: UIView {

    var z_isfollow: Bool = false {
        didSet {
            self.z_btnfollow.isHidden = self.z_isfollow
        }
    }
    var z_time: Int = 0 {
        didSet {
            self.z_lbtime.text = self.z_time.strTime
        }
    }
    var z_oncloseclick: (() -> Void)?
    var z_onfollowclick: ((_ follow: Bool) -> Void)?
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(10, 0, 50, 50))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        return z_temp
    }()
    private lazy var z_imageclose: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(10, 10, 30, 30))
        z_temp.image = Asset.btnCloseR.image
        return z_temp
    }()
    private lazy var z_lbtime: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(65, 10, 90.scale, 30))
        z_temp.text = "00:00"
        z_temp.textAlignment = .center
        z_temp.textColor = "#FFFFFF".color
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.66)
        z_temp.boldSize = 18
        z_temp.border(color: .clear, radius: 15, width: 0)
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_btnfollow: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(65 + 100.scale, 0, 95.scale, 50))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_viewfollow: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 10, z_btnfollow.width, 30))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.66)
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    private lazy var z_imagefollow: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(14, 8, 15, 16))
        z_temp.image = Asset.iconFollow.image
        return z_temp
    }()
    private lazy var z_lbfollow: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(33, 0, z_btnfollow.width - 40, 30))
        z_temp.text = ZString.lbFollow.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_btnclose)
        self.addSubview(z_lbtime)
        self.addSubview(z_btnfollow)
        z_btnclose.addSubview(z_imageclose)
        z_btnfollow.addSubview(z_viewfollow)
        z_viewfollow.addSubview(z_imagefollow)
        z_viewfollow.addSubview(z_lbfollow)
        
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_btnfollow.addTarget(self, action: "func_btnfollowclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btncloseclick() {
        self.z_oncloseclick?()
    }
    @objc private func func_btnfollowclick() {
        self.z_onfollowclick?(true)
    }
}
