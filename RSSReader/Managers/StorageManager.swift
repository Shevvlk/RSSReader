
import RealmSwift


class StorageManager {
    
    let realm = try! Realm()
    
    // Сохранение новых каналов
    
    func saveNewChannel ( _ channel : Channel, _ arrayModels: [Model] ) {
        try! realm.write {
            channel.arrayModels.append(objectsIn: arrayModels)
            realm.add(channel)
        }
        
    }
    
    // Сохранение новых новостей
    
    func saveNewArticlesChannel (_ channel: Channel, _ arrayModels: [Model] ) {
        try! realm.write {
            channel.arrayModels.insert(contentsOf: arrayModels, at: 0)
        }
    }
    
    // Удаление каналов
    
    func deleteChannel ( _ channel : Channel, _ token: [NotificationToken]) {
        try! realm.write(withoutNotifying: token) {
            realm.delete(channel.arrayModels)
            realm.delete(channel)
        }
    }
    
    // Поиск канала по URL
    
    func searchChannelByURL (_ urlAddress: String) -> Channel?  {
        
        return realm.object(ofType: Channel.self, forPrimaryKey:  urlAddress)
    }
    
    // Пересохранение метки выбранных каналов
    
    func preservationOfOpenChannels (_ urlAddress: String) {
        
        guard let channel = searchChannelByURL(urlAddress) else { return }
        
        let channelfirst = realm.objects(Channel.self).filter("lastOpenChannel == true")
        
        try! realm.write {
            channelfirst.first?.lastOpenChannel = false
            channel.lastOpenChannel = true
        }
    }
    
    // Пересохранение метки новостей
    
    func rewritingAnOpenArticle ( _ channel : Channel, _ indexPathRow : Int ) {
        try! realm.write {
            channel.arrayModels[indexPathRow].cell = true
        }
    }
    
    // Поиск по дате
    
    func comparisonOfArticles ( _ title: String) -> Bool {
        
        let channelPredicateWithModels = realm.objects(Channel.self).filter("ANY arrayModels.title == '\(title)'")
        
        if channelPredicateWithModels.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    
}
