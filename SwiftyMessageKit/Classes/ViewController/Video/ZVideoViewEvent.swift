
import UIKit
import SwiftBasicKit

extension ZVideoViewController {
    
    final func func_showGiftAnimation(giftid: Int64) {
        let type = kEnumGiftImage.init(rawValue: Int(giftid)) ?? .IceCream
        if giftid <= 4 {
            self.z_viewgivegiftsmall.setShowViewGiftImage(type)
        } else {
            self.view.endEditing(true)
            let viewgivegiftsvga = ZVideoGiveGiftSvgaView.init(frame: CGRect.main())
            viewgivegiftsvga.setShowViewGiftImage(type)
        }
    }
    final func func_setupviewevent() {
        self.z_viewcontent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "func_viewcontenttap:"))
        /// 关闭视频
        self.z_viewhead.z_oncloseclick = {
            self.view.endEditing(true)
            ZAlertView.showAlertView(vc: self,  message: ZString.alertLeaveCurrentVideo.text, button: ZString.btnLeave.text, cancel: ZString.btnCancel.text, completeBlock: { row in
                if row == 1 {
                    self.func_dismissvc()
                }
            })
        }
        /// 关注按钮
        self.z_viewhead.z_onfollowclick = { follow in
            self.z_viewmodel.func_followuser(userid: self.z_userid, follow: follow)
        }
        self.z_viewinputbar.z_btnsee.addTarget(self, action: "func_btnseeclick", for: .touchUpInside)
        self.z_viewinputbar.z_btnflip.addTarget(self, action: "func_btnflipclick", for: .touchUpInside)
        self.z_btnchangevideo.addTarget(self, action: "func_btnchangevideoclick", for: .touchUpInside)
        self.z_btnCountdownRecharge.addTarget(self, action: "func_btnCountdownRechargeclick", for: .touchUpInside)
        /// 第几分钟提示框点击关闭
        self.z_viewrechargetips.z_onbtncloseclick = {
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewrechargetips.y = kScreenHeight
            })
        }
        /// 第几分钟提示框点击充值
        self.z_viewrechargetips.z_onbtncontinueclick = { recharge in
            guard let model = recharge else { return }
            self.view.endEditing(true)
            self.z_viewmodel.func_requestpayrecharge(model: model, showhud: false)
        }
        /// 第一次提示框点击充值
        self.z_viewrechargefristtips.z_onbtncontinueclick = { recharge in
            guard let model = recharge else { return }
            self.view.endEditing(true)
            self.z_viewmodel.func_requestpayrecharge(model: model, showhud: false)
        }
        /// 送礼物
        self.z_viewinputbar.z_viewgifts.z_ongiftitemclick = { model in
            guard let gift = model else { return }
            if ZSettingKit.shared.balance < Double(gift.price) {
                self.z_viewinputbar.func_showrechargeview()
            } else {
                var param = [String: Any]()
                param["gift_id"] = gift.id
                param["call_id"] = self.z_callid
                let giftid = gift.id
                ZNetworkKit.created.startRequest(target: .post(ZAction.apicallgift.api, param), responseBlock: { [weak self] result in
                    guard let `self` = self else { return }
                    if result.success {
                        self.func_showGiftAnimation(giftid: giftid)
                    } else {
                        switch result.code {
                        case ZNetworkCode.balance:
                            self.z_viewinputbar.func_showrechargeview()
                        default: break
                        }
                        ZProgressHUD.showMessage(vc: self, text: result.message, position: .center)
                    }
                })
            }
        }
        /// 索要礼物
        self.z_viewgivegifttips.z_onbtngiveclick = { model in
            guard let gift = model else { return }
            if ZSettingKit.shared.balance < Double(gift.price) {
                self.z_viewinputbar.func_showrechargeview()
            } else {
                var param = [String: Any]()
                param["gift_id"] = gift.id
                param["call_id"] = self.z_callid
                let giftid = gift.id
                ZNetworkKit.created.startRequest(target: .post(ZAction.apicallgift.api, param), responseBlock: { [weak self] result in
                    guard let `self` = self else { return }
                    if result.success {
                        self.func_showGiftAnimation(giftid: giftid)
                    } else {
                        ZProgressHUD.showMessage(vc: self, text: result.message, position: .center)
                    }
                })
            }
        }
        /// 充值
        self.z_viewinputbar.z_viewrecharge.z_onrechargeitemclick = { gid, model in
            self.view.endEditing(true)
            switch gid {
            case .apa:
                self.z_viewmodel.func_requestapayrecharge(model: model, showhud: false)
            case .ppa:
                self.z_viewmodel.func_requestppayrecharge(model: model, showhud: false)
            default: break
            }
        }
        /// 关注
        self.z_viewfollow.z_onbuttonfollowclick = {
            guard let model = self.modeluser else { return }
            self.z_viewmodel.func_followuser(userid: model.userid, follow: true)
        }
    }
    /// 充值
    @objc private final func func_btnCountdownRechargeclick() {
        guard let model = self.z_btnCountdownRecharge.z_modelRecharge else { return }
        self.z_viewmodel.func_requestpayrecharge(model: model, showhud: false)
    }
    /// 内容单机事件 - 主要隐藏键盘区域
    @objc private final func func_viewcontenttap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.z_viewinputbar.z_btngift.isSelected = false
            self.z_viewinputbar.z_btnrecharge.isSelected = false
            self.view.endEditing(true)
        default: break
        }
    }
    /// 切换大小视频区域点击
    @objc private final func func_btnchangevideoclick() {
        self.ismyminvideo = !self.ismyminvideo
        if self.ismyminvideo {
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewwater.func_changeframe(vframe: self.viewminFrame)
                self.z_viewvideomin.frame = self.viewminFrame
                self.z_viewvideomax.frame = self.viewmaxFrame
                self.z_viewvideomax.border(color: .clear, radius: 0, width: 0)
                self.z_viewvideomin.border(color: .clear, radius: 10, width: 0)
            }, completion: { _ in
                self.func_viewchangebring()
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewwater.func_changeframe(vframe: self.viewmaxFrame)
                self.z_viewvideomin.frame = self.viewmaxFrame
                self.z_viewvideomax.frame = self.viewminFrame
                self.z_viewvideomax.border(color: .clear, radius: 10, width: 0)
                self.z_viewvideomin.border(color: .clear, radius: 0, width: 0)
            }, completion: { _ in
                self.func_viewchangebring()
            })
        }
    }
    /// 前后摄像头按钮点击
    @objc private final func func_btnflipclick() {
        self.z_viewinputbar.z_btnflip.isSelected = !self.z_viewinputbar.z_btnflip.isSelected
        self.z_videosdk.switchCamera()
    }
    /// 切换水印按钮点击
    @objc internal final func func_btnseeclick() {
        self.z_viewinputbar.z_btnsee.isSelected = !self.z_viewinputbar.z_btnsee.isSelected
        self.isFuzzy = !self.z_viewinputbar.z_btnsee.isSelected
        var param = [String: Any]()
        param["call_id"] = self.z_callid
        param["content"] = ["type": "fuzzy", "callid": self.z_callid, "isFuzzy": self.isFuzzy == true ? "1" : "0"]
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicallcmd.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if !result.success {
                self.z_viewinputbar.z_btnsee.isSelected = !self.z_viewinputbar.z_btnsee.isSelected
            } else {
                self.z_viewwater.isHidden = !self.isFuzzy
            }
        })
    }
}
