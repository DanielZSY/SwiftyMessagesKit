
import UIKit
import SwiftBasicKit

class ZVideoFollowView: UIView {

    var z_onbuttonfollowclick: (() -> Void)?
    private lazy var z_btncontent: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(0, 0, self.width - self.height, self.height))
        
        return z_temp
    }()
    private lazy var z_imageicon: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(14.scale, 7.scale, 14.5.scale, 15.5.scale))
        z_temp.image = Asset.iconFollow.image
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(35.5.scale, 0, self.width - 40.scale, self.height))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 13
        z_temp.adjustsFontSizeToFitWidth = true
        z_temp.text = ZString.lbVideoFollowDesc.text
        return z_temp
    }()
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.width - self.height, 0, self.height, self.height))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnCloseWS.image, for: .normal)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: self.height - 16.scale, bottom: self.height - 16.scale, right: 0)
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = "#7037E9".color
        self.border(color: .clear, radius: self.height/2, width: 0)
        
        self.alpha = 0
        self.isHidden = true
        self.isUserInteractionEnabled = true
        self.addSubview(z_imageicon)
        self.addSubview(z_lbtitle)
        self.addSubview(z_btnclose)
        self.addSubview(z_btncontent)
        self.bringSubviewToFront(z_btncontent)
        
        z_btncontent.addTarget(self, action: "func_btncontentclick", for: .touchUpInside)
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private final func func_btncontentclick() {
        self.z_onbuttonfollowclick?()
    }
    @objc private final func func_btncloseclick() {
        self.dismissAnimateView()
    }
    final func showAnimateView() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
    }
    final func dismissAnimateView() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
        })
    }
}
