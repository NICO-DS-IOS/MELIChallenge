@testable import MercadoNicoLibre

extension Product {
    static func getMock() -> Product {
        Product(id: "MockedProductId", title: "MockTitle", thumbnail: "http://http2.mlstatic.com/D_933952-MLU54850211467_042023-I.jpg", price: 100.1)
    }
    
    func equals(item:Product) -> Bool {
        id == item.id &&
        title == item.title &&
        thumbnail == item.thumbnail &&
        price == item.price
    }
}
