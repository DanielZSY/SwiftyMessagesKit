
import UIKit

public class ZMessageButton: UIButton, InputItem {
    
    public var inputBarAccessoryView: InputBarAccessoryView?
    public var parentStackViewPosition: InputStackView.Position?
    
    public func textViewDidChangeAction(with textView: InputTextView) {
        
    }
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        
    }
    public func keyboardEditingEndsAction() {
        
    }
    public func keyboardEditingBeginsAction() {
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHighlighted = false
        self.adjustsImageWhenHighlighted = false
        self.isUserInteractionEnabled = true
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
