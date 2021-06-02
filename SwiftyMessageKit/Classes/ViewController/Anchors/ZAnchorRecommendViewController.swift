
import UIKit
import SwiftBasicKit

/// 推荐主播
class ZAnchorRecommendViewController: ZBaseViewController {
    
    private var z_arrayanchor: [ZModelUserInfo] = [ZModelUserInfo]()
    private lazy var lbtitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init(kScreenWidth/2 - 220.scale/2, kStatusHeight + 80.scale, 220.scale, 50.scale))
        item.fontSize = 18
        item.text = ZString.lbRecommendTitle.text
        item.textColor = "#FFFFFF".color
        item.textAlignment = .center
        item.numberOfLines = 0
        return item
    }()
    private lazy var lbcontent: UILabel = {
        let item = UILabel.init(frame: CGRect.init(0, lbtitle.y + lbtitle.height + 60.scale, kScreenWidth, 30))
        item.fontSize = (24)
        item.text = ZString.lbRecommendContent.text
        item.textColor = "#FFFFFF".color
        item.textAlignment = .center
        return item
    }()
    private lazy var btnNoThanks: UIButton = {
        let item = UIButton.init(frame: CGRect.init(34.scale, kScreenHeight - 44 - 34, 308.scale, 44))
        item.adjustsImageWhenHighlighted = false
        item.setTitleColor("#E9E9E9".color, for: .normal)
        item.setTitle(ZString.lbRecommendNothanks.text, for: .normal)
        item.backgroundColor = "#7037E9".color
        item.border(color: .clear, radius: 22, width: 0)
        return item
    }()
    private lazy var viewContent: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth/2, height: 262.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .vertical
        z_templayout.sectionHeadersPinToVisibleBounds = true
        z_templayout.sectionFootersPinToVisibleBounds = true
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, lbcontent.y + lbcontent.height + 40.scale, kScreenWidth, 270.scale), collectionViewLayout: z_templayout)
        z_temp.tag = 1
        z_temp.isScrollEnabled = true
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZAnchorRecommendItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showType = 2
        self.view.addSubview(self.lbtitle)
        self.view.addSubview(self.lbcontent)
        self.view.addSubview(self.viewContent)
        self.view.addSubview(self.btnNoThanks)
        
        btnNoThanks.addTarget(self, action: "func_btnNoThanksclick", for: .touchUpInside)
        viewContent.delegate = self
        viewContent.dataSource = self
        
        var param = [String: Any]()
        param["filter"] = ["quick": "recommend"]
        param["per_page"] = 2
        param["page"] = 1
        ZNetworkKit.created.startRequest(target: .get(ZAction.apianchorlist.api, param), responseBlock: { [weak self] result in
            guard let `self` = self else { return }
            if result.success, let dic = result.body as? [String: Any], let models = [ZModelUserInfo].deserialize(from: dic["anchors"] as? [Any]) {
                self.z_arrayanchor.removeAll()
                self.z_arrayanchor.append(contentsOf: models.compactMap({ (model) -> ZModelUserInfo? in return model }))
                DispatchQueue.DispatchaSync(mainHandler: {
                    self.viewContent.reloadData()
                })
            }
        })
    }
    deinit {
        viewContent.delegate = nil
        viewContent.dataSource = nil
    }
    @objc private func func_btnNoThanksclick() {
        ZRouterKit.dismiss(fromVC: self, animated: true, completion: nil)
    }
}
extension ZAnchorRecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return z_arrayanchor.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZAnchorRecommendItemCVC
        cell.func_setcvcmodel(model: z_arrayanchor[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = z_arrayanchor[indexPath.row].copyable()
        ZRouterKit.dismiss(fromVC: self, animated: true, completion: {
            DispatchQueue.DispatchAfter(after: 0.25, handler: {
                NotificationCenter.default.post(name: Notification.Names.ShowUserDetailVC, object: user)
            })
        })
    }
}
