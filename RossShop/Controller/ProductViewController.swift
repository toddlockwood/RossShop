import UIKit

class ProductViewController: UITableViewController {

    var products = Products()
    var productsManager = ProductsManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        productsManager.delegate = self
        productsManager.fetchProducts()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.data?.products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        
        let product = products.data?.products?[indexPath.row]
        
        let urlMini : String = (product?.pictures?[0].mini ?? "") as String
        DispatchQueue.main.async {         let url = NSURL(string: "https:\(urlMini)")
            let imagedata = NSData.init(contentsOf: url! as URL)

            if imagedata != nil {
                cell.imageView?.image = UIImage(data:imagedata! as Data)
            }}

        cell.textLabel?.text = product?.brand
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }

}

extension ProductViewController: ProductsManagerDelegate {
    func didUpdateProduct(_ productsManager: ProductsManager, product: Products) {
        products = product
        tableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


