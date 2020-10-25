import UIKit

class ProductListViewController: UITableViewController {

    
    var products = Products()
    var productsManager = ProductsManager()
    var imageLoader = ImageLoader()
    var page = 0
    var isLoading = false
    
    var activityIndicatorView: UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = activityIndicatorView
        
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingcellid")
         
        
        productsManager.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (products.data?.products == nil) {
            activityIndicatorView.startAnimating()
            tableView.separatorStyle = .none

            DispatchQueue.global().async {
                self.productsManager.fetchProducts(page: self.page)
            }
            
            dispatchQueue.async {
                OperationQueue.main.addOperation() {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return products.data?.products?.count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = products.data?.products?[indexPath.row]
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
            tableView.rowHeight = UITableView.automaticDimension
            cell.textLabel?.numberOfLines = 4
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            let urlMini : String = (product?.pictures?[0].mini ?? "") as String
            
            DispatchQueue.global().async {
                self.imageLoader.obtainImageWithPath(imagePath: "https:\(urlMini)") { (image) in
                        if let cell = tableView.cellForRow(at: indexPath) {
                            cell.imageView?.image = image
                            cell.setNeedsLayout()
                        }
                    }
            }

            
            cell.textLabel?.text? = """
                                        \(product?.brand ?? "")
                                        \(product?.caption ?? "")
                                        \(product?.name ?? "")
                                        """

            cell.sizeToFit()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcellid", for: indexPath) as! LoadingCell
            cell.loadingCell.startAnimating()
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToProduct", sender: self)
    }
    
    fileprivate func prepareData(_ destinationVC: ProductViewController, _ price: String, _ indexPath: IndexPath) {
        destinationVC.prodPrice = price
        destinationVC.prodImg = self.products.data?.products?[indexPath.row].pictures?[0].large ?? ""
        destinationVC.prodTitle = self.products.data?.products?[indexPath.row].name ?? ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProductViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            guard let price = formatter.string(for: self.products.data?.products?[indexPath.row].price) else { return }
            prepareData(destinationVC, price, indexPath)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            page = page+1
            DispatchQueue.global().async {
                self.productsManager.fetchProducts(page: self.page)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }

}
extension ProductListViewController: ProductsManagerDelegate {
    func didUpdateProduct(_ productsManager: ProductsManager, product: Products) {
        if products.data == nil{
            products = product
        }else{
            products.data?.products?.append(contentsOf: (product.data?.products)!)
        }
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()
       }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


