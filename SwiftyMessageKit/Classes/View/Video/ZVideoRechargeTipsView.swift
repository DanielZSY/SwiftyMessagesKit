
import UIKit
import BFKit
import SwiftBasicKit

/// 视频充值提示页面
class ZVideoRechargeTipsView: UIView {
    
    var z_modelBalance: ZModelIMBalance? {
        didSet {
            guard let model = self.z_modelBalance else { return }
            
            let text = (model.biz_notify_recharge?.content.count == 0) ? ZString.lbRechargeTipsContent.text : model.biz_notify_recharge!.content
            //let att = NSMutableAttributedString.init(string: text)
            //z_lbcontent.attributedText = att
            z_lbcontent.textColor = "#FFFFFF".color
            z_lbcontent.text = text
            if let range = text.nsranges(of: "1 mins").first {
                self.func_changecontentcolor(range: range, text: text)
            } else if let range = text.nsranges(of: "2 mins").first {
                self.func_changecontentcolor(range: range, text: text)
            } else if let range = text.nsranges(of: "3 mins").first {
                self.func_changecontentcolor(range: range, text: text)
            } else if let range = text.nsranges(of: "30 seconds").first {
                self.func_changecontentcolor(range: range, text: text)
            }
        }
    }
    var z_onbtncloseclick: (() -> Void)?
    var z_onbtncontinueclick: ((_ recharge: ZModelIMRecharge?) -> Void)?
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(self.width/2 - 20, 0, 40, 40))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.arrowDown.image.withRenderingMode(.alwaysTemplate), for: .normal)
        z_temp.imageView?.tintColor = "#56565C".color
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, self.height))
        z_temp.backgroundColor = "#1E1925".color
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    private lazy var z_btnContinue: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(259.scale, 27.scale, 110.scale, 37.scale))
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
        let z_temp = UILabel.init(frame: CGRect.init(21.scale, 24.scale, 200.scale, 24))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        z_temp.text = ZString.lbRechargeTipsContent.text
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_lbdesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(21.scale, 55.scale, 200.scale, 30))
        z_temp.textColor = "#515158".color
        z_temp.boldSize = 12
        z_temp.text = ZString.lbRechargeTips.text
        z_temp.numberOfLines = 0
        return z_temp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewcontent)
        self.addSubview(z_btnclose)
        self.bringSubviewToFront(z_btnclose)
        self.isUserInteractionEnabled = true
        
        z_viewcontent.addSubview(z_lbcontent)
        z_viewcontent.addSubview(z_lbdesc)
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
        self.z_btnContinue.isEnabled = false
        self.z_onbtncontinueclick?(self.z_modelBalance?.biz_notify_recharge)
    }
    private func func_changecontentcolor(range: NSRange, text: String) {
        let att = NSMutableAttributedString.init(string: text)
        att.addAttributes([NSAttributedString.Key.foregroundColor : "#C12070".color], range: range)
        z_lbcontent.attributedText = att
    }
}
