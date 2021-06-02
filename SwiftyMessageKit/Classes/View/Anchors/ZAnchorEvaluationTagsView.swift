
import UIKit
import BFKit
import SnapKit
import SwiftBasicKit

class ZAnchorEvaluationTagsView: UIView {

    var onButtonTagEvent: ((_ row: Int, _ isSelect: Bool) -> Void)?
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init((16.5).scale, (10).scale, (100).scale, (21).scale))
        item.text = ZString.lbAddTags.text
        item.textColor = "#F4F4F4".color
        item.boldSize = 15
        return item
    }()
    private lazy var viewTags: UIView = {
        let item = UIView.init(frame: CGRect.init(0, (41).scale, self.width, self.height - (41).scale))
        return item
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = "#1E1925".color
        self.border(color: .clear, radius: (10).scale, width: 0)
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.viewTags)
        let btnW = (self.viewTags.width - space*3) / 3
        for row in 1...9 {
            self.viewTags.addSubview(self.getButtonTag(row, btnW))
            btnX = btnX + btnW + (4).scale
            if (btnX + btnW) > self.viewTags.width {
                btnX = (8).scale
                btnY = btnY + btnH + space
            }
        }
    }
    private let space = (8).scale
    private let btnH = (32).scale
    private var btnX = (8).scale
    private var btnY = (0).scale
    private func getButtonTag(_ row: Int, _ w: CGFloat) -> UIButton {
        let item = UIButton.init(frame: CGRect.init(btnX, btnY, w, btnH))
        
        item.tag = row
        item.titleLabel?.boldSize = 15
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.adjustsFontSizeToFitWidth = true
        item.setTitleColor(UIColor.init(hex: "#989898"), for: .normal)
        item.setTitleColor(UIColor.init(hex: "#FFFFFF"), for: .selected)
        item.setBackgroundImage(UIImage.init(color: UIColor.init(hex: "#1E1925")), for: .normal)
        item.setBackgroundImage(UIImage.init(color: UIColor.init(hex: "#7037E9")), for: .selected)
        item.addTarget(self, action: #selector(setButtonTagEvent(_:)), for: .touchUpInside)
        item.border(color: "#56565C".color, radius: (16).scale, width: 2.scale)
        
        return item
    }
    @objc private func setButtonTagEvent(_ sender: UIButton) {
        self.onButtonTagEvent?(sender.tag, !sender.isSelected)
    }
    final func setButtonIsSelect(_ row: Int, isSelect: Bool) {
        if let btn = self.viewTags.viewWithTag(row) as? UIButton {
            btn.isSelected = isSelect
        }
    }
    final func setViewModelTags(_ models: [ZModelTag]) {
        var row: Int = 1
        models.forEach { (model) in
            if let btn = self.viewTags.viewWithTag(row) as? UIButton {
                btn.setTitle(model.tagname, for: .normal)
                btn.setTitle(model.tagname, for: .selected)
            }
            row += 1
        }
    }
}
