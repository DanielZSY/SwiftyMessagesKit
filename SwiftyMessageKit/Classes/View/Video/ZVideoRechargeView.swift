
import UIKit
import SwiftBasicKit

/// 视频充值页面
class ZVideoRechargeView: UIView, InputItem {
    
    public var inputBarAccessoryView: InputBarAccessoryView?
    public var parentStackViewPosition: InputStackView.Position?
    var z_onrechargeitemclick: ((_ pid: ZRechargeType, _ recharge: ZModelRecharge) -> Void)?
    internal var z_arrayType: [ZModelPurchase]? {
        didSet {
            self.z_currentModel = z_arrayType?.last
            self.z_viewpurchase.reloadData()
            let count = self.z_arrayType?.count ?? 0
            z_viewtype.isHidden = count <= 1
            z_viewtype.z_arrayType = z_arrayType
            z_viewpurchase.y = self.height - z_viewpurchase.height
        }
    }
    internal var z_coins: Double = 0 {
        didSet {
            z_lbcoins.text = z_coins.str
        }
    }
    private var z_currentModel: ZModelPurchase?
   
    private lazy var z_imagecoins: UIImageView = {
        let z_temp = UIImageView.init(frame: CGRect.init(15.scale, 18.scale, 20.scale, 23.scale))
        z_temp.image = Asset.iconDiamond2.image
        return z_temp
    }()
    private lazy var z_lbcoins: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(43.scale, 15.scale, 200.scale, 29.scale))
        z_temp.textColor = "#E9E9E9".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_viewtype: ZVideoRechargeTypeView = {
        let z_temp = ZVideoRechargeTypeView.init(frame: CGRect.init(0, 50.scale, self.width, 85.scale))
        z_temp.isHidden = true
        return z_temp
    }()
    private lazy var z_viewpurchase: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: 115.scale, height: 160.scale)
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.scrollDirection = .horizontal
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, self.height - 170.scale, self.width, 170.scale), collectionViewLayout: z_templayout)
        z_temp.backgroundColor = .clear
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZVideoRechargeItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    override var frame: CGRect {
        didSet {
            z_viewpurchase.y = self.height - z_viewpurchase.height
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_imagecoins)
        self.addSubview(z_lbcoins)
        self.addSubview(z_viewtype)
        self.addSubview(z_viewpurchase)
        
        z_viewpurchase.delegate = self
        z_viewpurchase.dataSource = self
        z_viewtype.z_onbuttontypeclick = { row in
            switch row {
            case 1:
                if let model = self.z_arrayType?.first {
                    self.z_currentModel = ZModelPurchase.init(instance: model)
                }
                DispatchQueue.DispatchaSync(mainHandler: {
                    self.z_viewpurchase.reloadData()
                })
            case 2:
                if let model = self.z_arrayType?.last {
                    self.z_currentModel = ZModelPurchase.init(instance: model)
                }
                DispatchQueue.DispatchaSync(mainHandler: {
                    self.z_viewpurchase.reloadData()
                })
            default: break
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        z_viewpurchase.delegate = nil
        z_viewpurchase.dataSource = nil
    }
}
extension ZVideoRechargeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.z_currentModel?.items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZVideoRechargeItemCVC
        cell.tag = indexPath.row
        cell.z_modelPurchase = self.z_currentModel
        if let model = self.z_currentModel?.items?[indexPath.row] {
            cell.z_modelRecharge = ZModelRecharge.init(instance: model)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.z_currentModel?.items?[indexPath.row], let gid = self.z_currentModel?.gid {
            self.z_onrechargeitemclick?(gid, model)
        }
    }
}
extension ZVideoRechargeView {
   
    public func textViewDidChangeAction(with textView: InputTextView) {
        
    }
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        
    }
    public func keyboardEditingEndsAction() {
        
    }
    public func keyboardEditingBeginsAction() {
        
    }
}
