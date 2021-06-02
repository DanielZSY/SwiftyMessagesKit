
import UIKit
import BFKit
import OneSignal
import SwiftBasicKit

/// 绑定推送
struct ZBindKit {
    
    internal static var shared = ZBindKit()
    
    private var isBinding: Bool = false
    internal var isBindSuccess: Bool = false
    
    /// 绑定推送 clientId IM 连接标示
    static func bindPush(clientId: String? = nil) {
        guard ZSettingKit.shared.isLogin == true else { return }
        if let clientId = clientId, clientId.count > 0 {
            if ZBindKit.shared.isBinding || ZBindKit.shared.isBindSuccess { return }
            var param = [String: Any]()
            param["client_id"] = clientId
            ZBindKit.shared.isBinding = true
            ZNetworkKit.created.startRequest(target: .post(ZAction.apipusherbind.api, param), responseBlock: { result in
                ZBindKit.shared.isBinding = false
                ZBindKit.shared.isBindSuccess = result.success
            })
            return
        }
        if let onesignal_id = OneSignal.getUserDevice()?.getUserId(), let ios_push_token = OneSignal.getUserDevice()?.getPushToken() {
            var param = [String: Any]()
            param["onesignal_id"] = onesignal_id
            param["push_token"] = ios_push_token
            BFLog.debug("bindPush onesignal_id: \(onesignal_id), ios_push_token: \(ios_push_token)")
            ZNetworkKit.created.startRequest(target: .post(ZAction.apipusherbind.api, param), responseBlock: { result in
                
            })
        }
    }
    /// 取消绑定 clientId IM 连接标示
    static func unbindPush(clientId: String? = nil) {
        guard ZSettingKit.shared.isLogin == true else { return }
        if let clientId = clientId, clientId.count > 0 {
            var param = [String: Any]()
            param["client_id"] = clientId
            ZNetworkKit.created.startRequest(target: .post(ZAction.apipusherunbind.api, param), responseBlock: { result in
                if result.success {
                    ZBindKit.shared.isBindSuccess = false
                }
            })
            return
        }
        if let onesignal_id = OneSignal.getUserDevice()?.getUserId(), let ios_push_token = OneSignal.getUserDevice()?.getPushToken() {
            var param = [String: Any]()
            param["onesignal_id"] = onesignal_id
            param["push_token"] = ios_push_token
            BFLog.debug("bindPush onesignal_id: \(onesignal_id), ios_push_token: \(ios_push_token)")
            ZNetworkKit.created.startRequest(target: .post(ZAction.apipusherunbind.api, param), responseBlock: { result in
                
            })
        }
    }
}
