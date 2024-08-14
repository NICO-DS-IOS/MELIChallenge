struct ItemDetailResponse : Decodable {
    var title:String
    var condition:String
    var price:Double
    var initial_quantity:Int
    var pictures:[ItemDetailPicture]
    var accepts_mercadopago:Bool
    var warranty:String?
    var date_created:String
    var last_updated:String
    var attributes:[ItemDetailAttribute]
}

struct ItemDetailPicture : Decodable {
    var url:String
}

struct ItemDetailAttribute : Decodable {
    var name:String
    var value_name:String?
}
