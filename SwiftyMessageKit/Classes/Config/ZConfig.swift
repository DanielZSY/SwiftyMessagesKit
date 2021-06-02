
import UIKit
import SwiftBasicKit

/// 消息视频加载
public struct ZReload {
    
    internal var is_chat_gift: Bool = false
    internal var message_price: Int = 10
    internal let agora_app_id: String = "7350c173cd584d208a5617a37657e7f0"
    
    internal static var shared = ZReload()
    
    /// 相关配置
    internal static func configAppIds() {
        ZKey.shared.configAppId(appleId: ZKey.appId.appleId,
                                serviceAppId: ZKey.appId.serviceAppId,
                                messageAppId: ZReload.shared.agora_app_id,
                                pushAppId: ZKey.appId.pushAppId,
                                bugAppId: ZKey.appId.bugAppId,
                                countAppId: ZKey.appId.countAppId)
    }
    /// 开始各种监听
    public static func configMessageKit() {
        
        ZReload.shared.configColor()
        ZObserverKit.shared.configObserver()
    }
    /// 登录状态初始化
    public static func configLogin() {
        if ZSettingKit.shared.isLogin {
            ZWebSocketKit.shared.reconnect()
            ZChatSDKKit.shared.reconnect()
            if !ZBindKit.shared.isBindSuccess {
                ZBindKit.bindPush(clientId: ZWebSocketKit.shared.client_id)
            }
        }
    }
    /// 移除各种监听
    public static func removeMessageKit() {
        
        ZObserverKit.shared.removeObserver()
    }
    private func configColor() {
        UITextField.appearance().keyboardAppearance = .dark
        ZProgressHUD.shared.hudLabelText = "Loading"
        ZProgressHUD.shared.hudTextColor = "#FFFFFF".color
        ZProgressHUD.shared.hudBGColor = "#1E1925".color
        ZProgressHUD.shared.hudImage = Asset.hudCircle.image
        
        ZAlertView.shared.attributedButtonColor = "#FFFFFF"
        ZAlertView.shared.attributedCancelColor = "#7037E9"
        
        ZColor.shared.configNavColor(bg: "#100D13", line: "#100D13", btn: "#FFFFFF", title: "#FFFFFF")
        ZColor.shared.configViewColor(bg: "#100D13", border: "#1E1925", title: "#823AF3", desc: "#47474D")
        ZColor.shared.configTabColor(bg: "#1E1925", line: "#1E1925", btnNormal: "#493443", btnSelect: "#F4F4F4", titleNormal: "#493443", titleSelect: "#F4F4F4")
        ZColor.shared.configInputColor(bg: "#100D13", border: "#E0E0E0", cursor: "#7037E9", text: "#7037E9", prompt: "#47474D", keybg: "#1F1824")
        
    }
}
