import Foundation

protocol ProductsManagerDelegate {
    func didUpdateProduct(_ productsManager: ProductsManager, product: Products)
    func didFailWithError(error: Error)
}

struct ProductsManager {
    let mainURL = K.URLs.mainUrl
    var delegate: ProductsManagerDelegate?
     
    func fetchProducts(page: Int = 0) {
        let urlString = "\(mainURL)\(K.URLs.getProducts)"
        performRequest(with: urlString, page: page)
     }
     
     func performRequest(with urlString: String, page: Int = 0) {
        
        guard var urlComponents = URLComponents(string: "\(mainURL)\(K.URLs.getProducts)") else {
            return
        }
        urlComponents.query = "&Page=\(page)"
        
        if let url = urlComponents.url {
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil {
                     self.delegate?.didFailWithError(error: error!)
                     return
                 }
                 if let safeData = data {
                     if let product = self.parseJSON(safeData) {
                         self.delegate?.didUpdateProduct(self, product: product)
                     }
                 }
             }
             task.resume()
         }
     }
     
     func parseJSON(_ productsData: Data) -> Products? {
         let decoder = JSONDecoder()
         do {
             let decodedData = try decoder.decode(Products.self, from: productsData)
             return decodedData
             
         } catch {
             delegate?.didFailWithError(error: error)
             return nil
         }
     }
     
     
     
 }
