
import UIKit
import SwiftBasicKit

protocol ZMessageViewModelDelegate: class {
    func func_requestgiftarray(models: [ZModelGift]?)
    func func_requestdetailsuccess(model: ZModelUserInfo)
}
class ZMessageViewModel: ZBaseViewModel {
    
    weak var delegate: ZMessageViewModelDelegate?
    
    final func func_reloadgiftarray() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: "appgifts"), let models = [ZModelGift].deserialize(from: dic["gifts"] as? [Any]) {
            self.delegate?.func_requestgiftarray(models: models.compactMap({ (model) -> ZModelGift? in return model }))
        } else {
            ZNetworkKit.created.startRequest(target: .get(ZAction.apigiftlist.api, nil), responseBlock: { [weak self] result in
                guard let `self` = self else { return }
                if result.success, let dic = result.body as? [String: Any], let models = [ZModelGift].deserialize(from: dic["gifts"] as? [Any]) {
                    ZLocalCacheManager.func_setlocaldata(dic: dic, key: "appgifts")
                    self.delegate?.func_requestgiftarray(models: models.compactMap({ (model) -> ZModelGift? in return model }))
                }
            })
        }
    }
    final func func_reloaduserdetail(userid: String) {
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.created.startRequest(target: .get(ZAction.apiuserdetail.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelUserInfo.deserialize(from: dic) {
                self.delegate?.func_requestdetailsuccess(model: model)
            }
        })
    }
}
