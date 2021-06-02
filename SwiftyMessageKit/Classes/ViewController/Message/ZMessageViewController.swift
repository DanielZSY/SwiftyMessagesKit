
import UIKit
import BFKit
import SwiftBasicKit
import ESPullToRefresh

class ZMessageViewController: MessagesViewController {
    
    /// 发送者背景颜色
    public var currentBGColor: UIColor = "#2D2538".color
    /// 接收者背景颜色
    public var receiveBGColor: UIColor = "#1E1925".color
    /// 发送者文本颜色
    public var currentTextColor: UIColor = "#FFFFFF".color
    /// 接收者文本颜色
    public var receiveTextColor: UIColor = "#FFFFFF".color
    /// 发送按钮背景颜色
    public var buttonSendBGColor: UIColor = "#7037E9".color
    /// 输入区域背景颜色
    public var inputBarBGColor: UIColor = "#000000".color
    /// 输入框背景颜色
    public var inputViewBGColor: UIColor = "#2D2538".color
    /// 输入框提示文本颜色
    public var inputPlaceholderColor: UIColor = "#56565C".color
    /// 输入框文本颜色
    public var inputTextColor: UIColor = "#FFFFFF".color
    /// 当前登录用户
    public var loginUser: ZModelMessageKitUser {
        let loginUser = ZSettingKit.shared.user ?? ZModelUserBase.init()
        let messageUser = ZModelMessageKitUser.init(senderId: loginUser.userid, displayName: loginUser.nickname, head: loginUser.avatar, role: loginUser.role.rawValue, gender: loginUser.gender.rawValue)
        return messageUser
    }
    /// 接受者用户对象
    public var modelUser: ZModelUserInfo?
    /// 数据集合
    public var arrayMessage: [ZModelMessageKit] = [ZModelMessageKit]()
    /// 是否显示该页面
    public var isCurrentShowVC: Bool = false
    /// 礼物集合
    internal var arrayGifts: [ZModelGift] = [ZModelGift]()
    /// AudioPlayManager
    internal lazy var audioPlayManager = AudioPlayManager(messageCollectionView: self.messagesCollectionView)
    /// 顶部组件
    private lazy var z_viewhead: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, kScreenWidth, kTopNavHeight + 10))
        z_temp.backgroundColor = "#100D13".color
        return z_temp
    }()
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(45, kStatusHeight + 5, 35, 35))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: .clear, radius: 35/2, width: 0)
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_tempx = z_imagephoto.x + z_imagephoto.width + 7
        let z_temp = UILabel.init(frame: CGRect.init(z_tempx, z_imagephoto.y - 2, kScreenWidth - z_tempx - 100.scale, 20))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 14
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    private lazy var z_imageonline: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(z_imagephoto.x + z_imagephoto.width + 7, z_imagephoto.y + z_imagephoto.height/2 + 2, 38, 14))
        return z_temp
    }()
    lazy var z_viewrecordaudio: ZMessageRecordAudioView = {
        let z_temp = ZMessageRecordAudioView.init(frame: CGRect.init(kScreenWidth/2 - 100.scale, kScreenHeight/2 - 100.scale, 200.scale, 200.scale))
        z_temp.isHidden = true
        z_temp.border(color: .clear, radius: 15, width: 0)
        return z_temp
    }()
    /// 扣金币提示
    private lazy var z_viewcoinstips: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(10.scale, kTopNavHeight + 10.scale, 355.scale, 35.scale))
        z_temp.backgroundColor = "#1E1925".color.withAlphaComponent(0.8)
        z_temp.border(color: .clear, radius: 10.scale, width: 0)
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_imagecoinstips: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(7.scale, 6.5.scale, 22.scale, 22.scale))
        z_temp.image = Asset.iconCoinsTip.image
        return z_temp
    }()
    private lazy var z_lbcoinstips: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(41.scale, 2.5.scale, 300.scale, 30.scale))
        z_temp.textColor = "#493443".color
        z_temp.boldSize = 15
        z_temp.text = ZReload.shared.message_price.str + ZString.lbMessagePriceTips.text
        z_temp.adjustsFontSizeToFitWidth = true
        return z_temp
    }()
    /// 底部按钮
    private lazy var z_btnAudioN: ZMessageButton = {
        let z_temp = ZMessageButton.init(frame: CGRect.init(0, 0, 45, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnAudioN.image, for: .normal)
        z_temp.setTitle(" ", for: .normal)
        return z_temp
    }()
    private lazy var z_btnAudioS: ZMessageButton = {
        let z_temp = ZMessageButton.init(frame: CGRect.init(0, 0, 45, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnAudioS.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnAlbum: ZMessageButton = {
        let z_temp = ZMessageButton.init(frame: CGRect.init(0, 0, 45, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnAlbum.image, for: .normal)
        z_temp.setTitle("    ", for: .normal)
        return z_temp
    }()
    private lazy var z_btnGift: ZMessageButton = {
        let z_temp = ZMessageButton.init(frame: CGRect.init(0, 0, 45, 45))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnGift.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnAudioPress: ZMessageButton = {
        let z_temp = ZMessageButton.init(frame: CGRect.init(0, 0, 298.scale, 45))
        z_temp.setTitle(ZString.inputAudioProssDown.text, for: .normal)
        z_temp.setTitle(ZString.inputAudioProssDown.text, for: .highlighted)
        z_temp.setBackgroundImage(Asset.btnPurple.image, for: .normal)
        z_temp.setBackgroundImage(Asset.btnPurple.image.withAlpha(0.7), for: .highlighted)
        z_temp.border(color: .clear, radius: 10, width: 0)
        return z_temp
    }()
    private lazy var z_viewgifts: ZGiftView = {
        let z_temp = ZGiftView.init(frame: CGRect.init(0, 0, kScreenWidth - 20, 250.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.8)
        return z_temp
    }()
    private let z_viewmodel: ZMessageViewModel = ZMessageViewModel()
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.z_viewmodel.vc = self
        self.func_setupviewui()
        self.func_setupviewevent()
        self.func_setupviewdata()
        self.func_userdetailchange()
        
        self.z_viewmodel.delegate = self
        self.z_viewmodel.func_reloadgiftarray()
        self.z_viewmodel.func_reloaduserdetail(userid: self.modelUser?.userid ?? "")
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.func_addbackbutton()
        self.isCurrentShowVC = true
        ZCurrentVC.shared.currentVC = self
        self.messageInputBar.setNeedsLayout()
        ZWebSocketKit.shared.isShowMultipleView = false
        self.z_viewgifts.z_coins = ZSettingKit.shared.balance
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        (self.navigationController as? ZNavigationController)?.shadowImage = UIImage.init(color:  ZColor.shared.NavBarLineColor)?.withAlpha(0)
        (self.navigationController as? ZNavigationController)?.backgroundImage = UIImage.init(color: ZColor.shared.NavBarTintColor)?.withAlpha(0)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isCurrentShowVC = false
        self.audioPlayManager.stopAnyOngoingPlaying()
        ZWebSocketKit.shared.isShowMultipleView = true
        AudioRecordManager.sharedInstance.cancelRrcord()
        NotificationCenter.default.post(name: Notification.Names.MessageUnReadCount, object: nil)
    }
    private func func_addbackbutton() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
        let btnback = UIButton.init(type: UIButton.ButtonType.custom)
        
        btnback.isHighlighted = false
        btnback.adjustsImageWhenHighlighted = false
        btnback.isUserInteractionEnabled = true
        btnback.setImage(Asset.btnBack.image, for: UIControl.State.normal)
        btnback.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15)
        btnback.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btnback.addTarget(self, action: "func_btnbackclick", for: UIControl.Event.touchUpInside)
        btnback.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        
        let btnphoto = UIButton.init(type: UIButton.ButtonType.custom)
        btnphoto.isUserInteractionEnabled = true
        btnphoto.adjustsImageWhenHighlighted = false
        btnphoto.addTarget(self, action: "func_btnphotoclick", for: UIControl.Event.touchUpInside)
        btnphoto.frame = CGRect.init(x: 0, y: 0, width: 70.scale, height: 45)
        
        let btnBackItem = UIBarButtonItem.init(customView: btnback)
        let btnPhotoItem = UIBarButtonItem.init(customView: btnphoto)
        self.navigationItem.leftBarButtonItems = [btnBackItem, btnPhotoItem]
    }
    private func func_addcallbutton() {
        self.navigationItem.rightBarButtonItem = nil
        // 不在线或者角色不是用户的时候
        if self.modelUser?.is_online == false || ZSettingKit.shared.role != .user {
            return
        }
        let item = UIButton.init(type: UIButton.ButtonType.custom)
        
        item.isHighlighted = false
        item.adjustsImageWhenHighlighted = false
        item.isUserInteractionEnabled = true
        let itemimage = UIImageView.init(frame: CGRect.init(0, 45/2 - 35.scale/2, 99.scale, 35.scale))
        itemimage.backgroundColor = "#7037E9".color
        itemimage.border(color: .clear, radius: 35.scale/2, width: 0)
        let itemicon = UIImageView.init(frame: CGRect.init(17.scale, 11.scale, 15.scale, 13.scale))
        itemicon.image = Asset.btnCallNow.image
        let itemlb = UILabel.init(frame: CGRect.init(36.scale, 5.scale, 60.scale, 25.scale))
        itemlb.textColor = "#FFFFFF".color
        itemlb.boldSize = 12
        itemlb.text = ZString.btnCallNow.text
        itemimage.addSubview(itemicon)
        itemimage.addSubview(itemlb)
        item.addSubview(itemimage)
        item.addTarget(self, action: "func_btncallclick", for: UIControl.Event.touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 99.scale, height: 45)
        
        let btnBackItem = UIBarButtonItem.init(customView: item)
        self.navigationItem.rightBarButtonItem = btnBackItem
    }
    @objc private func func_btnphotoclick() {
        guard let user = self.modelUser else { return }
        switch user.role {
        case .anchor:
            NotificationCenter.default.post(name: Notification.Names.ShowUserDetailVC, object: user)
        default: break
        }
    }
    @objc private func func_btncallclick() {
        AudioRecordManager.sharedInstance.cancelRrcord()
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.z_viewmodel.func_callanchor(model: self.modelUser)
    }
    @objc private func func_btnbackclick() {
        ZRouterKit.pop(fromVC: self)
    }
    private func func_setupviewui() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.modalPresentationStyle = .fullScreen
        self.extendedLayoutIncludesOpaqueBars = false
        self.view.isUserInteractionEnabled = true
        
        self.messageInputBar.backgroundView.backgroundColor = self.inputBarBGColor
        self.messageInputBar.bottomStackView.backgroundColor = self.inputBarBGColor
        self.messageInputBar.inputTextView.backgroundColor = self.inputViewBGColor
        self.messageInputBar.inputTextView.border(color: UIColor.clear, radius: 10, width: 0)
        self.messageInputBar.inputTextView.placeholderLabel.textColor = self.inputPlaceholderColor
        self.messageInputBar.inputTextView.placeholder = ZString.inputMessagePlaceholder.text
        self.messageInputBar.inputTextView.textColor = self.inputTextColor
        self.messageInputBar.inputTextView.returnKeyType = UIReturnKeyType.send
        self.messageInputBar.inputTextView.delegate = self
        self.messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: false)
        self.messageInputBar.setStackViewItems([self.z_btnAudioN, self.z_btnAlbum], forStack: InputStackView.Position.left, animated: false)
        if ZReload.shared.is_chat_gift {
            self.messageInputBar.setRightStackViewWidthConstant(to: 45, animated: false)
            self.messageInputBar.setStackViewItems([self.z_btnGift], forStack: InputStackView.Position.right, animated: false)
        } else {
            self.messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
            self.messageInputBar.setStackViewItems([], forStack: InputStackView.Position.right, animated: false)
        }
        self.messagesCollectionView.backgroundColor = "#100D13".color
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messageCellDelegate = self
        
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        
        self.scrollsToBottomOnKeyboardBeginsEditing = true
        self.maintainPositionOnKeyboardFrameChanged = true
        
        self.view.addSubview(self.z_viewhead)
        
        self.z_viewhead.addSubview(self.z_imagephoto)
        self.z_viewhead.addSubview(self.z_imageonline)
        self.z_viewhead.addSubview(self.z_lbusername)
        
        self.view.addSubview(self.z_viewcoinstips)
        
        self.z_viewcoinstips.addSubview(self.z_imagecoinstips)
        self.z_viewcoinstips.addSubview(self.z_lbcoinstips)
        
        self.view.addSubview(self.z_viewrecordaudio)
        self.view.bringSubviewToFront(self.messagesCollectionView)
        self.view.bringSubviewToFront(self.z_viewhead)
        self.view.bringSubviewToFront(self.z_viewcoinstips)
        self.view.bringSubviewToFront(self.z_viewrecordaudio)
        
        AudioRecordInstance.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(func_receivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(func_userBalanceChange(_:)), name: Notification.Names.UserBalanceChange, object: nil)
    }
    deinit {
        self.z_viewmodel.delegate = nil
        AudioRecordInstance.delegate = nil
        self.messageInputBar.inputTextView.delegate = nil
        
        self.messagesCollectionView.messagesDataSource = nil
        self.messagesCollectionView.messageCellDelegate = nil
        
        self.messagesCollectionView.messagesLayoutDelegate = nil
        self.messagesCollectionView.messagesDisplayDelegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.UserBalanceChange, object: nil)
    }
    @objc private func func_userBalanceChange(_ sender: Notification) {
        self.z_viewgifts.z_coins = ZSettingKit.shared.balance
    }
    @objc private func func_receivedNewMessage(_ sender: Notification) {
        guard let model = sender.object as? ZModelMessage else { return }
        if model.message_userid == self.modelUser?.userid {
            let nickname = model.message_user?.nickname ?? ""
            let avatar = model.message_user?.avatar ?? ""
            let gender = model.message_user?.gender ?? .male
            let role = model.message_user?.role ?? .user
            let sendtime = model.message_time
            let messageid = model.message_id
            let mediaid = model.message_file_id
            let messagefilepath = model.message_file_path
            let sender = ZModelMessageKitUser.init(senderId: model.message_userid, displayName: nickname, head: avatar, role: gender.rawValue, gender: role.rawValue)
            switch model.message_type {
            case .text:
                let message = ZModelMessageKit.init(text: model.message, sender: sender, receive: ZChatSDKKit.shared.loginUser, messageId: messageid, sentDate: Date.init(timeIntervalSince1970: sendtime))
                self.insertMessage(message)
            case .image:
                let image = UIImage.init(contentsOfFile: messagefilepath) ?? Asset.defaultImage.image
                let imageUrl = URL.init(fileURLWithPath: messagefilepath)
                let message = ZModelMessageKit.init(image: image, imageUrl: imageUrl, sender: sender, receive: ZChatSDKKit.shared.loginUser, messageId: messageid, sentDate: Date.init(timeIntervalSince1970: sendtime))
                self.insertMessage(message)
            case .audio:
                let audioUrl = URL.init(fileURLWithPath: messagefilepath)
                let message = ZModelMessageKit.init(audioURL: audioUrl, sender: sender, receive: ZChatSDKKit.shared.loginUser, messageId: messageid, sentDate: Date.init(timeIntervalSince1970: sendtime))
                self.insertMessage(message)
            case .call:
                let message = ZModelMessageKit.init(kind: .custom(["type": 2, "id": mediaid]), sender: sender, receive: ZChatSDKKit.shared.loginUser, messageId: messageid, sentDate: Date.init(timeIntervalSince1970: sendtime))
                self.insertMessage(message)
            case .gift:
                let message = ZModelMessageKit.init(kind: .custom(["type": 1, "id": mediaid]), sender: sender, receive: ZChatSDKKit.shared.loginUser, messageId: messageid, sentDate: Date.init(timeIntervalSince1970: sendtime))
                self.insertMessage(message)
            default: break
            }
        }
        ZSQLiteKit.setMessageUnRead(messageid: model.message_id)
    }
    private func func_userdetailchange() {
        guard let user = self.modelUser else { return }
        
        self.z_lbusername.text = user.nickname
        self.z_imageonline.onlineImage(online: user.is_online, busy: user.is_busy)
        self.z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
    }
    private func func_setupviewdata() {
        var time = Date().timeIntervalSince1970
        let lasttime = self.arrayMessage.first?.sentDate
        if lasttime == nil {
            self.arrayMessage.removeAll()
        } else {
            time = lasttime!.timeIntervalSince1970
        }
        var models: [ZModelMessage]?
        let receiveId = (self.modelUser?.userid ?? "")
        ZSQLiteKit.getArrayMessage(models: &models, userid: receiveId, time: time)
        if models?.count != 0 {
            let receiveNickname = self.modelUser?.nickname ?? ""
            let receiveHead = self.modelUser?.avatar ?? ""
            let receiveRole = self.modelUser?.role ?? .user
            let receiveGender = self.modelUser?.gender ?? .male
            let receiveUser = ZModelMessageKitUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
            let senderUser = self.loginUser
            models?.forEach({ (item) in
                let sendTime = Date(timeIntervalSince1970: item.message_time)
                switch item.message_direction {
                case .send:
                    switch item.message_type {
                    case .text:
                        let model = ZModelMessageKit.init(text: item.message, sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .image:
                        let url = ZLocalFileApi.imageFileFolder.appendingPathComponent(item.message_file_path)
                        let image = UIImage.init(contentsOfFile: url.path) ?? Asset.defaultImage.image
                        let model = ZModelMessageKit.init(image: image, imageUrl: url, sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .audio:
                        let url = ZLocalFileApi.wavRecordFolder.appendingPathComponent(item.message_file_path)
                        let model = ZModelMessageKit.init(audioURL: url, sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .call:
                        let model = ZModelMessageKit.init(kind: .custom(["type": 2, "id": item.message_file_id]), sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .gift:
                        let model = ZModelMessageKit.init(kind: .custom(["type": 1, "id": item.message_file_id]), sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    default: break
                    }
                case .receive:
                    switch item.message_type {
                    case .text:
                        let model = ZModelMessageKit.init(text: item.message, sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .image:
                        let url = ZLocalFileApi.imageFileFolder.appendingPathComponent(item.message_file_path)
                        let image = UIImage.init(contentsOfFile: url.path) ?? Asset.defaultImage.image
                        let model = ZModelMessageKit.init(image: image, imageUrl: url, sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .audio:
                        let url = ZLocalFileApi.wavRecordFolder.appendingPathComponent(item.message_file_path)
                        let model = ZModelMessageKit.init(audioURL: url, sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .call:
                        let model = ZModelMessageKit.init(kind: .custom(["type": 2, "id": item.message_file_id]), sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    case .gift:
                        let model = ZModelMessageKit.init(kind: .custom(["type": 1, "id": item.message_file_id]), sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                        self.arrayMessage.insert(model, at: 0)
                    default: break
                    }
                default: break
                }
            })
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.es.stopPullToRefresh(ignoreFooter: true)
        if lasttime == nil {
            self.messagesCollectionView.scrollToBottom()
        } else {
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    private func func_setupviewevent() {
        self.z_viewgifts.z_ongiftitemclick = { model in
            guard let gift = model else { return }
            self.startSendGift(gift)
        }
        self.messagesCollectionView.es.addPullToRefresh { [unowned self] in
            self.func_setupviewdata()
        }
        /// 停止录音处理，可能是被动打断
        self.z_btnAudioPress.addTarget(self, action: #selector(func_btnAudioPressStopEvent(_:)), for: UIControl.Event.touchUpInside)
        /// 移出去表示取消语音
        self.z_btnAudioPress.addTarget(self, action: #selector(func_btnAudioPressCancelEvent(_:)), for: UIControl.Event.touchUpOutside)
        /// 按下去开始说话
        self.z_btnAudioPress.addTarget(self, action: #selector(func_btnAudioPressStartEvent(_:)), for: UIControl.Event.touchDown)
        /// 移动到内部 - 手指上滑，取消发送
        self.z_btnAudioPress.addTarget(self, action: #selector(func_btnAudioPressEnterEvent(_:)), for: UIControl.Event.touchDragEnter)
        /// 移动到外部 - 松开手指，取消发送
        self.z_btnAudioPress.addTarget(self, action: #selector(func_btnAudioPressExitEvent(_:)), for: UIControl.Event.touchDragExit)
        self.z_btnAudioN.addTarget(self, action: "func_btnaudionomarlclick", for: .touchUpInside)
        self.z_btnAudioS.addTarget(self, action: "func_btnaudioselectclick", for: .touchUpInside)
        self.z_btnAlbum.addTarget(self, action: "func_btnalbumclick", for: .touchUpInside)
        self.z_btnGift.addTarget(self, action: "func_btngiftclick", for: .touchUpInside)
    }
    @objc private func func_btnAudioPressStopEvent(_ sender: ZMessageButton) {
        BFLog.debug("stop record audio")
        AudioRecordManager.sharedInstance.stopRecord()
    }
    @objc private func func_btnAudioPressCancelEvent(_ sender: ZMessageButton) {
        BFLog.debug("cancel record audio")
        AudioRecordManager.sharedInstance.cancelRrcord()
    }
    @objc private func func_btnAudioPressStartEvent(_ sender: ZMessageButton) {
        AudioRecordInstance.checkPermissionAndSetupRecord()
        BFLog.debug("start record audio")
        self.z_viewrecordaudio.startRecord()
        AudioRecordManager.sharedInstance.startRecord()
    }
    @objc private func func_btnAudioPressEnterEvent(_ sender: ZMessageButton) {
        BFLog.debug("enter record audio")
        self.z_viewrecordaudio.recording()
    }
    @objc private func func_btnAudioPressExitEvent(_ sender: ZMessageButton) {
        BFLog.debug("exit record audio")
        self.z_viewrecordaudio.slideToCancelRecord()
    }
    @objc private func func_btnaudionomarlclick() {
        self.func_dismisgiftview()
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.messageInputBar.setLeftStackViewWidthConstant(to: 45, animated: false)
        self.messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
        self.messageInputBar.setStackViewItems([self.z_btnAudioS], forStack: InputStackView.Position.left, animated: false)
        self.messageInputBar.setMiddleContentView(self.z_btnAudioPress, animated: false)
        self.messageInputBar.setStackViewItems([], forStack: InputStackView.Position.right, animated: false)
    }
    @objc private func func_btnaudioselectclick() {
        AudioRecordManager.sharedInstance.cancelRrcord()
        self.messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: false)
        self.messageInputBar.setStackViewItems([self.z_btnAudioN, self.z_btnAlbum], forStack: InputStackView.Position.left, animated: false)
        self.messageInputBar.setMiddleContentView(self.messageInputBar.inputTextView, animated: false)
        if ZReload.shared.is_chat_gift {
            self.messageInputBar.setRightStackViewWidthConstant(to: 45, animated: false)
            self.messageInputBar.setStackViewItems([self.z_btnGift], forStack: InputStackView.Position.right, animated: false)
        } else {
            self.messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
            self.messageInputBar.setStackViewItems([], forStack: InputStackView.Position.right, animated: false)
        }
    }
    @objc private func func_btnalbumclick() {
        self.func_showactionsheetview()
    }
    @objc private func func_btngiftclick() {
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.z_btnGift.isSelected = !self.z_btnGift.isSelected
        if self.z_btnGift.isSelected {
            self.messageInputBar.setStackViewItems([self.z_viewgifts], forStack: .bottom, animated: true)
            self.messageInputBar.setBottomStackViewHeightConstant(to: 295.scale, animated: true)
        } else {
            self.messageInputBar.setStackViewItems([], forStack: .bottom, animated: true)
            self.messageInputBar.setBottomStackViewHeightConstant(to: 0, animated: true)
        }
        if self.isLastSectionVisible() == true {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    private func func_dismisgiftview() {
        self.z_btnGift.isSelected = false
        self.messageInputBar.setStackViewItems([], forStack: .bottom, animated: false)
        self.messageInputBar.setBottomStackViewHeightConstant(to: 0, animated: false)
    }
    /// 发送礼物
    final func startSendGift(_ model: ZModelGift) {
        if ZSettingKit.shared.balance < Double(ZReload.shared.message_price) {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
            return
        }
        /// 创建消息对象
        let messageid = kRandomId
        let sendTime = Date()
        let modelMsg = ZModelMessage.init()
        if let user = self.modelUser {
            modelMsg.message_userid = user.userid
            modelMsg.message_user = ZModelUserBase.init(instance: user)
        }
        modelMsg.message_file_id = model.id.str
        modelMsg.message_id = messageid
        modelMsg.message = ZString.lbGivea.text
        modelMsg.message_type = .gift
        modelMsg.message_time = sendTime.timeIntervalSince1970
        modelMsg.message_read_state = true
        
        ZChatSDKKit.shared.sendMessageToService(modelMsg, need_notify: 1, giftid: model.id)
        self.z_viewcoinstips.isHidden = true
        
        let receiveId = self.modelUser?.userid ?? ""
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role ?? .user
        let receiveGender = self.modelUser?.gender ?? .female
        let receiveUser = ZModelMessageKitUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
        let senderUser = self.loginUser
        let message = ZModelMessageKit.init(kind: .custom(["type": 1, "id": model.id.str]), sender: senderUser, receive: receiveUser, messageId: messageid, sentDate: sendTime)
        self.insertMessage(message)
    }
    /// 发送语音
    final func startSendAudio(_ uploadAmrData: Data, _ recordTime: Float, _ filepath: URL) {
        BFLog.debug("start send audio fileUrl: \(filepath.path)")
        if ZSettingKit.shared.balance < Double(ZReload.shared.message_price) {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
            return
        }
        /// 创建消息对象
        let sendDate = Date()
        let model = ZModelMessage()
        if let user = self.modelUser {
            model.message_userid = user.userid
            model.message_user = ZModelUserBase.init(instance: user)
        }
        model.message = ZString.messageisaAudio.text
        model.message_type = .audio
        model.message_file_path = filepath.lastPathComponent
        model.message_file_size = Double(recordTime)
        model.message_id = kRandomId
        model.message_direction = .send
        model.message_time = sendDate.timeIntervalSince1970
        model.message_read_state = true
        
        ZChatUploadKit.uploadFile(filepath, model)
        self.z_viewcoinstips.isHidden = true
        
        let receiveId = (self.modelUser?.userid ?? "0")
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role ?? .user
        let receiveGender = self.modelUser?.gender ?? .male
        let receiveUser = ZModelMessageKitUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
        let message = ZModelMessageKit.init(audioURL: filepath, sender: self.loginUser, receive: receiveUser, messageId: model.message_id, sentDate: sendDate)
        self.insertMessage(message)
    }
    /// 发送图片
    private func startSendImages(_ images: [UIImage]) {
        if ZSettingKit.shared.balance < Double(ZReload.shared.message_price) {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
            return
        }
        guard let image = images.first else {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        let imageUrl = ZLocalFileApi.imageFileFolder
        ZLocalFileApi.saveImage(image: image, toPath: imageUrl)
        BFLog.debug("start send image images: \(images.count)")
        /// 创建消息对象
        let sendDate = Date()
        let model = ZModelMessage()
        if let user = self.modelUser {
            model.message_userid = user.userid
            model.message_user = ZModelUserBase.init(instance: user)
        }
        model.message = ZString.messageisaPhoto.text
        model.message_type = .image
        model.message_file_path = imageUrl.lastPathComponent
        model.message_id = kRandomId
        model.message_direction = .send
        model.message_time = sendDate.timeIntervalSince1970
        model.message_read_state = true
        
        ZChatUploadKit.uploadImage(imageUrl, model)
        self.z_viewcoinstips.isHidden = true
        
        let receiveId = (self.modelUser?.userid ?? "0")
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role ?? .user
        let receiveGender = self.modelUser?.gender ?? .male
        let receiveUser = ZModelMessageKitUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
        let message = ZModelMessageKit.init(image: image, imageUrl: imageUrl, sender: self.loginUser, receive: receiveUser, messageId: model.message_id, sentDate: sendDate)
        self.insertMessage(message)
    }
    /// 发送文本
    private final func startSendMessage(_ text: String) {
        BFLog.debug("start send message text: \(text)")
        // 文本内容不能为空
        guard text.length > 0 && text.length <= kMaxMessage else {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        if ZSettingKit.shared.balance < Double(ZReload.shared.message_price) {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
            return
        }
        /// 创建消息对象
        let sendTime = Date()
        let messageid = kRandomId
        let model = ZModelMessage.init()
        if let user = self.modelUser {
            model.message_userid = user.userid
            model.message_user = ZModelUserBase.init(instance: user)
        }
        model.message_id = messageid
        model.message = text
        model.message_type = .text
        model.message_time = sendTime.timeIntervalSince1970
        model.message_read_state = true
        
        ZChatSDKKit.shared.sendMessageToService(model, need_notify: 1)
        self.z_viewcoinstips.isHidden = true
        
        let receiveId = self.modelUser?.userid ?? ""
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role ?? .user
        let receiveGender = self.modelUser?.gender ?? .female
        let receiveUser = ZModelMessageKitUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
        let senderUser = self.loginUser
        
        let message = ZModelMessageKit.init(text: text, sender: senderUser, receive: receiveUser, messageId: messageid, sentDate: sendTime)
        self.insertMessage(message)
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
    }
    /// 添加一条消息
    private func insertMessage(_ message: ZModelMessageKit) {
        self.arrayMessage.append(message)
        self.messagesCollectionView.performBatchUpdates({
            self.messagesCollectionView.insertSections([self.arrayMessage.count - 1])
            if self.arrayMessage.count >= 2 {
                self.messagesCollectionView.reloadSections([self.arrayMessage.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    /// 处理滑动动画
    final func isLastSectionVisible() -> Bool {
        guard !self.arrayMessage.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: self.arrayMessage.count - 1)
        return self.messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    private func func_showcamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let z_tempvc = ZImageSelectViewController()
            
            z_tempvc.delegate = self
            z_tempvc.allowsEditing = false
            z_tempvc.modalPresentationStyle = .fullScreen
            z_tempvc.sourceType = UIImagePickerController.SourceType.camera
            
            ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
        } else {
            ZProgressHUD.showMessage(vc: self, text: ZString.errorDeviceNotCameraPrompt.text, position: .center)
        }
    }
    private func func_showalbum() {
        let z_tempvc = ZImageSelectViewController()
        
        z_tempvc.delegate = self
        z_tempvc.allowsEditing = false
        z_tempvc.modalPresentationStyle = .fullScreen
        z_tempvc.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
    }
    private func func_showactionsheetview() {
        self.messageInputBar.inputTextView.resignFirstResponder()
        ZAlertView.showActionSheetView(vc: self, message: ZString.lbSelectPhoto.text, buttons: [ZString.btnAlbum.text, ZString.btnCamera.text], completeBlock: { row in
            switch row {
            case 0: self.func_showalbum()
            case 1: self.func_showcamera()
            default: break
            }
        })
    }
}
/// 文本输入框
extension ZMessageViewController: InputBarAccessoryViewDelegate, UITextViewDelegate {
    
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        BFLog.debug("didPressSendButtonWith: \(text)")
        
        let attributedText = self.messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            BFLog.info("Autocompleted: \(substring)  with context: \(context ?? [])")
        }
        let components = inputBar.inputTextView.components
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
        DispatchQueue.main.async { [weak self] in
            self?.insertMessages(components)
        }
    }
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                self.startSendMessage(str)
            }
        }
    }
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
        if textLength > kMaxMessage { return false }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.func_dismisgiftview()
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.length > kMaxMessage {
            let text = textView.text ?? ""
            textView.text = String(text[..<text.index(text.startIndex, offsetBy: kMaxMessage)])
        }
    }
}
extension ZMessageViewController: ZMessageViewModelDelegate {
    func func_requestdetailsuccess(model: ZModelUserInfo) {
        self.modelUser = model.copyable()
        self.func_userdetailchange()
        self.func_addcallbutton()
        self.z_viewcoinstips.isHidden = (model.role == .customerService || ZSettingKit.shared.role == .customerService)
        
        ZSQLiteKit.setModel(model: model)
    }
    func func_requestgiftarray(models: [ZModelGift]?) {
        self.z_viewgifts.z_array = models
    }
}
extension ZMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.startSendImages([image])
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
    }
}
