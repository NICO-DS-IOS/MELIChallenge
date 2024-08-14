import UIKit
import MBProgressHUD

final class ProductDetailViewController : UIViewController {
    
    private var customView:ProductDetailView?
    
    var viewModel: ProductDetailViewModel? {
        didSet {
            fillUI()
        }
    }
    
    override func loadView() {
        customView = ProductDetailView()
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        
    }
    
    private func fillUI() {
        viewModel?.setViewData.bind{ [weak self] data in
            guard let safeData = data else { return }
            self?.customView?.setData(data: safeData)
        }
    }
}
