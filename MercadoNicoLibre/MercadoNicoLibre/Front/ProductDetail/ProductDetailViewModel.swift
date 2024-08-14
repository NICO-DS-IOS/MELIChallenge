import Foundation

protocol ProductDetailViewModel {
    var setViewData: Dynamic<ProductViewObject?> { get }
    func viewDidLoad()
}

enum ProductField : String, CaseIterable {
    case price = "Precio"
    case condition = "Condición"
    case quantity = "Cantidad disponible"
    case acceptsMercadoPago = "Acepta Mercadopago"
    case warranty = "Garantía"
    case creationDate = "Creado"
    case modifiedDate = "Última modificación"
}

final class ProductDetailViewModelImpl : ProductDetailViewModel {
    
    
    private let rawData:ItemDetailResponse
    
    let setViewData:Dynamic<ProductViewObject?> = Dynamic(nil)
    
    init (response:ItemDetailResponse) {
        rawData = response
    }
    
    func viewDidLoad() {
        setViewData.value = parseRawData()
    }
    
    private func parseRawData() -> ProductViewObject {
        
        var productDataRows:[ProductInfoViewObject] = []
        
        productDataRows.append(contentsOf: [ProductInfoViewObject(description: ProductField.price.rawValue, value: "$ " + String(rawData.price)),
                                            ProductInfoViewObject(description: ProductField.condition.rawValue, value: rawData.condition.capitalized),
                                            ProductInfoViewObject(description: ProductField.quantity.rawValue, value: String(rawData.initial_quantity) + "Unidades"),
                                            ProductInfoViewObject(description: ProductField.acceptsMercadoPago.rawValue, value: rawData.accepts_mercadopago ? "Si" : "No"),
                                            ProductInfoViewObject(description: ProductField.warranty.rawValue, value: rawData.warranty ?? "")])
        productDataRows.append(contentsOf: parseAttributes(attributes: rawData.attributes))
        productDataRows.append(contentsOf: [ProductInfoViewObject(description: ProductField.creationDate.rawValue, value: formatDate(rawData.date_created)),
                                            ProductInfoViewObject(description: ProductField.modifiedDate.rawValue, value: formatDate(rawData.last_updated))])
        
        return ProductViewObject(title: rawData.title.capitalized, pictures: rawData.pictures.map{ $0.url }, attributes: productDataRows)
        
    }
    
    private func parseAttributes(attributes:[ItemDetailAttribute]) -> [ProductInfoViewObject] {
        var attributesViewObject:[ProductInfoViewObject] = []
        attributes.forEach { attribute in
            attributesViewObject.append(ProductInfoViewObject(description: attribute.name, value: attribute.value_name ?? "") )
        }
        return attributesViewObject.reversed()
    }
    
    private func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        let movDate = dateFormatter.date(from: date)
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: movDate ?? Date())
    }
    
}
