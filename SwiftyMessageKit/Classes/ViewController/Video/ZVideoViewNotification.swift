
import UIKit
import SwiftBasicKit

extension ZVideoViewController {
    final func func_addNotification() {
        NotificationCenter.default.addObserver(self, selector: "func_JoinedChannel:", name: ZVideoSDKKit.Names.JoinedChannel, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_JoinedChannelError:", name: ZVideoSDKKit.Names.JoinedChannelError, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_FirstRemoteVideo:", name: ZVideoSDKKit.Names.FirstRemoteVideo, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_RejoinChannel:", name: ZVideoSDKKit.Names.RejoinChannel, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_RemoteOffline:", name: ZVideoSDKKit.Names.RemoteOffline, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_RemoteJoinedChannel:", name: ZVideoSDKKit.Names.RemoteJoinedChannel, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_RemoteLeaveChannel:", name: ZVideoSDKKit.Names.RemoteLeaveChannel, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_ExecuteTimer:", name: Notification.Names.ExecuteTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_ReceivedNewMessage:", name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: "func_ReceivedEventMessage:", name: Notification.Names.ReceivedEventMessage, object: nil)
    }
    final func func_removeNotification() {
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.JoinedChannel, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.JoinedChannelError, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.FirstRemoteVideo, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.RejoinChannel, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.RemoteOffline, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.RemoteJoinedChannel, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZVideoSDKKit.Names.RemoteLeaveChannel, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ExecuteTimer, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedEventMessage, object: nil)
    }
    /// 自己加入视频
    @objc private func func_JoinedChannel(_ sender: Notification) {
        self.z_viewai.stopAnimating()
        self.z_viewcontent.setContentOffset(CGPoint.init(x: self.z_viewcontent.width, y: 0), animated: true)
        self.z_videosdk.setupRemoteVideo(self.z_viewvideomax, userid: self.z_userid)
        self.z_videosdk.setupLocalVideo(self.z_viewvideomin, userid: ZSettingKit.shared.userId)
    }
    /// 加入视频错误
    @objc private func func_JoinedChannelError(_ sender: Notification) {
        self.z_viewai.stopAnimating()
        guard let errocde = sender.object as? Int else { return }
        ZAlertView.showAlertView(vc: self, message: ZString.errorJoinCannel.text + errocde.str, completeBlock: {
            self.func_dismissvc()
        })
    }
    /// 收到远端第一帧
    @objc private func func_FirstRemoteVideo(_ sender: Notification) {
        self.z_viewai.stopAnimating()
        self.z_videosdk.setupRemoteVideo(self.z_viewvideomax, userid: self.z_userid)
        self.z_videosdk.setupLocalVideo(self.z_viewvideomin, userid: ZSettingKit.shared.userId)
    }
    /// 自己重新加入视频
    @objc private func func_RejoinChannel(_ sender: Notification) {
        self.z_viewai.stopAnimating()
        self.z_videosdk.setupRemoteVideo(self.z_viewvideomax, userid: self.z_userid)
        self.z_videosdk.setupLocalVideo(self.z_viewvideomin, userid: ZSettingKit.shared.userId)
    }
    /// 远端离线
    @objc private func func_RemoteOffline(_ sender: Notification) {
        self.func_dismissvc()
    }
    /// 远端加入视频
    @objc private func func_RemoteJoinedChannel(_ sender: Notification) {
        self.z_viewai.stopAnimating()
        self.z_videosdk.setupRemoteVideo(self.z_viewvideomax, userid: self.z_userid)
        self.z_videosdk.setupLocalVideo(self.z_viewvideomin, userid: ZSettingKit.shared.userId)
    }
    /// 远端离开视频
    @objc private func func_RemoteLeaveChannel(_ sender: Notification) {
        self.func_dismissvc()
    }
    /// 每秒即时回调
    @objc private func func_ExecuteTimer(_ sender: Notification) {
        self.currenttime += 1
        self.z_viewhead.z_time = self.currenttime
        // 检测状态
        if self.currenttime % self.checkstatustime == 0 { self.z_viewmodel.func_checkcallstatus(callid: self.z_callid) }
        // 设置礼物的倒计时
        if self.z_viewgivegiftsmall.alpha != 0 { self.z_viewgivegiftsmall.setDismissGiftImageView() }
        // 设置索要礼物倒计时
        if self.z_viewgivegifttips.alpha != 0 { self.z_viewgivegifttips.setDismissGiveGiftView() }
        // 隐藏充值提示视图
        if self.dismissbottomtime == 6 {
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewrechargetips.y = kScreenHeight
            })
        }
        // 显示关注按钮 - 3分钟
        let isfollowing = self.modeluser?.is_following ?? false
        if !isfollowing && self.currenttime == 90 {
            self.z_viewfollow.alpha = 0
            self.z_viewfollow.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.z_viewfollow.alpha = 1
                self.z_viewfollow.y = self.z_viewinputbar.y - 35.scale
            })
        }
        self.dismissbottomtime += 1
    }
    /// 收到消息
    @objc private func func_ReceivedNewMessage(_ sender: Notification) {
        guard let model = sender.object as? ZModelMessage else { return }
        switch model.message_type {
        case .text:
            self.z_viewmessages.addMessageModel(model)
            ZSQLiteKit.setMessageUnRead(messageid: model.message_id)
        default: break
        }
    }
    /// 收到im事件
    @objc private func func_ReceivedEventMessage(_ sender: Notification) {
        guard let event = sender.object as? ZModelIMEvent else { return }
        switch event.event_code {
        case .hangup: self.func_dismissvc()
        case .balance:
            guard let model = sender.object as? ZModelIMBalance else { return }
            switch model.biz_code {
            case 1:
                self.z_btnCountdownRecharge.isHidden = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.z_viewrechargefristtips.y = kScreenHeight
                })
            case 2:
                self.modelBalance = model.copyable()
                if let recharge = self.modelBalance?.biz_notify_recharge {
                    if model.type == 2 && !model.hunting_finished {
                        self.view.endEditing(true)
                        self.z_btnCountdownRecharge.z_modelRecharge = recharge.copyable()
                        self.z_viewrechargefristtips.z_modelBalance = model.copyable()
                        UIView.animate(withDuration: 0.25, animations: {
                            self.dismissbottomtime = 0
                            self.z_viewrechargefristtips.y = kScreenHeight - self.z_viewrechargefristtips.height
                        })
                    } else {
                        self.view.endEditing(true)
                        self.z_btnCountdownRecharge.isHidden = true
                        self.z_viewrechargetips.z_modelBalance = model.copyable()
                        UIView.animate(withDuration: 0.25, animations: {
                            self.dismissbottomtime = 0
                            self.z_viewrechargefristtips.y = kScreenHeight
                            self.z_viewrechargetips.y = kScreenHeight - self.z_viewrechargetips.height
                        })
                    }
                }
            default: break
            }
            self.z_viewinputbar.z_viewrecharge.z_coins = Double(model.balance)
            self.z_viewinputbar.z_viewgifts.z_coins = Double(model.balance)
        case .gift:
            guard let model = sender.object as? ZModelIMGift else { return }
            self.func_showGiftAnimation(giftid: Int64(model.gift_id))
        case .cmd:
            guard let model = sender.object as? ZModelIMCMD else { return }
            guard let dic = model.content else { return }
            guard let type = dic["type"] as? String else { return }
            switch type {
            case "fuzzy": // 水印切换
                guard let isF = dic["isFuzzy"] as? String, let callid = (dic["callid"] as? Int) ?? (dic["callid"] as? String)?.intValue else {
                    return
                }
                self.isFuzzy = isF == "1"
                if callid == self.z_callid { self.z_viewwater.isHidden = !self.isFuzzy }
            case "gift": // 索要礼物
                guard let gift = dic["gift"] as? [String: Any], let callid = (dic["callid"] as? Int) ?? (dic["callid"] as? String)?.intValue else { return }
                if callid == self.z_callid, let modelgift = ZModelGift.deserialize(from: gift) {
                    self.z_viewgivegifttips.alpha = 0
                    self.z_viewgivegifttips.isHidden = false
                    self.z_viewgivegifttips.z_modelgift = modelgift
                    UIView.animate(withDuration: 0.25, animations: {
                        self.z_viewgivegifttips.alpha = 1
                    })
                }
            default: break
            }
        default: break
        }
    }
}
