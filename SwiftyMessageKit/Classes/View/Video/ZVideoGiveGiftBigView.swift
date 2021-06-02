
import UIKit
import SwiftBasicKit

/// 视频大礼物连续动画效果
class ZVideoGiveGiftBigView: UIView {
    
    static let ViewWidth: CGFloat = (333).scale
    static let ViewHeight: CGFloat = (278).scale
    private var showTime: Int = 5
    
    private lazy var imageBigGift: UIImageView = {
        let item = UIImageView.init()
        return item
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0
        self.isHidden = true
        self.backgroundColor = .clear
        self.addSubview(self.imageBigGift)
        self.isUserInteractionEnabled = false
        
        self.setViewFrame()
    }
    private func setViewFrame() {
        let imageMaxW = ZVideoGiveGiftBigView.ViewWidth
        let imageMaxH = ZVideoGiveGiftBigView.ViewHeight
        var imageW1 = self.imageBigGift.image?.size.width ?? imageMaxW
        var imageH1 = self.imageBigGift.image?.size.height ?? imageMaxH
        imageW1 = imageW1 > imageMaxW ? imageMaxW : imageW1
        imageH1 = imageH1 > imageMaxH ? imageMaxH : imageH1
        let imageX1 = self.width/2 - imageW1/2
        let imageY1 = self.height/2 - imageH1/2
        self.imageBigGift.frame = CGRect.init(imageX1, imageY1, imageW1, imageH1)
    }
    final func setShowViewGiftImage(_ type: kEnumGiftImage) {
        var svgName = Asset.giftImg01.image
        switch type {
        case .Lollipop: svgName = Asset.giftImg02.image
        case .Rose: svgName = Asset.giftImg03.image
        case .Kiss: svgName = Asset.giftImg04.image
        case .Banana: svgName = Asset.giftImg05.image
        case .Diamond: svgName = Asset.giftImg06.image
        case .Crown: svgName = Asset.giftImg07.image
        case .LuxuryCar: svgName = Asset.giftImg08.image
        default: break
        }
        self.imageBigGift.image = svgName
        self.setViewFrame()
        self.isHidden = false
        if self.alpha == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            })
        }
        self.imageBigGift.layer.removeAnimation(forKey: "Animation_transform_scale")
        
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "transform.scale";
        animation.values = [1.0,1.25,1.5,1.25,1.0]
        animation.repeatCount = MAXFLOAT
        animation.duration = 0.5
        // 是否自动反转
        animation.autoreverses = false
        animation.isRemovedOnCompletion = true
        self.imageBigGift.layer.add(animation, forKey: "Animation_transform_scale")
        
        self.showTime = 5
    }
    final func setDismissViewGiftImage() {
        self.showTime -= 1
        if self.showTime < 0 {
            return
        }
        if self.showTime == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { end in
                self.isHidden = true
            })
        }
    }
}
