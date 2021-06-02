
import UIKit
import AVKit
import BFKit
import SwiftBasicKit

class ZCallViewController: ZBaseViewController {
    
    /// 呼叫事件
    var modelIMCall: ZModelIMCall? {
        didSet {
            func_reloaddata()
        }
    }
    /// 视频通话id
    private var z_callid: Int = 0
    private var z_currenttime: TimeInterval = kMaxCallWaitTime
    private let z_buttonFrame: CGRect = CGRect.init(kScreenWidth/2 - 77/2, kScreenHeight - 96 - 77, 77, 77)
    private lazy var z_viewmain: UIView = {
        let z_temp = UIView.init(frame: CGRect.main())
        z_temp.backgroundColor = "#000000".color
        return z_temp
    }()
    private lazy var z_imagephoto: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2 - 158/2, kStatusHeight + 148, 158, 158))
        z_temp.image = Asset.defaultAvatar.image
        z_temp.border(color: "#7037E9".color, radius: 158/2, width: 4)
        return z_temp
    }()
    private lazy var z_viewtime: ZTimeCountdownView = {
        let z_temp = ZTimeCountdownView.init(frame: CGRect.init(kScreenWidth - 60.scale, kStatusHeight + 30, 55.scale, 55.scale))
        z_temp.z_maxtime = kMaxCallWaitTime
        return z_temp
    }()
    private lazy var z_lbusername: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(kScreenWidth/2, z_imagephoto.y + z_imagephoto.height + 10, 10, 30))
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 18
        return z_temp
    }()
    private lazy var z_imagegender: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(kScreenWidth/2, z_lbusername.y + 4, 22, 22))
        return z_temp
    }()
    private lazy var z_lbcalling: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(0, z_lbusername.y + z_lbusername.height + 5, kScreenWidth, 25))
        z_temp.textColor = "#535354".color
        z_temp.boldSize = 14
        z_temp.textAlignment = .center
        z_temp.text = ZString.lbCalling.text
        return z_temp
    }()
    private lazy var z_lbcalldesc: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(kScreenWidth/2 - 100, z_lbcalling.y + z_lbcalling.height + 35, 200, 20))
        z_temp.textColor = "#FFFFFF".color.withAlphaComponent(0.3)
        z_temp.boldSize = 12
        z_temp.textAlignment = .center
        z_temp.text = ZString.callRandomDesc.text
        z_temp.numberOfLines = 0
        z_temp.height = z_temp.text!.getHeight(z_temp.font, width: z_temp.width)
        return z_temp
    }()
    private lazy var z_btnhangup: UIButton = {
        let z_temp = UIButton.init(frame: z_buttonFrame)
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.callHangup.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnanswer: UIButton = {
        let z_temp = UIButton.init(frame: z_buttonFrame)
        z_temp.isHidden = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.callAnswer.image, for: .normal)
        return z_temp
    }()
    private lazy var z_btnsee: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(kScreenWidth - 25 - 45, kScreenHeight - 40 - 45, 45, 45))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnSeeN.image, for: .normal)
        z_temp.setImage(Asset.btnSeeS.image, for: .selected)
        return z_temp
    }()
    private let z_viewmodel: ZCallViewModel = ZCallViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.z_viewmodel.vc = self
        self.view.backgroundColor = .clear
        self.view.addSubview(z_viewmain)
        z_viewmain.addSubview(z_viewtime)
        z_viewmain.addSubview(z_imagephoto)
        z_viewmain.addSubview(z_lbusername)
        z_viewmain.addSubview(z_lbcalling)
        z_viewmain.addSubview(z_lbcalldesc)
        z_viewmain.addSubview(z_imagegender)
        z_viewmain.addSubview(z_btnsee)
        z_viewmain.addSubview(z_btnhangup)
        z_viewmain.addSubview(z_btnanswer)
        z_btnanswer.addTarget(self, action: "func_btnanswerclick", for: .touchUpInside)
        z_btnhangup.addTarget(self, action: "func_btnhangupclick", for: .touchUpInside)
        z_btnsee.addTarget(self, action: "func_btnseeclick", for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: "func_ExecuteTimer:", name: Notification.Names.ExecuteTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_ReceivedEventMessage:", name: Notification.Names.ReceivedEventMessage, object: nil)
        ZAudioCallKit.shared.playSound("user")
        z_viewmodel.delegate = self
        z_viewmodel.func_requestuserdetail(userid: self.modelIMCall?.other_people?.userid ?? "")
        
        ZWebSocketKit.shared.isShowMultipleView = false
        let access = ZSettingKit.shared.getUserConfig(key: "kAccessAudioKey") as? String
        if access == nil || access != "true" {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
                AVCaptureDevice.requestAccess(for: .audio, completionHandler: { [weak self] (statusFirst) in
                    ZSettingKit.shared.setUserConfig(key: "kAccessAudioKey", value: "true")
                    BFLog.debug("statusFirst: \(String(statusFirst))")
                })
            })
            DispatchQueue.global().asyncAfter(deadline: .now() + 4, execute: {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                    BFLog.debug("statusFirst: \(String(statusFirst))")
                })
            })
        }
    }
    deinit {
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ExecuteTimer, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedEventMessage, object: nil)
    }
    private func func_reloaddata() {
        guard let model = self.modelIMCall else { return }
        switch model.direction {
        case 1:
            z_btnhangup.x = 65.scale
            z_btnanswer.x = 233.scale
            z_btnanswer.isHidden = false
            z_btnhangup.isHidden = false
        default:
            z_btnanswer.x = kScreenWidth/2 - z_btnanswer.width/2
            z_btnhangup.x = kScreenWidth/2 - z_btnhangup.width/2
            z_btnanswer.isHidden = true
            z_btnhangup.isHidden = false
        }
        z_callid = model.call_id
        guard let user = model.other_people else { return }
        z_imagegender.image = user.gender == .male ? Asset.iconMale.image : Asset.iconFemale.image
        z_lbusername.text = user.nickname + (user.age >= kMinAge ? ("," + user.age.str) : "")
        z_imagephoto.setImageWitUrl(strUrl: user.avatar, placeholder: Asset.defaultAvatar.image)
        z_lbusername.width = z_lbusername.text!.getWidth(z_lbusername.font, height: z_lbusername.height)
        z_lbusername.x = kScreenWidth/2 - z_lbusername.width/2 - 10
        z_imagegender.x = z_lbusername.x + z_lbusername.width + 8
    }
    @objc private func func_ReceivedEventMessage(_ sender: Notification) {
        guard let event = sender.object as? ZModelIMEvent else { return }
        switch event.event_code {
        case .response:
            if self.z_callid == event.call_id {
                self.z_btnhangup.isEnabled = false
                self.z_btnanswer.isEnabled = false
                self.z_btnsee.isEnabled = false
                ZAudioCallKit.shared.stopSound()
                ZAudioCallKit.shared.startOtherPlayer()
                guard let model = sender.object as? ZModelIMAnswer else {
                    self.func_dismissvc()
                    return
                }
                model.issee = self.z_btnsee.isSelected
                let z_tempvc = ZVideoViewController.init()
                z_tempvc.modelAnswer = model.copyable()
                z_tempvc.showType = 2
                ZRouterKit.dismiss(fromVC: self, animated: false, completion: {
                    ZObserverKit.shared.isShowingCallVC = false
                    DispatchQueue.DispatchAfter(after: 0.25, handler: {
                        ZObserverKit.shared.isShowingVideoVC = true
                        ZRouterKit.present(toVC: z_tempvc, animated: false)
                    })
                })
            }
        case .hangup:
            if self.z_callid == event.call_id {
                self.z_btnhangup.isEnabled = false
                self.z_btnanswer.isEnabled = false
                self.z_btnsee.isEnabled = false
                ZAudioCallKit.shared.stopSound()
                ZAudioCallKit.shared.startOtherPlayer()
                self.func_dismissvc()
            }
        default: break
        }
    }
    @objc private func func_ExecuteTimer(_ sender: Notification) {
        if self.z_currenttime <= 0 {
            self.z_btnhangup.isEnabled = false
            self.z_btnanswer.isEnabled = false
            self.z_btnsee.isEnabled = false
            ZAudioCallKit.shared.stopSound()
            ZAudioCallKit.shared.systemCancel()
            ZAudioCallKit.shared.startOtherPlayer()
            ZVideoSDKKit.shared.callOperate = .hangup
            ZVideoSDKKit.shared.callOperateid = self.z_callid
            ZCallViewModel.func_sendhangup(model: self.modelIMCall)
            ZObserverKit.shared.isShowingCallVC = false
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: {
                var obj = [String: Any]()
                obj["type"] = "Recommend"
                NotificationCenter.default.post(name: Notification.Names.ShowVideoEndVC, object: obj)
            })
            ZWebSocketKit.shared.isShowMultipleView = true
            return
        }
        if self.z_currenttime < 30 && self.z_btnanswer.isHidden {
            z_lbcalldesc.text = ZString.callWaitDesc.text
            z_lbcalldesc.height = z_lbcalldesc.text!.getHeight(z_lbcalldesc.font, width: z_lbcalldesc.width)
        }
        self.z_currenttime -= 1
        z_viewtime.func_settime(time: z_currenttime)
    }
    @objc private func func_btnanswerclick() {
        self.z_btnhangup.isEnabled = false
        self.z_btnanswer.isEnabled = false
        self.z_btnsee.isEnabled = false
        ZAudioCallKit.shared.stopSound()
        ZAudioCallKit.shared.systemAnswer()
        ZAudioCallKit.shared.startOtherPlayer()
        ZVideoSDKKit.shared.callOperate = .answer
        ZVideoSDKKit.shared.callOperateid = self.z_callid
        
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi*2
        rotationAnimation.duration = 0.25
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 1
        self.z_btnanswer.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        UIView.animate(withDuration: 0.25, animations: {
            self.z_btnhangup.alpha = 0
            self.z_btnanswer.x = kScreenWidth/2 - self.z_btnanswer.width/2
        }, completion: { (completed) in
            ZCallViewModel.func_sendanswer(model: self.modelIMCall, issee: self.z_btnsee.isSelected)
            self.func_dismissvc()
        })
    }
    @objc private func func_btnhangupclick() {
        self.z_btnhangup.isEnabled = false
        self.z_btnanswer.isEnabled = false
        self.z_btnsee.isEnabled = false
        ZAudioCallKit.shared.stopSound()
        ZAudioCallKit.shared.systemCancel()
        ZAudioCallKit.shared.startOtherPlayer()
        ZVideoSDKKit.shared.callOperate = .hangup
        ZVideoSDKKit.shared.callOperateid = self.z_callid
        ZCallViewModel.func_sendhangup(model: self.modelIMCall)
        self.func_dismissvc()
    }
    @objc private func func_btnseeclick() {
        self.z_btnsee.isSelected = !self.z_btnsee.isSelected
    }
    private func func_dismissvc() {
        ZObserverKit.shared.isShowingCallVC = false
        ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        ZWebSocketKit.shared.isShowMultipleView = true
    }
}
extension ZCallViewController: ZCallViewModelDelegate {
    
    func func_requestdetailsuccess(model: ZModelUserInfo) {
        
        self.modelIMCall?.other_people = model.copyable()
        
        z_imagegender.image = model.gender == .male ? Asset.iconMale.image : Asset.iconFemale.image
        z_lbusername.text = model.nickname + (model.age >= kMinAge ? ("," + model.age.str) : "")
        z_imagephoto.setImageWitUrl(strUrl: model.avatar, placeholder: Asset.defaultAvatar.image)
        z_lbusername.width = z_lbusername.text!.getWidth(z_lbusername.font, height: z_lbusername.height)
        z_lbusername.x = kScreenWidth/2 - z_lbusername.width/2 - 10
        z_imagegender.x = z_lbusername.x + z_lbusername.width + 8
    }
}
