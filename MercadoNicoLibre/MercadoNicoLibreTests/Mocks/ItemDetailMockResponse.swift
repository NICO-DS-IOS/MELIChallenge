@testable import MercadoNicoLibre

extension ItemDetailResponse {
    static func getMock() -> ItemDetailResponse {
        ItemDetailResponse(title: "MockTitle",
                           condition: "MockDetailCondition",
                           price: 100,
                           initial_quantity: 100,
                           pictures: [ItemDetailPicture (url:"http://http2.mlstatic.com/D_933952-MLU54850211467_042023-I.jpg" )],
                           accepts_mercadopago: true,
                           date_created: "2022-09-24T16:57:26.000Z",
                           last_updated: "2024-08-14T02:12:28.146Z",
                           attributes: [
                            ItemDetailAttribute(name: "MockAttribute", value_name: "MockattributeValue")
                           ])
    }
    
    func equals(item:ItemDetailResponse) -> Bool {
        title == item.title &&
        condition == item.condition &&
        price == item.price &&
        initial_quantity == item.initial_quantity &&
        comparePictures(itemPictures: item.pictures) &&
        accepts_mercadopago == item.accepts_mercadopago &&
        date_created == item.date_created &&
        last_updated == item.last_updated &&
        price == item.price &&
        compareAttributes(attributes: item.attributes)
    }
    
    private func comparePictures(itemPictures:[ItemDetailPicture]) -> Bool {
        guard pictures.count == itemPictures.count else { return false }
        var areEqual = true
        pictures.enumerated().forEach { index, value in
            if value.url != itemPictures[index].url{
                areEqual = false
            }
        }
        return areEqual
    }
    
    private func compareAttributes(attributes:[ItemDetailAttribute]) -> Bool {
        guard  self.attributes.count == attributes.count else { return false }
        var areEqual = true
        attributes.enumerated().forEach { index, value in
            let currentItem = attributes[index]
            if value.name != currentItem.name || value.value_name != currentItem.value_name {
                areEqual = false
            }
        }
        return areEqual
    }
}
