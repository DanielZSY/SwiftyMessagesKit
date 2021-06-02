
import UIKit
import Foundation
import SwiftBasicKit

class ZBaseViewModel {
    
    var page: Int = 1
    weak var vc: UIViewController?
    
    /// 发起呼叫
    final func func_callanchor(model: ZModelUserInfo?) {
        guard let user = model else { return }
        ZWebSocketKit.shared.checkBindStatus()
        ZProgressHUD.show(vc: self.vc)
        var param = [String: Any]()
        param["callee_id"] = user.userid
        param["type"] = 1
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicall.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if !result.success {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
}
