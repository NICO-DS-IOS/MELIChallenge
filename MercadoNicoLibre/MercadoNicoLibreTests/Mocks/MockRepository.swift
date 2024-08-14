
@testable import MercadoNicoLibre

struct MockRepository : Repository {
    
    func searchItems(query: String) async -> MercadoNicoLibre.SearchResult {
        SearchResult.success(response: query.isEmpty ? mockEmptySearchResponse() : mockSearchResponse())
    }
    
    func getItemDetail(itemId: String) async -> MercadoNicoLibre.ItemDetailResult {
        ItemDetailResult.success(response: mockProductDetailResponse())
    }
    
    private func mockSearchResponse() -> SearchResponse {
        SearchResponse(results: [Product.getMock(), Product.getMock()])
    }
    
    private func mockEmptySearchResponse() -> SearchResponse {
        SearchResponse(results: [])
    }
    
    private func mockProductDetailResponse() -> ItemDetailResponse {
        ItemDetailResponse.getMock()
    }
    
    
}


struct MockRepositoryError : Repository {
    
    func searchItems(query: String) async -> MercadoNicoLibre.SearchResult {
        SearchResult.error(error: .requestError, description: "Request Error")
    }
    
    func getItemDetail(itemId: String) async -> MercadoNicoLibre.ItemDetailResult {
        ItemDetailResult.error(error: .requestError, description: "Item Request error")
    }
    
}
