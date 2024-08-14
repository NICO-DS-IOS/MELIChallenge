@testable import MercadoNicoLibre

class ProductDetailViewMock{
    
    var viewData:ProductViewObject?

    var viewModel: ProductDetailViewModel? {
        didSet {
            connectUIToModel()
        }
    }
    
    func connectUIToModel() {
        guard let model = viewModel else { return }
        
        model.setViewData.bindForTests { [weak self] value in
            self?.viewData = value
        }
    }
    
    func viewFinishedLoading() {
        viewModel?.viewDidLoad()
    }
}

