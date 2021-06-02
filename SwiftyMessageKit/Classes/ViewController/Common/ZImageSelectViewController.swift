
import UIKit
import SwiftBasicKit

class ZImageSelectViewController: ZImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ZColor.shared.ViewBackgroundColor
        self.navigationController?.navigationBar.tintColor = ZColor.shared.NavBarButtonColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ZColor.shared.NavBarTitleColor]
    }
}
