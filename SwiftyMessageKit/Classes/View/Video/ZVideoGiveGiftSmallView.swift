
import UIKit
import SwiftBasicKit

/// 视频小礼物连续动画效果
class ZVideoGiveGiftSmallView: UIView {
    
    var z_modelgift: ZModelGift?
    /// 试图高度
    static let ViewHeight: CGFloat = (70).scale
    /// 上一次送礼物的类型
    private var lastGiftImage: kEnumGiftImage = .IceCream
    /// 累计同一个礼物的数量
    private var totalCount: Int = 0
    /// 显示多少秒结束
    private var showTime: Int = 0
    /// 礼物数字图片列表
    private let listGiftNum = [Asset.giftNum0.image,
                               Asset.giftNum1.image,
                               Asset.giftNum2.image,
                               Asset.giftNum3.image,
                               Asset.giftNum4.image,
                               Asset.giftNum5.image,
                               Asset.giftNum6.image,
                               Asset.giftNum7.image,
                               Asset.giftNum8.image,
                               Asset.giftNum9.image]
    /// 礼物图片列表
    private let listGift = [Asset.giftImg01.image,
                            Asset.giftImg02.image,
                            Asset.giftImg03.image,
                            Asset.giftImg04.image,
                            Asset.giftImg05.image,
                            Asset.giftImg06.image,
                            Asset.giftImg07.image,
                            Asset.giftImg08.image]
    
    private lazy var viewGiftBG: UIView = {
        let item = UIView.init()
        item.backgroundColor = "#000000".color.withAlphaComponent(0.6)
        item.border(color: UIColor.clear, radius: (15), width: 0)
        return item
    }()
    private lazy var viewGift: UIView = {
        let item = UIView.init()
        item.backgroundColor = .clear
        return item
    }()
    private lazy var imageHead: UIImageView = {
        let item = UIImageView.init(image: Asset.defaultAvatar.image)
        item.backgroundColor = .clear
        item.border(color: UIColor.clear, radius: (22).scale, width: 0)
        return item
    }()
    private lazy var lbNickName: UILabel = {
        let item = UILabel.init()
        item.backgroundColor = .clear
        item.textColor = "#FFAC04".color
        item.fontSize = 14
        item.adjustsFontSizeToFitWidth = true
        return item
    }()
    private lazy var lbGiftInfo: UILabel = {
        let item = UILabel.init()
        item.backgroundColor = .clear
        item.textColor = "#FFFFFF".color
        item.fontSize = 14
        item.text = ZString.lbGivea.text
        return item
    }()
    private lazy var viewGiftContent: UIView = {
        let item = UIView.init()
        item.backgroundColor = .clear
        return item
    }()
    private lazy var imageGift: UIImageView = {
        let item = UIImageView.init(image: Asset.giftImg01.image)
        item.backgroundColor = .clear
        item.contentMode = .center
        return item
    }()
    private lazy var viewGiftNumber: UIView = {
        let item = UIView.init()
        item.backgroundColor = .clear
        return item
    }()
    /// 乘以
    private lazy var imageMultiplied: UIImageView = {
        let item = UIImageView.init(image: Asset.giftNumX.image)
        item.backgroundColor = .clear
        return item
    }()
    /// 个位数
    private lazy var imageBit: UIImageView = {
        let item = UIImageView.init(image: Asset.giftNum0.image)
        item.backgroundColor = .clear
        return item
    }()
    /// 十位数
    private lazy var imageTen: UIImageView = {
        let item = UIImageView.init(image: Asset.giftNum0.image)
        item.backgroundColor = .clear
        return item
    }()
    /// 百位数
    private lazy var imageBai: UIImageView = {
        let item = UIImageView.init(image: Asset.giftNum0.image)
        item.backgroundColor = .clear
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
        
        self.alpha = 0
        self.isHidden = true
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        self.addSubview(self.viewGiftBG)
        self.addSubview(self.viewGift)
        self.sendSubviewToBack(self.viewGiftBG)
        self.viewGift.addSubview(self.imageHead)
        self.viewGift.addSubview(self.lbNickName)
        self.viewGift.addSubview(self.lbGiftInfo)
        self.viewGift.addSubview(self.viewGiftContent)
        self.viewGiftContent.addSubview(self.imageGift)
        self.addSubview(self.viewGiftNumber)
        self.viewGiftNumber.addSubview(self.imageMultiplied)
        self.viewGiftNumber.addSubview(self.imageBit)
        self.viewGiftNumber.addSubview(self.imageTen)
        self.viewGiftNumber.addSubview(self.imageBai)
        
        self.setViewFrame()
    }
    private func setViewFrame() {
        self.viewGiftBG.frame = CGRect.init(-(15).scale, (5).scale, (240).scale, (60).scale)
        self.viewGift.frame = self.viewGiftBG.frame
        let imageHeadS = (40).scale
        let imageHeadY = self.viewGift.height/2 - imageHeadS/2
        self.imageHead.frame = CGRect.init((30).scale, imageHeadY, imageHeadS, imageHeadS)
        
        let lbNickNameX = self.imageHead.x + self.imageHead.width + (9.5).scale
        
        self.lbNickName.frame = CGRect.init(lbNickNameX, (12).scale, (80).scale, (20).scale)
        self.lbGiftInfo.frame = CGRect.init(lbNickNameX, self.lbNickName.y + self.lbNickName.height, (80).scale, (18).scale)
        
        let viewGiftContentX = self.lbNickName.x + self.lbNickName.width + (5).scale
        self.viewGiftContent.frame = CGRect.init(viewGiftContentX, 0, self.viewGiftBG.height, self.viewGiftBG.height)
        
        self.setViewImageFrame()
        
        let viewGiftNumberX = self.viewGiftBG.x + self.viewGiftBG.width + (7.5).scale
        self.viewGiftNumber.frame = CGRect.init(viewGiftNumberX, (5).scale, (100).scale, (60).scale)
        let imageMultipliedS = (21).scale
        let imageMultipliedY = self.viewGiftNumber.height/2 - imageMultipliedS/2
        self.imageMultiplied.frame = CGRect.init(0, imageMultipliedY, imageMultipliedS, imageMultipliedS)
        let imageBitX = self.imageMultiplied.x + self.imageMultiplied.width + (5).scale
        let imageBitH = (28).scale
        let imageBitW = (20).scale
        let imageOnesPlacY = self.viewGiftNumber.height/2 - imageBitH/2
        self.imageBit.frame = CGRect.init(imageBitX, imageOnesPlacY, imageBitW, imageBitH)
        let imageTenX = self.imageBit.x + self.imageBit.width + (2).scale
        let imageTenH = (28).scale
        let imageTenW = (20).scale
        let imageTenY = self.viewGiftNumber.height/2 - imageTenH/2
        self.imageTen.frame = CGRect.init(imageTenX, imageTenY, imageTenW, imageTenH)
        let imageBaiX = self.imageTen.x + self.imageTen.width + (2).scale
        self.imageBai.frame = CGRect.init(imageBaiX, imageTenY, imageTenW, imageTenH)
    }
    private func setViewImageFrame() {
        let imageMaxW = self.viewGiftContent.width
        let imageMaxH = self.viewGiftContent.height
        self.imageGift.frame = CGRect.init(0, 0, imageMaxW, imageMaxH)
    }
    final func setViewModelUserInfo(_ model: ZModelUserBase?) {
        guard let user = model else { return }
        self.lbNickName.text = user.nickname
        self.imageHead.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
    }
    final func setShowViewGiftImage(_ type: kEnumGiftImage) {
        if self.lastGiftImage == type {
            self.totalCount += 1
        } else {
            self.totalCount = 1
            switch type {
            case .IceCream:
                self.imageGift.image = self.listGift[0]
            case .Lollipop:
                self.imageGift.image = self.listGift[1]
            case .Rose:
                self.imageGift.image = self.listGift[2]
            case .Kiss:
                self.imageGift.image = self.listGift[3]
            case .Banana:
                self.imageGift.image = self.listGift[4]
            case .Diamond:
                self.imageGift.image = self.listGift[5]
            case .Crown:
                self.imageGift.image = self.listGift[6]
            case .LuxuryCar:
                self.imageGift.image = self.listGift[7]
            }
        }
        self.isHidden = false
        if self.alpha == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            })
        }
        var bitNumber: Int = 0
        var tenNumber: Int = 0
        var baiNumber: Int = 0
        var countStr = self.totalCount.str
        switch countStr.count {
        case 1:
            bitNumber = 0
            tenNumber = self.totalCount
            baiNumber = 0
            self.imageBai.isHidden = true
        case 2:
            bitNumber = 0
            tenNumber = countStr[0].intValue
            baiNumber = countStr[1].intValue
            self.imageBai.isHidden = false
        case 3:
            bitNumber = countStr[0].intValue
            tenNumber = countStr[1].intValue
            baiNumber = countStr[2].intValue
            self.imageBai.isHidden = false
        default: break
        }
        self.imageBit.image = self.listGiftNum[bitNumber]
        self.imageTen.image = self.listGiftNum[tenNumber]
        self.imageBai.image = self.listGiftNum[baiNumber]
        self.setViewNumberAnimate(self.imageBit)
        self.setViewNumberAnimate(self.imageTen)
        if countStr.count > 1 {
            self.setViewNumberAnimate(self.imageBai)
        }
        self.setViewNumberAnimate(self.imageMultiplied)
        self.lastGiftImage = type
        self.showTime = 5
    }
    /// 设置数字变大动画
    final func setViewNumberAnimate(_ view: UIImageView) {
        view.layer.removeAllAnimations()
        let animation = CABasicAnimation.init()
        animation.keyPath = "transform.scale"
        animation.toValue = 1.5
        animation.repeatCount = 1
        animation.duration = 0.1
        // 是否自动反转
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        view.layer.add(animation, forKey: "transform.scale")
    }
    final func setDismissGiftImageView() {
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
