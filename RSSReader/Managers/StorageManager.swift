
import RealmSwift


class StorageManager {
    
    private var realm: Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Добаление новых каналов и обновление новых новостей
    func saveNewChannelAndNewNews ( _ channel : Channel, _ arrayNews: [News] ) {
        if let channel = searchChannelByURL(channel.urlAddress) {
            try! realm?.write {
                channel.arrayNews.insert(contentsOf: arrayNews, at: 0)
            }
        } else {
            try! realm?.write {
                channel.arrayNews.append(objectsIn: arrayNews)
                realm?.add(channel)
            }
            rewritingOpenChannels(channel.urlAddress)
        }
    }
    
    /// Удаление канала
    func deleteChannel ( _ channel : Channel, _ token: [NotificationToken]) {
        try! realm?.write(withoutNotifying: token) {
            realm?.delete(channel.arrayNews)
            realm?.delete(channel)
        }
    }
    
    /// Поиск канала по URL
    func searchChannelByURL (_ urlAddress: String) -> Channel?  {
        return realm?.object(ofType: Channel.self, forPrimaryKey:  urlAddress)
    }
    
    /// Пересохранение метки выбранных каналов
    func rewritingOpenChannels (_ urlAddress: String) {
        
        guard let channel = searchChannelByURL(urlAddress) else { return }
        
        let channelfirst = realm?.objects(Channel.self).filter("lastOpenChannel == true")
        
        try! realm?.write {
            channelfirst?.first?.lastOpenChannel = false
            channel.lastOpenChannel = true
        }
    }
    
    /// Пересохранение метки просмотренных новостей
    func rewritingOpenNews ( _ channel : Channel, _ indexPathRow : Int ) {
        try! realm?.write {
            channel.arrayNews[indexPathRow].viewedNews = true
        }
    }
    
    /// Поиск по заголовку
    func comparisonOfArticles ( _ title: String) -> Bool {
        guard let channelPredicateWithNews = realm?.objects(Channel.self).filter("ANY arrayNews.title == '\(title)'") else {
            return false
        }
        return channelPredicateWithNews.isEmpty
    }
}
