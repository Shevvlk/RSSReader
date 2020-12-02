
import RealmSwift

// Модели данных

// MARK: - Модель данных одной новости
class Model: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var date = ""
    @objc dynamic var depiction = ""
    @objc dynamic var cell = false
    
    convenience init (_ title: String,_ date: String , _ depiction: String ){
        self.init()
        self.title = title
        self.date = date
        self.depiction = depiction
    }
}

// MARK: - Модель различных каналов новостей
class Channel: Object {
    
    @objc dynamic var urlAddress = ""
    @objc dynamic var nameurl = ""
    @objc dynamic var lastOpenChannel = false
    var arrayModels = List<Model>()
    
    convenience init (_ nameurl: String,_ urlAddress: String){
        self.init()
        self.urlAddress = urlAddress
        self.nameurl = nameurl
    }
    
    override static func primaryKey () -> String {
        return "urlAddress"
    }
}
