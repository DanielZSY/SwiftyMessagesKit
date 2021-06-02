
import UIKit
import Foundation
import SwiftBasicKit

protocol ZAnchorsViewModelDelegate: class {
    func func_requesttagssuccess(models: [ZModelTag]?)
}

class ZAnchorsViewModel: ZBaseViewModel {

    weak var delegate: ZAnchorsViewModelDelegate?
    
    final func func_requestarraytags() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: "apptags"), let models = [ZModelTag].deserialize(from: dic["tags"] as? [Any]) {
            self.delegate?.func_requesttagssuccess(models: models.compactMap({ (model) -> ZModelTag? in return model }))
        }
        ZNetworkKit.created.startRequest(target: .get(ZAction.apitaglist.api, nil), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelTag].deserialize(from: dic["tags"] as? [Any]) {
                ZLocalCacheManager.func_setlocaldata(dic: dic, key: "apptags")
                self.delegate?.func_requesttagssuccess(models: models.compactMap({ (model) -> ZModelTag? in return model }))
            }
        })
    }
}
