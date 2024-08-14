
@testable import MercadoNicoLibre

extension ProductViewObject {
    func correspondsTo(response:ItemDetailResponse) -> Bool {
        response.title.lowercased() == title.lowercased() &&
        comparePictures(itemPictures: response.pictures)
    }
    
    private func comparePictures(itemPictures:[ItemDetailPicture]) -> Bool {
        guard pictures.count == itemPictures.count else { return false }
        var areEqual = true
        pictures.enumerated().forEach { index, value in
            if value != itemPictures[index].url {
                areEqual = false
            }
        }
        return areEqual
    }
    
}
