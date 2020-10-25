import Foundation
import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    var imageLoader = ImageLoader()
    var prodTitle: String = ""
    var prodPrice: String = ""
    var prodImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = prodTitle
        productPrice.text = "PRICE: \(prodPrice)"
        
        DispatchQueue.global().async {
            self.imageLoader.obtainImageWithPath(imagePath: "https:\(self.prodImg)") { (image) in
                self.productImg.image = image
                
                }
        }
    }
}
