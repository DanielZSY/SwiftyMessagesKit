
import UIKit
import BFKit
import SnapKit
import SwiftBasicKit

class ZAnchorEvaluationRatingView: UIView {

    private var lastSelectTag: Int = 4
    var onButtonRatingEvent: ((_ row: Int) -> Void)?
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init((16.5).scale, (10).scale, (100).scale, (20).scale))
        item.text = ZString.lbEvaluate.text
        item.textColor = "#F4F4F4".color
        item.boldSize = 15
        return item
    }()
    private lazy var viewRatings: UIView = {
        let item = UIView.init(frame: CGRect.init(0, (40).scale, self.width, self.height - (40).scale))
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
        
        self.innerInitView()
        self.innerInitEvent()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setViewFrame()
    }
    private func innerInitView() {
        self.backgroundColor = "#1E1925".color
        self.border(color: .clear, radius: (10).scale, width: 0)
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.viewRatings)
        btnX = (self.viewRatings.width - btnW*5)/2
        for row in 1...5 {
            self.viewRatings.addSubview(self.getButtonRating(row))
            btnX = btnX + btnW
        }
    }
    private let btnW = (64).scale
    private let btnH = (66).scale
    private var btnX = (0).scale
    private let btnY = (0).scale
    private func getButtonRating(_ row: Int) -> ZAnchorEvaluationRatingButton {
        let item = ZAnchorEvaluationRatingButton.init(frame: CGRect.init(btnX, btnY, btnW, btnH))
        
        item.tag = row
        item.addTarget(self, action: #selector(setButtonRatingEvent(_:)), for: .touchUpInside)
        
        return item
    }
    @objc private func setButtonRatingEvent(_ sender: ZAnchorEvaluationRatingButton) {
        if self.lastSelectTag != sender.tag {
            let btn = self.viewRatings.viewWithTag(self.lastSelectTag) as? ZAnchorEvaluationRatingButton
            btn?.isSelected = false
        }
        sender.isSelected = true
        self.lastSelectTag = sender.tag
        self.onButtonRatingEvent?(sender.tag)
    }
    private func setViewFrame() {
        
    }
    private func innerInitEvent() {
        
    }
}
