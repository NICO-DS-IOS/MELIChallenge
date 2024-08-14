import UIKit
import MBProgressHUD

extension UIImageView {
    
    func load(url: URL) {
        
        // TODO: move to a logic, testeable layer instead of ui component extension
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            backgroundColor = .clear
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self, animated: true)
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: strongSelf, animated: true)
                }
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        strongSelf.backgroundColor = .gray
                    }
                    
                }
            }).resume()
        }
    }
}
