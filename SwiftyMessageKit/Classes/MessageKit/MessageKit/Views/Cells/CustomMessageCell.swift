
import UIKit
import SwiftBasicKit

class CustomMessageCell: UICollectionViewCell {
    
    private lazy var viewcontent: UIView = {
        let temp = UIView.init(frame: CGRect.init(30, 5, 135, 40))
        temp.clipsToBounds = false
        return temp
    }()
    private lazy var viewbg: UIView = {
        let temp = UIView.init(frame: viewcontent.bounds)
        temp.border(color: .clear, radius: 10, width: 0)
        return temp
    }()
    private lazy var lbmessage: MessageLabel = {
        let temp = MessageLabel.init(frame: CGRect.init(10, 5, 60, 30))
        temp.textColor = "#FFCC1E".color
        temp.boldSize = 15
        temp.adjustsFontSizeToFitWidth = true
        return temp
    }()
    private lazy var imageicon: UIImageView = {
        let temp = UIImageView.init(frame: CGRect.init(74, 0, 47, 62))
        return temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(viewcontent)
        viewcontent.addSubview(viewbg)
        viewbg.addSubview(lbmessage)
        viewcontent.addSubview(imageicon)
        viewcontent.bringSubviewToFront(imageicon)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .custom(let param):
            if let dic = param as? [String: Any], let type = dic["type"] as? Int {
                switch type {
                case 1: // 礼物
                    let gid = (dic["id"] as? String)?.intValue ?? (dic["id"] as? Int) ?? 1
                    switch gid {
                    case 1:
                        imageicon.image = Asset.giftImg01.image
                    case 2:
                        imageicon.image = Asset.giftImg02.image
                    case 3:
                        imageicon.image = Asset.giftImg03.image
                    case 4:
                        imageicon.image = Asset.giftImg04.image
                    case 5:
                        imageicon.image = Asset.giftImg05.image
                    case 6:
                        imageicon.image = Asset.giftImg06.image
                    case 7:
                        imageicon.image = Asset.giftImg07.image
                    case 8:
                        imageicon.image = Asset.giftImg08.image
                    default: break
                    }
                    let imageW = imageicon.image?.size.width ?? (80).scale
                    let imageH = imageicon.image?.size.height ?? (65).scale
                    if message.sender.senderId == ZSettingKit.shared.userId {
                        viewcontent.frame = CGRect.init(self.contentView.width - 145, 10, 140, 45)
                    } else {
                        viewcontent.frame = CGRect.init(5, 10, 140, 45)
                    }
                    viewbg.backgroundColor = "#2D2538".color
                    viewbg.frame = CGRect.init(0, 0, viewcontent.width, 40)
                    let imageY = viewbg.height/2 - imageH/2
                    lbmessage.frame = CGRect.init(10, 10, 60, 30)
                    lbmessage.textColor = "#FFCC1E".color
                    lbmessage.text = ZString.lbGivea.text
                    imageicon.frame = CGRect.init(lbmessage.x + lbmessage.width + 10, imageY, imageW, imageH)
                case 2: // call
                    viewcontent.frame = CGRect.init(5, 10, 135, 50)
                    viewbg.backgroundColor = "#C12070".color
                    viewbg.frame = CGRect.init(0, 0, viewcontent.width, 45)
                    imageicon.image = Asset.btnCall.image
                    imageicon.frame = CGRect.init(10, 12, 17, 21)
                    lbmessage.frame = CGRect.init(36, 12.5, 90, 30)
                    lbmessage.text = ZString.lbCallMissed.text
                    lbmessage.textColor = "#FFFFFF".color
                default: break
                }
            }
        default: break
        }
    }
}
open class CustomMessageSizeCalculator: MessageSizeCalculator {
    
    public override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let layout = layout else { return .zero }
        let collectionViewWidth = layout.collectionView?.frame.size.width ?? 0
        let contentInset = layout.collectionView?.contentInset ?? .zero
        let inset = layout.sectionInset.left + layout.sectionInset.right + contentInset.left + contentInset.right
        return CGSize(width: collectionViewWidth - inset, height: 60)
    }
    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
    }
}
open class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    open lazy var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    open override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
    open override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var superCalculators = super.messageSizeCalculators()
        // Append any of your custom `MessageSizeCalculator` if you wish for the convenience
        // functions to work such as `setMessageIncoming...` or `setMessageOutgoing...`
        superCalculators.append(customMessageSizeCalculator)
        return superCalculators
    }
}
