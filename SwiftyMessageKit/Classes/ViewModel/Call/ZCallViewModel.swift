
import UIKit
import BFKit
import Foundation
import SwiftBasicKit

protocol ZCallViewModelDelegate: class {
    func func_requestdetailsuccess(model: ZModelUserInfo)
}
class ZCallViewModel: ZBaseViewModel {
    
    weak var delegate: ZCallViewModelDelegate?
    
    final func func_requestuserdetail(userid: String) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserdetail.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserInfo.deserialize(from: dic) {
                self.delegate?.func_requestdetailsuccess(model: model)
            }
        })
    }
    static func func_sendhangup(model: ZModelIMCall?) {
        BFLog.debug("hangup call callid: \(model?.call_id ?? 0)")
        guard let tempmodel = model?.copyable() else { return }
        if tempmodel.call_id == 0 { return }
        var param = [String: Any]()
        param["call_id"] = tempmodel.call_id
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicallhangup.api, param), responseBlock: { result in
            
        })
    }
    static func func_sendanswer(model: ZModelIMCall?, issee: Bool) {
        BFLog.debug("answer call callid: \(model?.call_id ?? 0)")
        guard let tempmodel = model?.copyable() else { return }
        if tempmodel.call_id == 0 {
            DispatchQueue.DispatchAfter(after: 1, handler: {
                NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: 2)
            })
            return
        }
        var param = [String: Any]()
        param["call_id"] = tempmodel.call_id
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicallanswer.api, param), responseBlock: { result in
            if result.success,
               let dic = result.body as? [String: Any],
               let channel_id = dic["channel_id"] as? String,
               let channel_token = dic["channel_token"] as? String {
                if ZWebSocketKit.shared.callid == tempmodel.call_id && ZWebSocketKit.shared.callevent == .hangup {
                    DispatchQueue.DispatchAfter(after: 0.5, handler: {
                        ZAlertView.showAlertView(message: ZString.alertOtherHungupCall.text)
                    })
                    return
                }
                let answer = ZModelIMAnswer()
                answer.call_id = tempmodel.call_id
                answer.type = tempmodel.type
                answer.event_code = .response
                answer.aappid = ZReload.shared.agora_app_id
                answer.channel_id = channel_id
                answer.channel_token = channel_token
                answer.issee = issee
                answer.callee = tempmodel.other_people?.copyable()
                let z_tempvc = ZVideoViewController.init()
                z_tempvc.modelAnswer = answer
                z_tempvc.showType = 2
                DispatchQueue.DispatchAfter(after: 0.25, handler: {
                    ZObserverKit.shared.isShowingVideoVC = true
                    ZRouterKit.present(toVC: z_tempvc, animated: false)
                })
            } else {
                DispatchQueue.DispatchAfter(after: 0.5, handler: {
                    ZAlertView.showAlertView(message: result.message)
                })
            }
        })
    }
}
