@testable import MercadoNicoLibre

class SearchViewMock : SearchView {
    
    //View State
    var title:String?
    var showingLoading = false
    var statusMessageVisibility = false
    var statusMessage = ""
    var currentDataCount:Int = 0
    var navigatedToDetailView:Bool = false
    var navigatedToDetailItem:ItemDetailResponse?
    var itemLoadErrorMessage:String?
    
    var viewModel: SearchViewModel? {
        didSet {
            connectUIToModel()
        }
    }
    
    func connectUIToModel() {
        guard let model = viewModel else { return }
        
        model.setViewTitle.bindForTests { [weak self] value in
            self?.title = value
        }
        
        model.showLoading.bindForTests { [weak self] in
            self?.showingLoading = true
        }
        
        model.hideLoading.bindForTests { [weak self] in
            self?.showingLoading = false
        }
        
        model.updateStatusMessage.bindForTests { [weak self] visible, value in
            self?.statusMessageVisibility = visible
            self?.statusMessage = value ?? ""
        }
        
        model.reloadView.bindForTests { [weak self] in
            self?.currentDataCount = self?.viewModel?.getResultsCount() ?? 0
        }
        
        model.navigateToDetailView.bindForTests { [weak self]  data in
            self?.navigatedToDetailView = true
            self?.navigatedToDetailItem = data
        }
        
        model.showItemLoadError.bindForTests{ [weak self] message in
            self?.itemLoadErrorMessage = message
        }
    }
    
    
    func viewFinishedLoading() {
        viewModel?.viewDidLoad()
    }
}
