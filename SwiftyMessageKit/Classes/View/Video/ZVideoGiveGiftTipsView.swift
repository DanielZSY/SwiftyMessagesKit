
import UIKit
import SwiftBasicKit

/// 索要礼物提示页面
class ZVideoGiveGiftTipsView: UIView {

    var z_modelgift: ZModelGift? {
        didSet {
            self.showTime = 5
            guard let model = self.z_modelgift else { return }
            switch model.id {
            case 1: z_imagegift.image = Asset.giftImg01.image
            case 2: z_imagegift.image = Asset.giftImg02.image
            case 3: z_imagegift.image = Asset.giftImg03.image
            case 4: z_imagegift.image = Asset.giftImg04.image
            case 5: z_imagegift.image = Asset.giftImg05.image
            case 6: z_imagegift.image = Asset.giftImg06.image
            case 7: z_imagegift.image = Asset.giftImg07.image
            case 8: z_imagegift.image = Asset.giftImg08.image
            default: break
            }
            var imagew = z_imagegift.image?.size.width ?? 89.scale
            var imageh = z_imagegift.image?.size.height ?? self.height
            if imagew > 89.scale {
                imagew = 89.scale
            }
            if imageh > self.height {
                imageh = self.height
            }
            z_imagegift.frame = CGRect.init(z_imagegift.x, self.height/2 - imageh/2, imagew, imageh)
            z_lbtitle.x = z_imagegift.x + z_imagegift.width + 5.scale
        }
    }
    var z_onbtngiveclick: ((_ model: ZModelGift?) -> Void)?
    private var showTime: Int = 5
    private lazy var z_viewcontent: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(20.scale, 0, 335.scale, self.height))
        z_temp.border(color: .clear, radius: 15, width: 0)
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.6)
        return z_temp
    }()
    private lazy var z_imagegift: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(24.scale, 0, 89.scale, self.height))
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(118.scale, self.height/2 - 15, 140.scale, 30))
        z_temp.text = ZString.lbGiveGiftTips.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 12
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_btnclose: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_viewcontent.width - 35, 0, 35, 35))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.isHighlighted = false
        z_temp.setImage(Asset.btnCloseWS.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btngive: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(260.scale, self.height/2 - 16, 60.scale, 32))
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.isHighlighted = false
        z_temp.setTitle(ZString.btnGive.text, for: .normal)
        z_temp.setTitleColor("#FFFFFF".color, for: .normal)
        z_temp.titleLabel?.boldSize = 15
        z_temp.backgroundColor = "#7037E9".color
        z_temp.border(color: .clear, radius: 16, width: 0)
        return z_temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.border(color: .clear, radius: 15.scale, width: 0)
        self.backgroundColor = .clear
        self.addSubview(z_viewcontent)
        z_viewcontent.addSubview(z_imagegift)
        z_viewcontent.addSubview(z_lbtitle)
        z_viewcontent.addSubview(z_btnclose)
        z_viewcontent.addSubview(z_btngive)
        
        z_btnclose.addTarget(self, action: "func_btncloseclick", for: .touchUpInside)
        z_btngive.addTarget(self, action: "func_btngiveclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btncloseclick() {
        self.showTime = -1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { end in
            self.isHidden = true
        })
    }
    @objc private func func_btngiveclick() {
        self.z_onbtngiveclick?(self.z_modelgift)
        self.func_btncloseclick()
    }
    final func setDismissGiveGiftView() {
        self.showTime -= 1
        if self.showTime < 0 { return }
        if self.showTime == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { end in
                self.isHidden = true
            })
        }
    }
}
