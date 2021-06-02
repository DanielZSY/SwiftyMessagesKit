
import UIKit
import BFKit
import AVKit
import Alamofire
import Foundation
import SwiftBasicKit

/// 监听管理
class ZObserverKit: NSObject {
    
    static let shared = ZObserverKit.init()
    
    var isShowingCallVC: Bool = false
    var isShowingVideoVC: Bool = false
    /// 网络状态 0 无网络 1 Wifi 2 数据流量
    var currentNetStatus: Int = 0
    /// 手机是否静音
    var isWhetherMute: Bool {
        return AudioControlManager.isWhetherMute()
    }
    /// 手机是否扬声器
    var isSpeakerMute: Bool {
        let audioSession = AVAudioSession.sharedInstance()
        let currentRoute = audioSession.currentRoute
        for output in currentRoute.outputs {
            if output.portType == AVAudioSession.Port.headphones {
                return true
            }
        }
        return false
    }
    /// 监听网络状态
    private var networkManager: NetworkReachabilityManager?
    
    override init() {
        super.init()
    }
    final func configObserver() {
        self.networkManager?.stopListening()
        self.networkManager = NetworkReachabilityManager.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcAppWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcAppEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcAppBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowChatMessageVC(_:)), name: Notification.Names.ShowChatMessageVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcReceivedEventMessage(_:)), name: Notification.Names.ReceivedEventMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcBindPushNotification(_:)), name: Notification.Name.init("BindPushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcAppWillTerminate), name: Notification.Name.init("AppWillTerminate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcAppConfigParam(_:)), name: Notification.Name.init("AppConfigParam"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcShowVideoEndVC(_:)), name: Notification.Names.ShowVideoEndVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.funcLoginStatusChange(_:)), name: Notification.Name.init(rawValue: "LoginStatusChange"), object: nil)
        // 添加静音监听
        KKAudioControlManager.shareInstance()?.addMuteListener()
        NotificationCenter.default.addObserver(self, selector: #selector(funcAudioControlMuteTurnOn(_:)), name: NSNotification.Name.init("KKAudioControlMuteTurnOnNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(funcAudioControlMuteTurnOff(_:)), name: NSNotification.Name.init("KKAudioControlMuteTurnOffNotification"), object: nil)
        // 监听网络状况
        self.networkManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let `self` = self else { return }
            switch status {
            case .notReachable, .unknown:
                self.currentNetStatus = 0
                BFLog.debug("notReachable || unknown")
                ZBindKit.shared.isBindSuccess = false
                ZNetworkErrorGlobalView.init().showAnimate()
            case .reachable(let type):
                switch type {
                case .cellular:
                    self.currentNetStatus = 2
                    ZWebSocketKit.shared.reconnect()
                    ZNetworkErrorGlobalView.removeAllView()
                    BFLog.debug("cellular")
                case .ethernetOrWiFi:
                    self.currentNetStatus = 1
                    ZWebSocketKit.shared.reconnect()
                    ZNetworkErrorGlobalView.removeAllView()
                    BFLog.debug("ethernetOrWiFi")
                }
            }
        })
    }
    final func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ShowChatMessageVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedEventMessage, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ShowVideoEndVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "LoginStatusChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("BindPushNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("AppWillTerminate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("AppConfigParam"), object: nil)
        KKAudioControlManager.shareInstance()?.removeMuteListener()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("KKAudioControlMuteTurnOnNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.init("KKAudioControlMuteTurnOffNotification"), object: nil)
        self.networkManager?.stopListening()
        self.networkManager = nil
    }
    /// 更新配置信息
    @objc private func funcAppConfigParam(_ sender: Notification) {
        guard let dic = sender.object as? [String: Any], let model = ZModelConfig.deserialize(from: dic) else { return }
        ZReload.shared.is_chat_gift = model.chat_gift
        if model.message_price > 0 { ZReload.shared.message_price = model.message_price }
    }
    /// 当有电话进来或者锁屏时，应用程序便会挂起
    @objc private func funcAppWillResignActive() {
        BFLog.debug("funcAppWillResignActive")
        ZBindKit.shared.isBindSuccess = false
    }
    /// 应用程序进入后台时执行
    @objc private func funcAppEnterBackground() {
        BFLog.debug("funcAppEnterBackground")
        if ZSettingKit.shared.isLogin {
            var count: Int = 0
            ZSQLiteKit.getMessageUnreadCount(count: &count)
            UIApplication.shared.applicationIconBadgeNumber = count
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 1
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        ZBindKit.shared.isBindSuccess = false
    }
    /// 应用程序重新进入活动状态时执行
    @objc private func funcAppBecomeActive() {
        BFLog.debug("funcAppBecomeActive")
        if ZSettingKit.shared.isLogin {
            ZWebSocketKit.shared.reconnect()
            ZChatSDKKit.shared.reconnect()
        }
    }
    /// app被销毁
    @objc private func funcAppWillTerminate() {
        BFLog.debug("funcAppWillTerminate")
        ZBindKit.shared.isBindSuccess = false
        ZChatSDKKit.shared.disconnect()
        ZWebSocketKit.shared.disconnect()
        ZSQLiteKit.shared.close()
        ZObserverKit.shared.removeObserver()
        ZAudioCallKit.shared.stopSound()
    }
    /// 绑定设备
    @objc private func funcBindPushNotification(_ sender: Notification) {
        ZBindKit.bindPush()
    }
    /// 监听手机静音开关状态 - 不是静音
    @objc private func funcAudioControlMuteTurnOn(_ sender: Notification) {
        if self.isShowingCallVC {
            ZAudioCallKit.shared.playSound("user")
        }
        BFLog.debug("setAudioControlMuteTurnOn")
    }
    /// 监听手机静音开关状态 - 静音
    @objc private func funcAudioControlMuteTurnOff(_ sender: Notification) {
        if self.isShowingCallVC {
            ZAudioCallKit.shared.stopSound()
        }
        BFLog.debug("setAudioControlMuteTurnOff")
    }
    /// 显示视频结束后的页面
    @objc private func funcShowVideoEndVC(_ sender: Notification) {
        guard let dic = sender.object as? [String: Any], let type = dic["type"] as? String else { return }
        switch type {
        case "Evaluation":
            guard let model = dic["data"] as? ZModelIMBalance else { return }
            let z_tempvc = ZAnchorEvaluationViewController.init()
            z_tempvc.modelBalance = ZModelIMBalance.init(instance: model)
            z_tempvc.showType = 2
            ZRouterKit.present(toVC: z_tempvc, animated: false)
        case "Recommend":
            let z_tempvc = ZAnchorRecommendViewController.init()
            z_tempvc.showType = 2
            ZRouterKit.present(toVC: z_tempvc, animated: false)
        default: break
        }
    }
    /// 处理服务器IM事件
    @objc private func funcReceivedEventMessage(_ sender: Notification) {
        guard let event = sender.object as? ZModelIMEvent else { return }
        switch event.event_code {
        case kEnumSocketEvent.call:
            guard let model = sender.object as? ZModelIMCall else { return }
            if !self.isShowingCallVC,
               !self.isShowingVideoVC {
                let z_tempvc = ZCallViewController.init()
                z_tempvc.modelIMCall = ZModelIMCall.init(instance: model)
                z_tempvc.showType = 2
                ZRouterKit.present(toVC: z_tempvc, animated: false, completion: {
                    ZObserverKit.shared.isShowingCallVC = true
                })
            }
        case kEnumSocketEvent.hangup:
            guard let model = sender.object as? ZModelIMHangup else { return }
            NotificationCenter.default.post(name: Notification.Names.DismissCallVideoVC, object: model, userInfo: nil)
        default: break
        }
    }
    /// 显示消息页面
    @objc private func funcShowChatMessageVC(_ sender: Notification) {
         let vcs = ZRouterKit.getCurrentVC()?.navigationController?.viewControllers.filter({ (vc) -> Bool in
            if vc.isMember(of: ZMessageViewController.classForCoder()) { return true }
            return false
        })
        if let vc = vcs?.first as? ZMessageViewController, let fromVC = ZCurrentVC.shared.currentVC {
            ZRouterKit.pop(toVC: vc, fromVC: fromVC, animated: true, completion: nil)
            return
        }
        let z_tempvc = ZMessageViewController()
        if let model = sender.object as? ZModelUserBase {
            z_tempvc.modelUser = ZModelUserInfo.init(instance: model)
        }
        if let model = sender.object as? ZModelUserInfo {
            z_tempvc.modelUser = ZModelUserInfo.init(instance: model)
        }
        ZRouterKit.push(toVC: z_tempvc)
    }
    /// 登录状态改变
    @objc private func funcLoginStatusChange(_ sender: Notification) {
        ZBindKit.shared.isBindSuccess = false
        if ZSettingKit.shared.isLogin {
            ZReload.configAppIds()
            ZChatSDKKit.shared.reconnect()
            ZWebSocketKit.shared.reconnect()
            ZTimerKit.shared.startTimer()
        } else {
            ZChatSDKKit.shared.disconnect()
            ZWebSocketKit.shared.disconnect()
            ZTimerKit.shared.stopTimer()
        }
    }
}
