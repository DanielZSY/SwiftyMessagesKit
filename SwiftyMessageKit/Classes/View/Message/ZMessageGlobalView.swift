
import UIKit
import BFKit
import SwiftBasicKit

class ZMessageGlobalView: UIView {
    
    private static let defaultFrame: CGRect = CGRect.init(0, -113.scale, kScreenWidth, 113.scale)
    
    /// 收到的消息
    var modelMessage: ZModelSendMessage? {
        didSet {
            setContentChange()
        }
    }
    /// 隐藏倒计时
    private let dismissTime: Double = 5.0
    /// 显示状态
    private var showState: Bool = false
    /// 上一次触发y坐标
    private var lastViewY: CGFloat = -(113).scale
    /// 默认显示y坐标
    private let defaultShowY: CGFloat = kStatusHeight
    private var isBeganPanGesture: Bool = false
    
    private lazy var viewContent: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init((10).scale, (10).scale, self.width - (20).scale, self.height - (20).scale))
        z_temp.backgroundColor = UIColor.init(hex: "#9B41EE")
        z_temp.border(color: UIColor.clear, radius: (20), width: 0)
        return z_temp
    }()
    private lazy var imagePhoto: UIImageView = {
        let z_temp = UIImageView.init(image: Asset.defaultAvatar.image)
        z_temp.frame = CGRect.init((10).scale, viewContent.height/2 - 25.scale, (50).scale, (50).scale)
        z_temp.border(color: UIColor.clear, radius: (25), width: 0)
        return z_temp
    }()
    private lazy var lbNickname: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init((70).scale, imagePhoto.y, viewContent.width - 145.scale, 25.scale))
        z_temp.textColor = UIColor.init(hex: "#FFFFFF")
        z_temp.fontSize = (18)
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var lbTime: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(self.viewContent.width - (75).scale, imagePhoto.y, (60).scale, 25.scale))
        z_temp.textColor = UIColor.init(hex: "#CA90FF")
        z_temp.fontSize = (12)
        z_temp.textAlignment = .right
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var lbMessage: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init((70).scale, imagePhoto.y + imagePhoto.height/2, viewContent.width - (85).scale, (25).scale))
        z_temp.textColor = UIColor.init(hex: "#CA90FF")
        z_temp.fontSize = (12)
        z_temp.numberOfLines = 2
        z_temp.lineBreakMode = .byTruncatingTail
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.viewContent)
        
        self.viewContent.addSubview(self.imagePhoto)
        self.viewContent.addSubview(self.lbNickname)
        self.viewContent.addSubview(self.lbTime)
        self.viewContent.addSubview(self.lbMessage)
        
        self.viewContent.addTarget(self, action: #selector(btnMessageEvent), for: UIControl.Event.touchUpInside)
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureEvent(_:)))
        self.addGestureRecognizer(panGesture)
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    required convenience init() {
        self.init(frame: ZMessageGlobalView.defaultFrame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func panGestureEvent(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began:
            self.lastViewY = self.y
            self.isBeganPanGesture = true
        case .changed:
            let newY = self.lastViewY + translation.y
            if newY < self.defaultShowY {
                self.y = self.lastViewY + translation.y
            }
        case .ended:
            let newY = self.lastViewY - translation.y
            if newY != self.defaultShowY {
                self.dismissAnimate()
            }
            self.isBeganPanGesture = false
        default: break
        }
    }
    @objc private func btnMessageEvent() {
        if self.isBeganPanGesture { return }
        guard let model = self.modelMessage else { return }
        let user = ZModelUserInfo.init()
        user.userid = model.senderid
        user.nickname = model.sendernickname
        user.avatar = model.senderhead
        user.age = model.senderage
        user.gender = model.sendergender
        user.role = model.senderrole
        NotificationCenter.default.post(name: Notification.Names.ShowChatMessageVC, object: user)
        self.dismissAnimate()
    }
    private func setContentChange() {
        if !ZWebSocketKit.shared.isShowMultipleView {
            self.dismissAnimate()
            return
        }
        guard let model = self.modelMessage else {
            self.dismissAnimate()
            return
        }
        defer {
            self.showAnimate()
        }
        if model.senderrole == .customerService {
            self.imagePhoto.image = Asset.userSupport.image
        } else {
            self.imagePhoto.setImageWitUrl(strUrl: model.senderhead, placeholder: Asset.defaultAvatar.image)
        }
        self.lbNickname.text = model.sendernickname
        self.lbTime.text = model.sendtime.strFormat(format: ZKey.timeFormat.HHmm)
        switch model.messagetype {
        case .gift:
            self.lbMessage.text = model.message + " " + ZString.lbGift.text
        default:
            self.lbMessage.text = model.message
        }
        let lbMessageH = self.lbMessage.text!.getHeight(self.lbMessage.font, width: self.lbMessage.width)
        let lbMessageMaxH = self.lbMessage.text!.getOneHeight(self.lbMessage.font, width: self.lbMessage.width)*2
        if lbMessageMaxH < lbMessageH {
            self.lbMessage.height = lbMessageMaxH
        } else {
            self.lbMessage.height = lbMessageH
        }
    }
    /// 显示带动画
    private func showAnimate() {
        self.alpha = 0
        ZAudioCallKit.shared.systemAnswer(true)
        self.frame = ZMessageGlobalView.defaultFrame
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
            self.y = self.defaultShowY
        }, completion: { end in
            DispatchQueue.DispatchAfter(after: self.dismissTime, handler: { [weak self] in
                self?.dismissAnimate()
            })
        })
    }
    /// 隐藏带动画
    private func dismissAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.frame = ZMessageGlobalView.defaultFrame
        }, completion: { end in
            self.removeFromSuperview()
        })
    }
    static func removeAllView() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (item) in
            if item.isMember(of: ZMessageGlobalView.classForCoder()) {
                (item as? ZMessageGlobalView)?.dismissAnimate()
            }
        })
    }
}
