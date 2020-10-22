import Foundation

protocol ProductsManagerDelegate {
    func didUpdateProduct(_ productsManager: ProductsManager, product: Products)
    func didFailWithError(error: Error)
}

struct ProductsManager {
    let mainURL = K.URLs.mainUrl
    
     var delegate: ProductsManagerDelegate?
     
     func fetchProducts() {
        let urlString = "\(mainURL)\(K.URLs.getProducts)"
         performRequest(with: urlString)
     }

     
     func performRequest(with urlString: String) {
         if let url = URL(string: urlString) {
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
