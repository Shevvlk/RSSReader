
import RealmSwift

/// Модель данных новости
class News: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var date = ""
    @objc dynamic var depiction = ""
    @objc dynamic var viewedNews = false
    
    convenience init (_ title: String,_ date: String , _ depiction: String ){
        self.init()
        self.title = title
        self.date = date
        self.depiction = depiction
    }
}
