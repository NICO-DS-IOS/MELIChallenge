import XCTest
@testable import MercadoNicoLibre

final class SearchViewModelTests: XCTestCase {
    
    var viewModel:SearchViewModel?
    var mockView:SearchViewMock?
    
    override func setUp() {
        viewModel = SearchViewModeImpl(repository: MockRepository())
        mockView =  SearchViewMock()
        mockView?.viewModel = viewModel
        mockView?.viewFinishedLoading()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockView =  nil
    }
    
    func testInitialViewState() {
        guard let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        XCTAssertFalse(safeMockView.title?.isEmpty ?? false)
        XCTAssertFalse(safeMockView.showingLoading)
        XCTAssertFalse(safeMockView.statusMessage.isEmpty)
        XCTAssertTrue(safeMockView.statusMessageVisibility)
        XCTAssertTrue(safeMockView.currentDataCount == 0)
        XCTAssertFalse(safeMockView.navigatedToDetailView)
        XCTAssertNil(safeMockView.navigatedToDetailItem)
        
    }
    
    func testStateAfterSearch() {
        guard let safeViewModel = viewModel, let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        safeViewModel.onSearchTextChanged(text: "Test")
        safeViewModel.onSearchRequested()
        sleep(2)
        
        if let safeResult = safeMockView.viewModel?.getResultAt(index: 0) {
            XCTAssertTrue(safeResult.title == Product.getMock().title)
        }else{
            XCTFail("testStateAfterSearch doesn't have products when it should")
        }
        
        
        XCTAssertFalse(safeMockView.title?.isEmpty ?? false)
        XCTAssertTrue(safeMockView.statusMessage.isEmpty)
        XCTAssertFalse(safeMockView.statusMessageVisibility)
        XCTAssertTrue(safeMockView.currentDataCount > 0)
        XCTAssertFalse(safeMockView.navigatedToDetailView)
        XCTAssertNil(safeMockView.navigatedToDetailItem)
        XCTAssertNil(safeMockView.itemLoadErrorMessage)
        
    }
    
    func testStateAfterEmptySearch() {
        guard let safeViewModel = viewModel, let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        safeViewModel.onSearchTextChanged(text: "")
        safeViewModel.onSearchRequested()
        sleep(2)
        
        XCTAssertFalse(safeMockView.statusMessage.isEmpty)
        XCTAssertTrue(safeMockView.statusMessageVisibility)
        XCTAssertTrue(safeMockView.currentDataCount == 0)
        
    }
    
    func testStateAfterNavigation() {
        guard let safeViewModel = viewModel, let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        safeViewModel.onSearchTextChanged(text: "Test")
        safeViewModel.onSearchRequested()
        sleep(2)
        if let safeResult = viewModel?.getResultAt(index: 0) {
            safeViewModel.onItemTapped(item: safeResult)
        } else {
            XCTFail("testStateAfterNavigation should have items in the model")
        }
        sleep(1)
        
        XCTAssertTrue(safeMockView.navigatedToDetailView)
        XCTAssertNotNil(safeMockView.navigatedToDetailItem)
        XCTAssertTrue(safeMockView.navigatedToDetailItem?.title == viewModel?.getResultAt(index: 0)?.title)
        
    }
    
    func testStateAfterError() {
        
        viewModel = SearchViewModeImpl(repository: MockRepositoryError())
        mockView =  SearchViewMock()
        mockView?.viewModel = viewModel
        mockView?.viewFinishedLoading()
        
        guard let safeViewModel = viewModel, let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        safeViewModel.onSearchTextChanged(text: "")
        safeViewModel.onSearchRequested()
        sleep(2)
        
        XCTAssertFalse(safeMockView.statusMessage.isEmpty)
        XCTAssertTrue(safeMockView.statusMessageVisibility)
        XCTAssertTrue(safeMockView.currentDataCount == 0)
        
    }
    
    func testStateAfterLoadItemError() {
        
        viewModel = SearchViewModeImpl(repository: MockRepositoryError())
        mockView =  SearchViewMock()
        mockView?.viewModel = viewModel
        mockView?.viewFinishedLoading()
        
        guard let safeViewModel = viewModel, let safeMockView = mockView else {
            XCTFail("Failure in mocks instances")
            return
        }
        
        safeViewModel.onItemTapped(item: SearchViewObject.init(id: "Test", title: "test", price: "test", thumbNailUrl: "test.com"))
        sleep(2)
        
        XCTAssertNotNil(safeMockView.itemLoadErrorMessage)
        
    }
}
