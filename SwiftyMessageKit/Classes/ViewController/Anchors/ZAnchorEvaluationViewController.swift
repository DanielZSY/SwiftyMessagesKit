
import UIKit
import SwiftBasicKit

/// 评论主播
class ZAnchorEvaluationViewController: ZBaseViewController {

    private var selectRating: Int = 4
    private var arraySelectTags: [String] = [String]()
    private var arrayAnchorTags: [ZModelTag] = [ZModelTag]()
    internal var modelBalance: ZModelIMBalance?
    private lazy var viewHeader: ZAnchorEvaluationHeadView = {
        let item = ZAnchorEvaluationHeadView.init(frame: CGRect.init((9).scale, kStatusHeight + (20).scale, kScreenWidth - (18).scale, (134).scale))
        
        return item
    }()
    private lazy var viewAnchorTags: ZAnchorEvaluationTagsView = {
        let item = ZAnchorEvaluationTagsView.init(frame: CGRect.init(self.viewHeader.x, self.viewHeader.y + self.viewHeader.height + (15).scale, self.viewHeader.width, (174).scale))
        
        return item
    }()
    private lazy var viewRating: ZAnchorEvaluationRatingView = {
        let item = ZAnchorEvaluationRatingView.init(frame: CGRect.init(self.viewHeader.x, self.viewAnchorTags.y + self.viewAnchorTags.height + (15).scale, self.viewHeader.width, (121).scale))
        
        return item
    }()
    private lazy var btnContinue: UIButton = {
        let item = UIButton.init(frame: CGRect.init(self.viewHeader.x, kScreenHeight - (90).scale, self.viewHeader.width, (50).scale))
        
        item.adjustsImageWhenHighlighted = false
        item.titleLabel?.boldSize = 18
        item.backgroundColor = "#7037E9".color
        item.setTitle(ZString.btnContinue.text, for: .normal)
        item.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        item.border(color: .clear, radius: (25).scale, width: 0)
        
        return item
    }()
    private let z_viewmodel: ZAnchorsViewModel = ZAnchorsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.z_viewmodel.vc = self
        self.showType = 2
        self.innerInitView()
        self.innerInitEvent()
        self.innerInitData()
        NotificationCenter.default.addObserver(self, selector: #selector(setEndEvaluationVeryBad(_:)), name: NSNotification.Name.init(rawValue: "EndEvaluationVeryBad"), object: nil)
        z_viewmodel.delegate = self
    }
    deinit {
        z_viewmodel.delegate = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "EndEvaluationVeryBad"), object: nil)
    }
    private func innerInitView() {
        self.view.addSubview(self.viewHeader)
        self.view.addSubview(self.viewAnchorTags)
        self.view.addSubview(self.viewRating)
        self.view.addSubview(self.btnContinue)
    }
    private func innerInitData() {
        z_viewmodel.func_requestarraytags()
        guard let model = self.modelBalance else { return }
        self.viewHeader.setViewModel(model)
    }
    private func innerInitEvent() {
        self.btnContinue.addTarget(self, action: "func_btnContinueclick", for: .touchUpInside)
        self.viewHeader.onButtonComplaintEvent = {
            self.showAlertComplaintVC(rating: 0)
        }
        self.viewAnchorTags.onButtonTagEvent = { row, isselect in
            guard self.arrayAnchorTags.count > row else { return }
            let model = self.arrayAnchorTags[row]
            if isselect {
                self.arraySelectTags.append(model.tagid)
            } else {
                self.arraySelectTags.remove(model.tagid)
            }
            self.viewAnchorTags.setButtonIsSelect(row, isSelect: isselect)
        }
        self.viewRating.onButtonRatingEvent = { row in
            self.selectRating = row
            switch row {
            case 1, 5: self.showAlertComplaintVC(rating: self.selectRating)
            default: break
            }
        }
    }
    private func dismissVC() {
        ZRouterKit.dismiss(fromVC: self, animated: true, completion: nil)
    }
    private func showAlertComplaintVC(rating: Int) {
        guard let model = self.modelBalance else { return }
        let itemVC = ZAnchorComplaintViewController.init()
        itemVC.setViewVideoModel(model, self.arraySelectTags, rating)
        ZRouterKit.present(toVC: itemVC, fromVC: self, animated: true, completion: nil)
    }
    @objc private func setEndEvaluationVeryBad(_ sender: Notification) {
        self.dismissVC()
    }
    @objc private func func_btnContinueclick() {
        guard let model = self.modelBalance else {
            self.dismissVC()
            return
        }
        if self.selectRating == 1 || self.selectRating == 5 {
            self.showAlertComplaintVC(rating: self.selectRating)
            return
        }
        ZProgressHUD.show(vc: self)
        var param = [String: Any]()
        param["call_id"] = model.call_id
        param["anchor"] = ["rating": self.selectRating, "tag_ids": self.arraySelectTags]
        ZNetworkKit.created.startRequest(target: .post(ZAction.apicallcomment.api, param), responseBlock: { [weak self] result in
            ZProgressHUD.dismiss()
            guard let `self` = self else { return }
            self.dismissVC()
        })
    }
}
extension ZAnchorEvaluationViewController: ZAnchorsViewModelDelegate {
    func func_requesttagssuccess(models: [ZModelTag]?) {
        self.arrayAnchorTags.removeAll()
        if let array = models {
            self.arrayAnchorTags.append(contentsOf: array)
        }
        self.viewAnchorTags.setViewModelTags(self.arrayAnchorTags)
    }
}
