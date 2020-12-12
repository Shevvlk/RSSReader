
import RealmSwift

/// Модель данных канала
class Channel: Object {
    
    @objc dynamic var urlAddress = ""
    @objc dynamic var nameurl = ""
    @objc dynamic var lastOpenChannel = false
    var arrayNews = List<News>()
    
    convenience init (_ nameurl: String,_ urlAddress: String){
        self.init()
        self.urlAddress = urlAddress
        self.nameurl = nameurl
    }
    
    override static func primaryKey () -> String {
        return "urlAddress"
    }
}
