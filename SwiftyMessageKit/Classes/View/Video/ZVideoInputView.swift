
import UIKit
import SwiftBasicKit

class ZVideoInputView: UIView {
    
    internal lazy var z_viewgifts: ZGiftView = {
        let z_temp = ZGiftView.init(frame: CGRect.init(0, 0, kScreenWidth, 295.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.8)
        return z_temp
    }()
    internal lazy var z_viewrecharge: ZVideoRechargeView = {
        let z_temp = ZVideoRechargeView.init(frame: CGRect.init(0, 0, kScreenWidth, 225))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.8)
        return z_temp
    }()
    private lazy var inputTextGifts: UITextField = {
        let z_temp = UITextField.init(frame: inputTextView.frame)
        z_temp.isHidden = true
        z_temp.inputView = self.z_viewgifts
        return z_temp
    }()
    private lazy var inputTextRecharges: UITextField = {
        let z_temp = UITextField.init(frame: inputTextView.frame)
        z_temp.isHidden = true
        z_temp.inputView = self.z_viewrecharge
        return z_temp
    }()
    internal lazy var inputTextViewbg: UIView = {
        let z_temp = UIView.init(frame: CGRect.init(10.scale, 15, z_btnsee.x - 20.scale, 40.scale))
        z_temp.backgroundColor = "#000000".color.withAlphaComponent(0.6)
        z_temp.border(color: .clear, radius: 20.scale, width: 0)
        return z_temp
    }()
    internal lazy var inputTextView: UITextView = {
        let z_temp = UITextView.init(frame: CGRect.init(5.scale, 4.scale, inputTextViewbg.width - 10.scale, 30.scale))
        z_temp.backgroundColor = .clear
        z_temp.textColor = "#FFFFFF".color
        z_temp.font = UIFont.systemFont(ofSize: 12)
        z_temp.returnKeyType = .send
        return z_temp
    }()
    internal lazy var z_lbplaceholder: UILabel = {
        let z_temp = UILabel.init(frame: CGRect.init(15.scale, 8.5.scale, inputTextViewbg.width - 30.scale, 20.scale))
        z_temp.text = ZString.inputVideoPlaceholder.text
        z_temp.textColor = "#FFFFFF".color
        z_temp.isUserInteractionEnabled = false
        z_temp.fontSize = 12
        return z_temp
    }()
    internal lazy var z_btngift: ZVideoGiftButton = {
        let z_temp = ZVideoGiftButton.init(frame: CGRect.init(self.width - 50.scale, 12.5.scale, 45.scale, 45.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        //z_temp.setImage(Asset.btnGift.image, for: .normal)
        //z_temp.setImage(Asset.btnGift.image, for: .selected)
        //z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return z_temp
    }()
    internal lazy var z_btnrecharge: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btngift.x - 45.scale, 12.5.scale, 45.scale, 45.scale))
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnRecharge.image, for: .normal)
        z_temp.setImage(Asset.btnRecharge.image, for: .selected)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return z_temp
    }()
    internal lazy var z_btnflip: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btnrecharge.x - 45.scale, 12.5.scale, 45.scale, 45.scale))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnFlipN.image, for: .normal)
        z_temp.setImage(Asset.btnFlipS.image, for: .selected)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
        return z_temp
    }()
    internal lazy var z_btnsee: UIButton = {
        let z_temp = UIButton.init(frame: CGRect.init(z_btnflip.x - 45.scale, 12.5.scale, 45.scale, 45.scale))
        z_temp.isSelected = true
        z_temp.isHighlighted = false
        z_temp.adjustsImageWhenHighlighted = false
        z_temp.setImage(Asset.btnSeeN.image, for: .normal)
        z_temp.setImage(Asset.btnSeeS.image, for: .selected)
        z_temp.imageEdgeInsets = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
        return z_temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(inputTextViewbg)
        inputTextViewbg.addSubview(inputTextView)
        inputTextViewbg.addSubview(inputTextGifts)
        inputTextViewbg.addSubview(inputTextRecharges)
        inputTextViewbg.addSubview(z_lbplaceholder)
        inputTextViewbg.bringSubviewToFront(z_lbplaceholder)
        
        self.addSubview(z_btngift)
        self.addSubview(z_btnrecharge)
        self.addSubview(z_btnflip)
        self.addSubview(z_btnsee)
        
        z_btngift.addTarget(self, action: "func_btngiftclick", for: .touchUpInside)
        z_btnrecharge.addTarget(self, action: "func_btnrechargeclick", for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @objc private func func_btngiftclick() {
        z_btngift.isSelected = !z_btngift.isSelected
        if z_btngift.isSelected {
            self.func_showgiftview()
        } else {
            self.func_dismissgiftview()
        }
    }
    @objc private func func_btnrechargeclick() {
        z_btnrecharge.isSelected = !z_btnrecharge.isSelected
        if z_btnrecharge.isSelected {
            self.func_showrechargeview()
        } else {
            self.func_dismissrechargeview()
        }
    }
    final func func_showrechargeview() {
        self.z_btngift.isSelected = false
        self.inputTextRecharges.becomeFirstResponder()
    }
    final func func_dismissrechargeview() {
        self.inputTextView.becomeFirstResponder()
    }
    final func func_showgiftview() {
        self.z_btngift.isSelected = false
        self.inputTextGifts.becomeFirstResponder()
    }
    final func func_dismissgiftview() {
        self.inputTextView.becomeFirstResponder()
    }
    final func func_dismissview() {
        self.inputTextView.resignFirstResponder()
        self.inputTextGifts.resignFirstResponder()
        self.inputTextRecharges.resignFirstResponder()
    }
}
