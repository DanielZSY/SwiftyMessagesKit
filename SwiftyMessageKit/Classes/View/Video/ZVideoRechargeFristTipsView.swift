
import UIKit
import SwiftBasicKit

/// 用户无余额第一次提示
class ZVideoRechargeFristTipsView: UIView {

    var z_modelBalance: ZModelIMBalance? {
        didSet {
            guard let model = self.z_modelBalance else { return }
            
            let text = (model.biz_notify_recharge?.content.count == 0) ? ZString.lbRechargeFristTips.text : model.biz_notify_recharge!.content
            z_lbcontent.text = text
            z_lbcontent.height = text.getHeight(z_lbcontent.font, width: z_lbcontent.width)
            z_lbbalance.text = model.balance.str
        }
    }
    var z_onbtncloseclick: (() -> Void)?
    var z_onbtncontinueclick: ((_ recharge: ZModelIMRecharge?) -> Void)?
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.width/2 - 20, 0, 40, 40))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowDown.image, for: .normal)
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.backgroundColor = "#1E1925".color
        return z_temp
    }()
    private lazy var z_btnContinue: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(249.scale, 50.scale, 110.scale, 37.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setTitle(ZString.btnContinue.text, for: .normal)
        z_temp.setTitleColor("#E9E9E9".color, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: z_temp.height/2, width: 0)
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    private lazy var z_lbcontent: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(21.scale, 32.scale, 180.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.text = ZString.lbRechargeFristTips.text
        z_temp.numberOfLines = 0
        return z_temp
    }()
    private lazy var z_lbyourbalance: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(21.scale, 82.scale, 100.scale, 20.scale))
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 15
        z_temp.text = ZString.lbYourBalance.text
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbbalance: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(150.scale, 82.scale, 130.scale, 20.scale))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        z_temp.text = ZString.lbYourBalance.text
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(132.scale, 82.scale + 3.5.scale, 11.scale, 13.scale))
        z_temp.image = Asset.iconDiamond1.image
        return z_temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewcontent)
        self.addSubview(z_btnclose)
        self.bringSubviewToFront(z_btnclose)
        
        z_viewcontent.addSubview(z_lbcontent)
        z_viewcontent.addSubview(z_lbbalance)
        z_viewcontent.addSubview(z_lbyourbalance)
        z_viewcontent.addSubview(z_imagecoins)
        z_viewcontent.addSubview(z_btnContinue)
        
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_btnContinue.addTarget(self, action: "func_btncontinueclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btncloseclick() {
        self.z_onbtncloseclick?()
    }
    @objc private func func_btncontinueclick() {
        self.z_onbtncontinueclick?(self.z_modelBalance?.biz_notify_recharge)
    }
}
