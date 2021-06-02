
import UIKit
import SwiftBasicKit

class ZGiftView: UIView, InputItem {
    
    public var inputBarAccessoryView: InputBarAccessoryView?
    public var parentStackViewPosition: InputStackView.Position?
    var z_coins: Double = 0 {
        didSet {
            z_lbcoins.text = z_coins.str
        }
    }
    var z_array: [ZModelGift]? {
        didSet {
            arrayGift.removeAll()
            if let array = self.z_array {
                arrayGift.append(contentsOf: array)
            }
            z_viewgifts.reloadData()
        }
    }
    var z_ongiftitemclick: ((_ model: ZModelGift?) -> Void)?
    private var arrayGift: [ZModelGift] = [ZModelGift]()
    private lazy var z_viewhead: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(0, 0, self.width, 44.scale))
        return z_temp
    }()
    private lazy var z_lbtitle: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 10.scale, 45.scale, 24.scale))
        z_temp.text = ZString.lbGifts.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.boldSize = 15
        return z_temp
    }()
    private lazy var z_lbcoins: ZBalanceButton = {
        let z_temp = ZBalanceButton.init(frame: CGRect.init(self.width - 100.scale, 0.scale, 90.scale, 34.scale))
        return z_temp
    }()
    private lazy var z_viewgifts: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout()
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.itemSize = CGSize.init(width: self.width/4, height: 125.scale)
        z_templayout.scrollDirection = .vertical
        
        let z_temp = ZBaseCV.init(frame: CGRect.init(0, z_viewhead.height, self.width, 250.scale), collectionViewLayout: z_templayout)
        z_temp.scrollsToTop = false
        z_temp.isPagingEnabled = true
        z_temp.isScrollEnabled = true
        z_temp.isUserInteractionEnabled = true
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        z_temp.register(ZGiftItemCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(z_viewhead)
        self.addSubview(z_viewgifts)
        self.backgroundColor = .clear
        
        z_viewhead.addSubview(z_lbtitle)
        z_viewhead.addSubview(z_lbcoins)
        
        z_viewgifts.delegate = self
        z_viewgifts.dataSource = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        z_viewgifts.delegate = nil
        z_viewgifts.dataSource = nil
    }
    @objc private func func_btngiftclick(_ sender: ZGiftItemButton) {
        self.z_ongiftitemclick?(sender.z_model)
    }
}
extension ZGiftView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGift.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZGiftItemCVC
        cell.tag = indexPath.row
        cell.z_model = arrayGift[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.z_ongiftitemclick?(arrayGift[indexPath.row])
    }
}
extension ZGiftView {
   
    public func textViewDidChangeAction(with textView: InputTextView) {
        
    }
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        
    }
    public func keyboardEditingEndsAction() {
        
    }
    public func keyboardEditingBeginsAction() {
        
    }
}
