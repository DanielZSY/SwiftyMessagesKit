
import UIKit
import Foundation
import SwiftBasicKit
import SwiftyStoreKit

protocol ZVideoViewModelDelegate: class {
    func func_requestppasuccess(dic: [String: Any])
    func func_requestgiftarray(models: [ZModelGift]?)
    func func_requestrechargearray(models: [ZModelPurchase]?)
    func func_followsuccess(follow: Bool)
    func func_checkcallstatus(model: ZModelIMStatus)
    func func_requestdetailsuccess(model: ZModelUserInfo)
}
class ZVideoViewModel: ZBaseViewModel {
    
    weak var delegate: ZVideoViewModelDelegate?
    
    /// 发送挂断通话
    static func func_sendhangup(model: ZModelIMAnswer?) {
        guard let tempmodel = model?.copyable() else { return }
        if tempmodel.call_id == 0 { return }
        var param = [String: Any]()
        param["call_id"] = tempmodel.call_id
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicallhangup.api, param), responseBlock: { result in
            
        })
    }
    /// 获取用户详情
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
    /// 检测通话状态
    final func func_checkcallstatus(callid: Int) {
        var param = [String: Any]()
        param["call_id"] = callid
        ZNetworkKit.created.startRequest(target: .get(ZAction.apicall.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let model = ZModelIMStatus.deserialize(from: dic) {
                self.delegate?.func_checkcallstatus(model: model)
            }
        })
    }
    /// 关注或取消关注
    final func func_followuser(userid: String, follow: Bool) {
        var param = [String: Any]()
        param["user_id"] = userid
        let path = follow == true ? ZAction.apiuserfollow.api : ZAction.apiuserunfollow.api
        ZNetworkKit.created.startRequest(target: .post(path, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                self.delegate?.func_followsuccess(follow: follow)
            }
        })
    }
    /// 获取礼物清单
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
    /// 获取充值列表
    final func func_reloadrechargearray() {
        if let dic = ZLocalCacheManager.func_getlocaldata(key: "apptokens"), let models = [ZModelPurchase].deserialize(from: dic["tokens"] as? [Any]) {
            self.delegate?.func_requestrechargearray(models: models.compactMap({ (model) -> ZModelPurchase? in return model }))
        } else {
            ZNetworkKit.created.startRequest(target: .get(ZAction.apitokenlist.api, nil), responseBlock: { [weak self] result in
                guard let `self` = self else { return }
                if result.success, let dic = result.body as? [String: Any], let models = [ZModelPurchase].deserialize(from: dic["tokens"] as? [Any]) {
                    ZLocalCacheManager.func_setlocaldata(dic: dic, key: "apptokens")
                    self.delegate?.func_requestrechargearray(models: models.compactMap({ (model) -> ZModelPurchase? in return model }))
                }
            })
        }
    }
    /// 发起IM支付
    final func func_requestpayrecharge(model: ZModelIMRecharge, showhud: Bool = true) {
        switch model.gid {
        case 1:
            if showhud { ZProgressHUD.show(vc: self.vc) }
            ZSwiftStoreKit.purchaseProduct(productId: model.code, diamond: 0, completion: { [weak self] error in
                if showhud { ZProgressHUD.dismiss() }
                guard let `self` = self else { return }
                guard let err = error else {
                    self.func_requestservicerecharge(model: model)
                    return
                }
                ZProgressHUD.showMessage(vc: self.vc, text: err.localizedDescription)
            })
        case 3:
            var param = [String: Any]()
            param["code"] = model.code
            if showhud { ZProgressHUD.show(vc: self.vc) }
            ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
                if showhud { ZProgressHUD.dismiss() }
                guard let `self` = self else { return }
                if result.success, let dic = result.body as? [String: Any] {
                    self.delegate?.func_requestppasuccess(dic: dic)
                } else {
                    ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                }
            })
        default: break
        }
    }
    /// 发起ppay支付
    final func func_requestppayrecharge(model: ZModelRecharge, showhud: Bool = true) {
        var param = [String: Any]()
        param["code"] = model.code
        if showhud { ZProgressHUD.show(vc: self.vc) }
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any] {
                self.delegate?.func_requestppasuccess(dic: dic)
            } else {
                ZProgressHUD.showMessage(vc: self.vc, text: result.message)
            }
        })
    }
    /// 发起apay支付
    final func func_requestapayrecharge(model: ZModelRecharge, showhud: Bool = true) {
        if showhud { ZProgressHUD.show(vc: self.vc) }
        ZSwiftStoreKit.purchaseProduct(productId: model.code, diamond: 0, completion: { [weak self] error in
            if showhud { ZProgressHUD.dismiss() }
            guard let `self` = self else { return }
            guard let err = error else {
                self.func_requestservicerecharge(model: model)
                return
            }
            ZProgressHUD.showMessage(vc: self.vc, text: err.localizedDescription)
        })
    }
    /// 上报购买成功的内购项
    private final func func_requestservicerecharge(model: ZModelRecharge) {
        guard let receiptData = SwiftyStoreKit.localReceiptData else { return }
        let receiptString = receiptData.base64EncodedString(options: [])
        var param = [String: Any]()
        param["code"] = model.code
        param["receipt"] = receiptString
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                ZProgressHUD.dismiss()
                ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
            } else {
                ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
                    ZProgressHUD.dismiss()
                    guard let `self` = self else { return }
                    if result.success {
                        ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
                    } else {
                        var dicreceipt = ZLocalCacheManager.func_getlocaldata(key: "receiptdata") ?? [String: Any]()
                        dicreceipt[receiptString.md5()] = ["pid": model.code, "uid": ZSettingKit.shared.userId, "receipt": ZCryptoContentManager.encrypt(receiptString)]
                        ZLocalCacheManager.func_setlocaldata(dic: dicreceipt, key: "receiptdata")
                        ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                    }
                })
            }
        })
    }
    /// 上报购买成功的内购项
    private final func func_requestservicerecharge(model: ZModelIMRecharge) {
        guard let receiptData = SwiftyStoreKit.localReceiptData else { return }
        let receiptString = receiptData.base64EncodedString(options: [])
        var param = [String: Any]()
        param["code"] = model.code
        param["receipt"] = receiptString
        ZProgressHUD.show(vc: self.vc)
        ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success {
                ZProgressHUD.dismiss()
                ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
            } else {
                ZNetworkKit.created.startRequest(target: .post(ZAction.apiusertoken.api, param), responseBlock: { [weak self] result in
                    ZProgressHUD.dismiss()
                    guard let `self` = self else { return }
                    if result.success {
                        ZProgressHUD.showMessage(vc: nil, text: ZString.successRecharge.text)
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "PayRechargeSuccess"), object: nil)
                    } else {
                        var dicreceipt = ZLocalCacheManager.func_getlocaldata(key: "receiptdata") ?? [String: Any]()
                        dicreceipt[receiptString.md5()] = ["pid": model.code, "uid": ZSettingKit.shared.userId, "receipt": ZCryptoContentManager.encrypt(receiptString)]
                        ZLocalCacheManager.func_setlocaldata(dic: dicreceipt, key: "receiptdata")
                        ZProgressHUD.showMessage(vc: self.vc, text: result.message)
                    }
                })
            }
        })
    }
}
