
import UIKit
import SwiftBasicKit

/// 评论主播 - 内容输入
class ZAnchorComplaintViewController: ZBaseViewController {

    private var modelBalance: ZModelIMBalance?
    private var arraySelectTags: [String] = [String]()
    private var selectRating: Int = 0
    
    private lazy var viewBG: UIView = {
        let item = UIView.init(frame: CGRect.main())
        item.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return item
    }()
    private lazy var viewContent: UIView = {
        let item = UIView.init(frame: CGRect.init(0, kScreenHeight/2 - (280/2).scale, kScreenWidth, (280).scale))
        item.backgroundColor = .clear
        return item
    }()
    private lazy var viewContentBG: UIView = {
        let item = UIView.init(frame: self.viewContent.bounds)
        item.backgroundColor = "#1E1925".color
        return item
    }()
    private lazy var imageIcon: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init(10.scale, -(25).scale, 51.scale, 50.scale))
        item.isHidden = true
        item.image = Asset.evaVeryBadBig.image
        return item
    }()
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init(0, (10), self.viewContent.width, (30)))
        item.isHidden = true
        item.textColor = "#FFFFFF".color
        item.boldSize = 18
        item.textAlignment = .center
        item.text = ZString.lbComplaint.text
        return item
    }()
    private lazy var btnClose: UIButton = {
        let item = UIButton.init(frame: CGRect.init(self.viewContent.width - (45), 0, (45), (45)))
        item.adjustsImageWhenHighlighted = false
        item.setImage(Asset.btnCloseW.image, for: .normal)
        item.imageEdgeInsets = UIEdgeInsets.init(10)
        return item
    }()
    private lazy var textView: ZTextView = {
        let item = ZTextView.init(frame: CGRect.init((17), (45), 338.scale, (130).scale))
        item.maxLength = kMaxComment
        item.isMultiline = true
        item.backgroundColor = "#1E1925".color
        item.placeholderColor = "#56565C".color
        item.border(color: .clear, radius: 0, width: 0)
        return item
    }()
    private lazy var btnContinue: UIButton = {
        let item = UIButton.init(frame: CGRect.init((34).scale, viewContent.height - (64), (308).scale, (44)))
        item.backgroundColor = "#7037E9".color
        item.border(color: .clear, radius: (44/2).scale, width: 0)
        item.adjustsImageWhenHighlighted = false
        item.setTitle(ZString.btnContinue.text, for: .normal)
        item.setTitleColor("#E9E9E9".color, for: .normal)
        item.titleLabel?.boldSize = 18
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.innerInitView()
        self.innerInitEvent()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.showKeyboard()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.textView.dismissKeyboard()
        self.removeKeyboardNotification()
    }
    private func innerInitView() {
        self.view.backgroundColor = .clear
        self.view.addSubview(self.viewBG)
        self.view.addSubview(self.viewContent)
        self.view.bringSubviewToFront(self.viewContent)
        if self.selectRating == 0 {
            self.lbTitle.isHidden = false
            self.viewContent.addSubview(self.lbTitle)
            self.textView.placeholder = ZString.lbEvaluateComplaintPlaceholder.text
        } else {
            self.imageIcon.isHidden = false
            self.viewContent.addSubview(self.imageIcon)
            switch self.selectRating {
            case 5:
                self.imageIcon.image = Asset.evaVeryGoodBig.image
                self.textView.placeholder = ZString.lbEvaluateVeryGoodPlaceholder.text
            default:
                self.imageIcon.image = Asset.evaVeryBadBig.image
                self.textView.placeholder = ZString.lbEvaluateVeryBadPlaceholder.text
            }
        }
        self.viewContent.addSubview(self.btnClose)
        self.viewContent.addSubview(self.textView)
        self.viewContent.addSubview(self.btnContinue)
        
        self.viewContent.addSubview(self.viewContentBG)
        self.viewContent.sendSubviewToBack(self.viewContentBG)
        self.viewContent.bringSubviewToFront(self.imageIcon)
    }
    override func keyboardFrameChange(_ height: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewContent.y = (kScreenHeight - height)/2 - self.viewContent.height/2
        })
    }
    private func innerInitEvent() {
        btnClose.addTarget(self, action: "func_btnCloseclick", for: .touchUpInside)
        btnContinue.addTarget(self, action: "func_btnContinueclick", for: .touchUpInside)
    }
    @objc private func func_btnCloseclick() {
//        if self.selectRating == 5 {
//            self.setSaveData(text: "")
//        } else {
//            ZRouterKit.dismiss(fromVC: self, animated: true, completion: nil)
//        }
        ZRouterKit.dismiss(fromVC: self, animated: true, completion: nil)
    }
    @objc private func func_btnContinueclick() {
        let text = self.textView.text
        if text.count > kMaxComment {
            self.view.endEditing(true)
            ZProgressHUD.showMessage(vc: self, text: ZString.lbEvaluateComplaintContentCheck.text)
            return
        }
        self.setSaveData(text: text)
    }
    private func setSaveData(text: String) {
        self.view.endEditing(true)
        if self.selectRating != 0 {
            var param = [String: Any]()
            param["call_id"] = self.modelBalance?.call_id ?? 0
            param["anchor"] = ["rating": self.selectRating, "tag_ids": self.arraySelectTags, "content": text]
            ZProgressHUD.show(vc: self)
            ZNetworkKit.created.startRequest(target: .post(ZAction.apicallcomment.api, param), responseBlock: { [weak self] result in
                ZProgressHUD.dismiss()
                guard let `self` = self else { return }
                if result.success {
                    ZRouterKit.dismiss(fromVC: self, animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "EndEvaluationVeryBad"), object: nil)
                    })
                } else {
                    ZProgressHUD.showMessage(vc: self, text: result.message)
                }
            })
        } else {
            var param = [String: Any]()
            param["call_id"] = self.modelBalance?.call_id ?? 0
            param["content"] = text
            ZProgressHUD.show(vc: self)
            ZNetworkKit.created.startRequest(target: .post(ZAction.apicallreport.api, param), responseBlock: { [weak self] result in
                ZProgressHUD.dismiss()
                guard let `self` = self else { return }
                if result.success {
                    ZRouterKit.dismiss(fromVC: self, animated: true, completion: {
                        DispatchQueue.DispatchAfter(after: 0.25, handler: {
                            ZAlertView.showAlertView(message: ZString.lbEvaluateComplaintSuccessMessage.text)
                        })
                    })
                } else {
                    ZProgressHUD.showMessage(vc: self, text: result.message)
                }
            })
        }
    }
    final func setViewVideoModel(_ model: ZModelIMBalance, _ tags: [String], _ rating: Int) {
        self.modelBalance = model
        self.arraySelectTags.removeAll()
        self.arraySelectTags.append(contentsOf: tags)
        self.selectRating = rating
    }
}
