
import UIKit
import BFKit
import SnapKit
import SwiftBasicKit

class ZAnchorEvaluationHeadView: UIView {
    
    var onButtonComplaintEvent: (() -> Void)?
    private lazy var viewMain: UIImageView = {
        let item = UIImageView.init(frame: self.bounds)
        item.backgroundColor = "#7037E9".color
        item.isUserInteractionEnabled = true
        item.border(color: .clear, radius: (10).scale, width: 0)
        return item
    }()
    private lazy var imagePhoto: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init((18).scale, (19).scale, (57).scale, (57).scale))
        item.image = Asset.defaultAvatar.image
        item.border(color: .clear, radius: (57/2).scale, width: 0)
        return item
    }()
    private lazy var lbNickname: UILabel = {
        let item = UILabel.init(frame: CGRect.init(self.imagePhoto.x + self.imagePhoto.width + (10).scale, self.imagePhoto.y + (6).scale, (170).scale, (26).scale))
        item.textColor = .white
        item.boldSize = 24
        return item
    }()
    private lazy var lbID: UILabel = {
        let item = UILabel.init(frame: CGRect.init(self.lbNickname.x , self.lbNickname.y + self.lbNickname.height, (250).scale, (20).scale))
        item.textColor = "#B592FF".color
        item.boldSize = 15
        item.text = ZString.lbID.text
        return item
    }()
    private lazy var btnComplaint: UIButton = {
        let item = UIButton.init(frame: CGRect.init(self.width - (102).scale, (10).scale, (92).scale, (30).scale))
        item.titleLabel?.boldSize = 12
        item.adjustsImageWhenHighlighted = false
        item.setTitleColor(.white, for: .normal)
        item.setTitle(ZString.lbComplaint.text, for: .normal)
        item.border(color: .white, radius: (15).scale, width: (1).scale)
        
        return item
    }()
    private lazy var lbTime: UILabel = {
        let item = UILabel.init(frame: CGRect.init((25).scale, self.height - (35).scale, (150).scale, (20).scale))
        
        item.boldSize = 12
        item.textColor = .white
        item.text = ZString.lbTime.text
        item.adjustsFontSizeToFitWidth = true
        return item
    }()
    private lazy var lbDiamonds: UILabel = {
        let item = UILabel.init(frame: CGRect.init(self.width - (175).scale, self.lbTime.y, (150).scale, (20).scale))
        
        item.boldSize = 12
        item.textColor = .white
        item.textAlignment = .right
        item.text = ZString.lbDiamonds.text
        item.adjustsFontSizeToFitWidth = true
        
        return item
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.viewMain)
        
        self.viewMain.addSubview(self.imagePhoto)
        self.viewMain.addSubview(self.btnComplaint)
        self.viewMain.addSubview(self.lbNickname)
        self.viewMain.addSubview(self.lbID)
        self.viewMain.addSubview(self.lbTime)
        self.viewMain.addSubview(self.lbDiamonds)
        
        btnComplaint.addTarget(self, action: "func_btnComplaintclick", for: .touchUpInside)
    }
    @objc private func func_btnComplaintclick() {
        self.onButtonComplaintEvent?()
    }
    final func setViewModel(_ model: ZModelIMBalance) {
        self.lbTime.text = ZString.lbTime.text + ": " + model.biz_total_duration.strTime
        self.lbID.text = ZString.lbID.text + ": " + (model.other_people?.userid ?? "")
        self.lbNickname.text = model.other_people?.nickname ?? ""
        self.lbDiamonds.text = ZString.lbDiamonds.text + ": " + model.biz_token.str
        if let head = model.other_people?.avatar {
            self.imagePhoto.setImageWitUrl(strUrl: head, placeholder: Asset.defaultAvatar.image)
        } else {
            self.imagePhoto.image = Asset.defaultAvatar.image
        }
    }
}
