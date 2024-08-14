import XCTest
@testable import MercadoNicoLibre

final class ProductDetailViewModelTests: XCTestCase {
    
    var viewModel:ProductDetailViewModel?
    var mockView:ProductDetailViewMock?
    
    override func setUp() {
        viewModel = ProductDetailViewModelImpl(response: ItemDetailResponse.getMock())
        mockView =  ProductDetailViewMock()
        mockView?.viewModel = viewModel
        mockView?.viewFinishedLoading()
    }
    
    func testDataIsCorrectlyDisplayed(){
        
        guard let viewData = mockView?.viewData else {
            XCTFail("testDataIsCorrectlyDisplayed view should have view Object ready")
            return
        }
        XCTAssertTrue( viewData.correspondsTo(response: ItemDetailResponse.getMock()))
        
    }
}
