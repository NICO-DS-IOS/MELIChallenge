struct SearchResponse : Decodable {
    let results:[Product]
}

struct SearchResponsePagingInfo : Decodable {
    let total:Int
    let offset:Int
}

struct Product : Decodable {
    let id:String
    let title:String
    let thumbnail:String
    let price:Float
}
