
import UIKit
import SwiftBasicKit

extension ZVideoViewController: ZVideoViewModelDelegate {
    /// 获取礼物列表
    func func_requestgiftarray(models: [ZModelGift]?) {
        self.z_viewinputbar.z_viewgifts.z_array = models
    }
    /// 获取充值列表
    func func_requestrechargearray(models: [ZModelPurchase]?) {
        if let array = models, array.count > 1 {
            self.z_viewinputbar.z_viewrecharge.height = 305.scale
        } else {
            self.z_viewinputbar.z_viewrecharge.height = 225.scale
        }
        self.z_viewinputbar.z_viewrecharge.z_arrayType = models
    }
    /// 关注||取消关注成功
    func func_followsuccess(follow: Bool) {
        self.z_viewhead.z_isfollow = follow
        if !self.z_viewfollow.isHidden { self.z_viewfollow.dismissAnimateView() }
    }
    /// 检测状态回调
    func func_checkcallstatus(model: ZModelIMStatus) {
        if model.status != 2 {
            self.func_dismissvc()
        }
    }
    /// 获取用户详情成功
    func func_requestdetailsuccess(model: ZModelUserInfo) {
        self.modeluser = model
        self.z_viewhead.z_isfollow = model.is_following
    }
    /// pay支付
    func func_requestppasuccess(dic: [String: Any]) {
        NotificationCenter.default.post(name: Notification.Names.ShowRechargeVC, object: dic)
    }
}
