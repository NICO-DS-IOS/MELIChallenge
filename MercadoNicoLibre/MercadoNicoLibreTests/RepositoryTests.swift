import XCTest
@testable import MercadoNicoLibre

final class RepositoryTests: XCTestCase {
    
    var repo:Repository?

    override func tearDownWithError() throws {
        repo = nil
    }

    func testBasicSearch() async throws {
        repo = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let result =  await repo?.searchItems(query: "Escoba")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .success(let response):
            XCTAssertNotNil(response)
            XCTAssertTrue(response.results.count > 0)
            XCTAssertNotNil(response.results.first { $0.id == "MLU618964200"})
        default:
            XCTFail("Unexpected response")
        }
    }
    
    func testEmptySearch() async throws {
        repo = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let result =  await repo?.searchItems(query: "")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .success(let response):
            XCTAssertTrue(response.results.count == 0)
        default:
            XCTFail("Unexpected response")
        }
    }
    
    func testEmptyResultSearch() async throws {
        repo = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let result =  await repo?.searchItems(query: "Escoba999999")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .success(let response):
            XCTAssertTrue(response.results.count == 0)
        default:
            XCTFail("Unexpected response")
        }
    }
    
    func testIncorrectUrlSearch() async throws {
        repo = RepositoryImpl(baseUrl: "www.google.com")
        let result =  await repo?.searchItems(query: "Escoba999999")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .error(let error, _):
            XCTAssertTrue(error == .requestError)
        default:
            XCTFail("Unexpected response")
        }
    }
    
    func testBasicItemSearch() async throws {
        repo = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let result =  await repo?.getItemDetail(itemId: "MLU678810726")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .success(let response):
            XCTAssertNotNil(response)
            XCTAssertFalse(response.title.isEmpty)
        default:
            XCTFail("Unexpected response")
        }
        
    }
    
    func testIncorrectItemSearch() async throws {
        repo = RepositoryImpl(baseUrl: AppConstants.BASE_URL)
        let result =  await repo?.getItemDetail(itemId: "MLU")
        
        XCTAssertNotNil(result)
        
        switch(result) {
        case .error(let error, _):
            XCTAssertTrue(error == .requestError)
        default:
            XCTFail("Unexpected response")
        }
        
    }
    
    func testMockConsistency() async throws{
        repo = MockRepository()
        let detailResult =  await repo?.getItemDetail(itemId: "item")
        let searchResult =  await repo?.searchItems(query: "query")
        
        XCTAssertNotNil(detailResult)
        XCTAssertNotNil(searchResult)
        
        switch(searchResult) {
        case .success(let response):
            XCTAssertNotNil(response)
            XCTAssertTrue(response.results.count == 2)
            if let firstResult = response.results.first {
                XCTAssertTrue(firstResult.equals(item: Product.getMock()))
            } else {
                XCTFail("Unexpected item count in testMockConsistency")
            }
            
        default:
            XCTFail("Unexpected response")
        }
        
        switch(detailResult) {
        case .success(let response):
            XCTAssertNotNil(response)
            XCTAssertTrue(response.equals(item: ItemDetailResponse.getMock()))
        default:
            XCTFail("Unexpected response")
        }
    }
}
