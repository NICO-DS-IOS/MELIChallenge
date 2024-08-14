
protocol SearchViewModel{
    var setViewTitle: Dynamic<String?> { get }
    var showLoading: Dynamic<Void> { get }
    var hideLoading: Dynamic<Void> { get }
    var updateStatusMessage: Dynamic<(Bool,String?)> { get }
    var reloadView:Dynamic<Void> { get }
    var navigateToDetailView: Dynamic<ItemDetailResponse?> { get }
    var showItemLoadError: Dynamic<String?> { get }
    
    func viewDidLoad()
    func getResultsCount() -> Int
    func getResultAt(index:Int) -> SearchViewObject?
    func onSearchTextChanged(text:String?)
    func onSearchRequested()
    func onItemTapped(item:SearchViewObject)
    
}

final class SearchViewModeImpl : SearchViewModel {
    
    let setViewTitle: Dynamic<String?> = Dynamic(nil)
    let showLoading:Dynamic<Void> = Dynamic(())
    let hideLoading:Dynamic<Void> = Dynamic(())
    let updateStatusMessage:Dynamic<(Bool,String?)> = Dynamic((false, nil))
    let reloadView:Dynamic<Void> = Dynamic(())
    let navigateToDetailView: Dynamic<ItemDetailResponse?> = Dynamic(nil)
    var showItemLoadError: Dynamic<String?> = Dynamic(nil)
    
    private var currentSearch:String? = nil
    private var data: [SearchViewObject]? = nil
    private var repository: Repository
    
    init (repository:Repository) {
        self.repository = repository
    }

    func executeSearch () {
        let genericErrorMessage = "Ocurrió un problema al buscar los resultados."
        
        Task { [weak self] in
            guard let strongSelf = self else {
                self?.updateStatusMessage.setValueAtMain(value:(true, genericErrorMessage))
                return
            }
            
            strongSelf.showLoading.executeMain()
            let result = await strongSelf.repository.searchItems(query: strongSelf.currentSearch ?? "")
            strongSelf.hideLoading.executeMain()
            
            switch (result) {
            case .success(let response):
                
                if response.results.isEmpty {
                    strongSelf.updateStatusMessage.setValueAtMain(value: (true, "No se encontraron resultados."))
                } else {
                    strongSelf.updateStatusMessage.setValueAtMain(value: (false, nil))
                }
                
                strongSelf.data = strongSelf.parseResponse(response: response)
                strongSelf.reloadView.executeMain()
            default:
                strongSelf.updateStatusMessage.setValueAtMain(value:(true, genericErrorMessage))
            }
        }
    }
    
    private func loadItemData(productId:String?) {
        
        guard let productId = productId else { return } //Handle error
        showLoading.executeMain()
        
        Task{ [weak self] in
            guard let strongSelf = self else { return }
            
            let result = await strongSelf.repository.getItemDetail(itemId: productId )
            
            strongSelf.hideLoading.executeMain()
            
            switch (result) {
            case .success(let response):
                strongSelf.navigateToDetailView.setValueAtMain(value: response)
            default:
                strongSelf.showItemLoadError.setValueAtMain(value: "Ocurrió un error al intentar obtener detalles de el Item")
            }
        }
    }
    
    private func parseResponse(response:SearchResponse) -> [SearchViewObject]{
        var viewObjects:[SearchViewObject] = []
        response.results.forEach { row in
            viewObjects.append(SearchViewObject(id: row.id, title: row.title , price: "$ " + String(row.price), thumbNailUrl: row.thumbnail))
        }
        return viewObjects
    }
    
    func viewDidLoad() {
        setViewTitle.setValueAtMain(value: "Mercado")
        updateStatusMessage.setValueAtMain(value: (true, "Hola!\nComienza tu búsqueda escribiendo arriba.")) 
    }
    
    func getResultsCount() -> Int {
        return data?.count ?? 0
    }
    
    func getResultAt(index:Int) -> SearchViewObject? {
        return data?[index]
    }
    
    func onSearchTextChanged(text:String?) {
        currentSearch = text
    }
    
    func onSearchRequested() {
        executeSearch()
    }
    
    func onItemTapped(item:SearchViewObject){
        loadItemData(productId: item.id)
    }
}
