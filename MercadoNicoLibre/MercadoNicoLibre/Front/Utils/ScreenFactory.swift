import Foundation

struct ScreenFactory {
    
    static func createSearchView() -> SearchViewController {
        let repository = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let concreteModel = SearchViewModeImpl(repository: repository)
        let view = SearchViewController()
        view.viewModel = concreteModel
        return view
    }
    
    static func createDetailViewController(data:ItemDetailResponse) -> ProductDetailViewController {
        let concreteModel = ProductDetailViewModelImpl(response: data)
        let view = ProductDetailViewController()
        view.viewModel = concreteModel
        return view
    }
    
    
}
