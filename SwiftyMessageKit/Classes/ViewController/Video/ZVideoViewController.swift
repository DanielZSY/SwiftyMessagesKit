
import UIKit
import BFKit
import SwiftBasicKit

class ZVideoViewController: ZBaseViewController {
    
    /// 应答对象
    internal var modelAnswer: ZModelIMAnswer? {
        didSet {
            self.z_callid = self.modelAnswer?.call_id ?? 0
            self.z_userid = self.modelAnswer?.callee?.userid ?? ""
        }
    }
    internal var currentPage: Int = 1
    internal var isDismissing: Bool = false
    /// 视频对方的用户详细信息
    internal var modeluser: ZModelUserInfo?
    /// 视频收到过余额事件
    internal var modelBalance: ZModelIMBalance?
    internal var z_callid: Int = 0
    internal var z_userid: String = ""
    /// 当前通话时长
    internal var currenttime: Int = 0
    /// 时间为5隐藏底部区域
    internal var dismissbottomtime: Int = 10
    /// 检测频道状态间隔时间
    internal let checkstatustime: Int = 15
    /// 我的视频是否在最小区域
    internal var ismyminvideo: Bool = true
    /// 用户是否开启了毛玻璃
    internal var isFuzzy: Bool = false
    /// 礼物清单已经获取完毕
    internal var isGetGiftListEnd: Bool = false
    /// 充值套餐已经获取完毕
    internal var isGetRechargeEnd: Bool = false
    
    internal let viewmaxFrame: CGRect = CGRect.main()
    internal let viewminFrame: CGRect = CGRect.init(kScreenWidth - 15 - 75, kStatusHeight + 10, 76, 118)
    internal lazy var z_videosdk: ZVideoSDKKit = {
        let z_temp = ZVideoSDKKit.init(model: self.modelAnswer)
        return z_temp
    }()
    internal lazy var z_viewvideomax: UIView = {
        let z_temp = UIView.init(frame: viewmaxFrame)
        z_temp.backgroundColor = .clear
        return z_temp
    }()
    internal lazy var z_viewvideomin: UIView = {
        let z_temp = UIView.init(frame: viewminFrame)
        z_temp.backgroundColor = .clear
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    internal lazy var z_viewwater: ZVideoBlurEffectView = {
        let z_temp = ZVideoBlurEffectView.init(frame: viewminFrame)
        z_temp.isHidden = true
        return z_temp
    }()
    internal lazy var z_btnchangevideo: UIButton = {
        let z_temp = UIButton.init(frame: viewminFrame)
        return z_temp
    }()
    internal lazy var z_viewcontent: ZBaseSV = {
        let z_temp = ZBaseSV.init(frame: CGRect.main())
        z_temp.tag = 10
        z_temp.bounces = false
        z_temp.backgroundColor = .clear
        z_temp.isPagingEnabled = true
        z_temp.scrollsToTop = false
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.contentSize = CGSize.init(width: kScreenWidth * 2, height: kScreenHeight)
        //z_temp.contentOffset = CGPoint.init(x: kScreenWidth, y: 0)
        return z_temp
    }()
    internal lazy var z_viewai: UIActivityIndicatorView = {
        let z_temp = UIActivityIndicatorView.init(frame: CGRect.init(kScreenWidth/2 - 35/2, kScreenHeight/2 - 35/2, 35, 35))
        z_temp.style = .whiteLarge
        return z_temp
    }()
    internal lazy var z_viewhead: ZVideoHeadView = {
        let z_temp = ZVideoHeadView.init(frame: CGRect.init(kScreenWidth, kStatusHeight, kScreenWidth, 50))
        
        return z_temp
    }()
    internal lazy var z_viewmessages: ZVideoMessageView = {
        let z_temp = ZVideoMessageView.init(frame: CGRect.init(kScreenWidth, kScreenHeight - 300, kScreenWidth, 230))
        return z_temp
    }()
    internal lazy var z_viewinputbar: ZVideoInputView = {
        let z_temp = ZVideoInputView.init(frame: CGRect.init(kScreenWidth, kScreenHeight - 70, kScreenWidth, 70))
        return z_temp
    }()
    internal let viewgivegiftFrame: CGRect = CGRect.init(0, kStatusHeight + 50, kScreenWidth, 70)
    internal lazy var z_viewgivegiftsmall: ZVideoGiveGiftSmallView = {
        let z_temp = ZVideoGiveGiftSmallView.init(frame: viewgivegiftFrame)
        z_temp.isUserInteractionEnabled = false
        return z_temp
    }()
    internal lazy var z_viewrechargetips: ZVideoRechargeTipsView = {
        let z_temp = ZVideoRechargeTipsView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, 97))
        return z_temp
    }()
    internal lazy var z_viewrechargefristtips: ZVideoRechargeFristTipsView = {
        let z_temp = ZVideoRechargeFristTipsView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, 120))
        return z_temp
    }()
    internal lazy var z_btnCountdownRecharge: ZVideoCountdownRechargeButton = {
        let z_temp = ZVideoCountdownRechargeButton.init(frame: CGRect.init(kScreenWidth - 85.scale - 12.scale, viewminFrame.origin.y + viewminFrame.size.height + 10.scale, 85.scale, 85.scale))
        z_temp.isHidden = true
        z_temp.isUserInteractionEnabled = true
        return z_temp
    }()
    internal lazy var z_viewgivegifttips: ZVideoGiveGiftTipsView = {
        let z_temp = ZVideoGiveGiftTipsView.init(frame: CGRect.init(0, kScreenHeight, kScreenWidth, 83.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    internal lazy var z_viewfollow: ZVideoFollowView = {
        let z_temp = ZVideoFollowView.init(frame: CGRect.init(5.scale, kScreenHeight, 230.scale, 30.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    internal let z_viewmodel: ZVideoViewModel = ZVideoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.z_viewmodel.vc = self
        self.view.addSubview(z_viewai)
        self.view.addSubview(z_viewvideomax)
        self.view.addSubview(z_viewvideomin)
        self.view.addSubview(z_viewwater)
        self.view.addSubview(z_viewcontent)
        self.view.addSubview(z_viewrechargetips)
        self.view.addSubview(z_viewrechargefristtips)
        self.view.addSubview(z_viewfollow)
        self.view.addSubview(z_btnchangevideo)
        self.view.addSubview(z_viewgivegiftsmall)
        self.view.addSubview(z_viewgivegifttips)
        self.view.addSubview(z_btnCountdownRecharge)
        
        self.z_viewcontent.addSubview(z_viewhead)
        self.z_viewcontent.addSubview(z_viewinputbar)
        self.z_viewcontent.addSubview(z_viewmessages)
        
        self.func_setupviewui()
        self.func_setupviewevent()
        self.func_addNotification()
        self.func_viewchangebring()
        self.setViewMainFrame()
        
        z_viewai.startAnimating()
        z_videosdk.joinChannel()
        z_viewmodel.delegate = self
        z_viewmodel.func_reloadgiftarray()
        z_viewmodel.func_reloadrechargearray()
        z_viewmodel.func_requestuserdetail(userid: self.modelAnswer?.callee?.userid ?? "")
        
        ZWebSocketKit.shared.isShowMultipleView = false
        z_viewcontent.delegate = self
        if self.modelAnswer?.issee == false {
            self.func_btnseeclick()
        }
    }
    final func func_viewchangebring() {
        if self.ismyminvideo {
            self.view.bringSubviewToFront(z_viewvideomax)
            self.view.bringSubviewToFront(z_viewvideomin)
            self.view.bringSubviewToFront(z_viewwater)
        } else {
            self.view.bringSubviewToFront(z_viewvideomin)
            self.view.bringSubviewToFront(z_viewwater)
            self.view.bringSubviewToFront(z_viewvideomax)
        }
        self.view.bringSubviewToFront(z_viewcontent)
        self.view.bringSubviewToFront(z_viewgivegiftsmall)
        self.view.bringSubviewToFront(z_btnchangevideo)
        self.view.bringSubviewToFront(z_viewai)
        self.view.bringSubviewToFront(z_viewfollow)
        self.view.bringSubviewToFront(z_viewrechargetips)
        self.view.bringSubviewToFront(z_viewrechargefristtips)
        self.view.bringSubviewToFront(z_viewgivegifttips)
        self.view.bringSubviewToFront(z_btnCountdownRecharge)
    }
    deinit {
        self.z_viewcontent.delegate = nil
        self.z_viewmodel.delegate = nil
        self.z_viewinputbar.inputTextView.delegate = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardNotification()
    }
    override func keyboardFrameChange(_ height: CGFloat) {
        super.keyboardFrameChange(height)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.setViewMainFrame()
        })
    }
    private func setViewMainFrame() {
        let viewBottomY = kScreenHeight - self.z_viewinputbar.height - self.keyboardHeight
        self.z_viewinputbar.y = kScreenHeight - self.z_viewinputbar.height - self.keyboardHeight
        self.z_viewfollow.y = self.z_viewinputbar.y - 35.scale
        self.z_viewgivegifttips.y = self.z_viewinputbar.y - 88.scale
        if self.z_viewfollow.isHidden {
            self.z_viewmessages.y = kScreenHeight - self.z_viewmessages.height - self.z_viewinputbar.height - self.keyboardHeight
            self.z_viewmessages.height = 230
        } else {
            self.z_viewmessages.y = kScreenHeight - self.z_viewmessages.height - self.z_viewinputbar.height - self.keyboardHeight
            self.z_viewmessages.height = 230 - 40.scale
        }
        let smally = self.z_viewmessages.y - self.z_viewgivegiftsmall.height - 20.scale
        let smallminy = self.z_viewhead.y + self.z_viewhead.height
        self.z_viewgivegiftsmall.y = smally > smallminy ? smally : smallminy
    }
    internal func func_dismissvc() {
        if self.isDismissing { return }
        self.isDismissing = true
        self.func_removeNotification()
        self.z_videosdk.leaveChannel()
        ZVideoViewModel.func_sendhangup(model: self.modelAnswer)
        
        self.modelBalance?.biz_total_duration = self.currenttime
        self.modelBalance?.other_people = self.modeluser?.copyable()
        if let mb = self.modelBalance, self.currenttime > 65 {
            var obj = [String: Any]()
            obj["data"] = mb.copyable()
            obj["type"] = "Evaluation"
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: {
                ZObserverKit.shared.isShowingVideoVC = false
                ZWebSocketKit.shared.isShowMultipleView = true
                NotificationCenter.default.post(name: Notification.Names.ShowVideoEndVC, object: obj)
            })
            return
        }
        ZRouterKit.dismiss(fromVC: self, animated: false, completion: {
            ZObserverKit.shared.isShowingVideoVC = false
            ZWebSocketKit.shared.isShowMultipleView = true
            NotificationCenter.default.post(name: Notification.Names.ShowVideoEndVC, object: 1)
        })
    }
    private func func_setupviewui() {
        self.z_viewgivegiftsmall.setViewModelUserInfo(ZSettingKit.shared.user)
        self.z_viewinputbar.inputTextView.delegate = self
        self.z_viewinputbar.z_viewrecharge.z_coins = ZSettingKit.shared.balance
        self.z_viewinputbar.z_viewgifts.z_coins = ZSettingKit.shared.balance
    }
    /// 发送文本
    private final func startSendMessage(_ text: String) {
        // 文本内容不能为空
        guard text.length > 0 && text.length <= kMaxMessage else {
            self.z_viewinputbar.inputTextView.resignFirstResponder()
            return
        }
        BFLog.debug("start send message text: \(text)")
        /// 创建消息对象
        let sendTime = Date()
        let messageid = kRandomId
        let model = ZModelMessage.init()
        if let user = self.modelAnswer?.callee {
            model.message_userid = user.userid
            model.message_user = ZModelUserBase.init(instance: user)
        }
        model.message_id = messageid
        model.message = text
        model.message_type = .text
        model.message_time = sendTime.timeIntervalSince1970
        model.message_read_state = true
        model.message_issave = false
        model.message_json = ZChatSDKKit.sendMessageJson(model: model)
        ZChatSDKKit.shared.startSendMessage(model)
        
        self.z_viewmessages.addMessageModel(model)
        self.z_viewinputbar.inputTextView.text = ""
        self.z_viewinputbar.z_lbplaceholder.isHidden = false
    }
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                self.startSendMessage(str)
            }
        }
    }
}
extension ZVideoViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.startSendMessage(textView.text)
            return false
        }
        let currentText = textView.text ?? ""
        var textLength = currentText.length + text.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: text)
            textLength = newText.length
        }
        self.z_viewinputbar.z_lbplaceholder.isHidden = textLength > 0
        if textLength > kMaxMessage { return false }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.z_viewinputbar.z_btngift.isSelected = false
        self.z_viewinputbar.z_btnrecharge.isSelected = false
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > kMaxMessage {
            let text = textView.text ?? ""
            textView.text = String(text[..<text.index(text.startIndex, offsetBy: kMaxMessage)])
        }
        self.z_viewinputbar.z_lbplaceholder.isHidden = textView.text.count > 0
    }
}
extension ZVideoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            let currentIndex = Int(floor(scrollView.contentOffset.x/(scrollView.frame.size.width/3*2)))
            if currentIndex != currentPage {
                self.view.endEditing(true)
                currentPage = currentIndex
            }
        }
    }
}
