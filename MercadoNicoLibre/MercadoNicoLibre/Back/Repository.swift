import Foundation

protocol Repository {
    func searchItems(query: String) async -> SearchResult
    func getItemDetail(itemId:String) async -> ItemDetailResult
}

enum SearchResult {
    case success(response:SearchResponse)
    case error(error:BackendError, description:String? = nil)
}

enum ItemDetailResult {
    case success(response:ItemDetailResponse)
    case error(error:BackendError, description:String? = nil)
}

enum BackendError : Error {
    case invalidUrl
    case requestError
    case parsingError
}


struct RepositoryImpl : Repository {
    private let baseUrl:String
    
    init (baseUrl:String) {
        self.baseUrl = baseUrl
    }

    func searchItems(query: String) async -> SearchResult {
        
        guard let safeUrl = buildSearchUrl(queryText: query) else { return SearchResult.error(error: .invalidUrl) }
        let request = URLRequest(url: safeUrl)
        
        do {
            let (data, _) =  try await URLSession.shared.data(for: request)
            let result =  try? JSONDecoder().decode(SearchResponse.self, from: data)
            
            guard let safeResult = result else { return SearchResult.error(error: .parsingError)}
            
            return SearchResult.success(response: SearchResponse( results: safeResult.results))
        } catch {
            return SearchResult.error(error: .requestError, description: error.localizedDescription)
        }
    }
    
    func getItemDetail(itemId:String) async ->  ItemDetailResult {
        guard let safeUrl = buildItemDetailUrl(itemId: itemId) else { return ItemDetailResult.error(error: .invalidUrl) }
        let request = URLRequest(url: safeUrl)
        
        do {
            let (data, _) =  try await URLSession.shared.data(for: request)
            let result =  try JSONDecoder().decode(ItemDetailResponse.self, from: data)
            
            return ItemDetailResult.success(response: result)
        } catch {
            return ItemDetailResult.error(error: .requestError, description: error.localizedDescription)
        }
    }
    
    private func buildSearchUrl(queryText:String) -> URL? {
        guard let safeParams = resolveSearchParams(queryText: queryText) else { return nil }
        return URL(string: [baseUrl, "sites", resolveSite(), "search", safeParams].joined(separator: "/"))
    }
    
    private func buildItemDetailUrl(itemId:String) -> URL? {
        return URL(string: [baseUrl, "items", itemId].joined(separator: "/"))
    }
    
    private func resolveSite() -> String {
        return "MLU"
    }
    
    private func resolveSearchParams(queryText:String) -> String? {
        guard let safeEncodedQuery = queryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        return "?q=\(safeEncodedQuery)"
    }
}
