
import RealmSwift

final class AddManager: AddManagerProtocol {
    
    private let storageManager: StorageManager
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    /// Парсинг новостей по URL
    func parsingArticles (_ urlAddress: String) -> [News] {
        let url = URL(string: urlAddress)
        let rssParser = RssParser()
        let arrayNews = rssParser.startParsingWithContentsOfURL(url: url!)
        return arrayNews
    }
    
    ///  Добавление нового канала  или  вызов обработчика завершения если канал уже есть в списке
    func addingСhannels(_ nameUrl: String, _ urlAddress: String, _ completionHandler: @escaping () -> Void) {
        
        guard storageManager.searchChannelByURL(urlAddress) == nil
        else {
            storageManager.rewritingOpenChannels(urlAddress)
            completionHandler()
            return
        }
        let channel = Channel(nameUrl, urlAddress)
        let arrayNews = parsingArticles(urlAddress)
        storageManager.saveNewChannelAndNewNews(channel, arrayNews)
    }
    
    /// Добавление новых новостей
    func addingNewArticles (_ urlAddress: String) {
        let arrayNews = parsingArticles(urlAddress)
        guard let channel = storageManager.searchChannelByURL(urlAddress) else {return}
        
        var arrayNewNews = [News]()
        
        for news in arrayNews {
            if storageManager.comparisonOfArticles(news.title) {
                arrayNewNews.append(news)
            }else {
            }
        }
        if !arrayNewNews.isEmpty {
            storageManager.saveNewChannelAndNewNews(channel, arrayNewNews)
        }
    }
    
    /// Пересохранение метки просмотренных новостей
    func openNews (_ channel : Channel, _ indexPathRow : Int) {
        storageManager.rewritingOpenNews(channel, indexPathRow)
    }
    
    /// Пересохранение метки выбранных каналов
    func openChannels (_ urlAddress: String) {
        storageManager.rewritingOpenChannels(urlAddress)
    }
    
    /// Удаление канала
    func deleteChannel(_ channel: Channel, _ token: [NotificationToken]) {
        storageManager.deleteChannel(channel, token)
    }
}
