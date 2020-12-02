

import RealmSwift

// MARK: - Класс для добавления и обновления статей

class AddManager {
    
    // Парсинг статей
    func parsingArticles (_ urlAddress: String) -> [Model] {
        let url = URL(string: urlAddress)
        let rssParser = RssParser()
        let arrayModels = rssParser.startParsingWithContentsOfURL(url: url!)
        return arrayModels
    }
    
    // Добавление нового канала
    func addingСhannels(_ nameUrl: String, _ urlAddress: String) {
        let channel = Channel(nameUrl, urlAddress)
        let arrayModels = parsingArticles(urlAddress)
        let storege = StorageManager()
        storege.initializationRealm()
        storege.saveNewChannel(channel, arrayModels)
    }
    
    // Добавление новых статей
    func addingNewArticles (_ urlAddress: String) {
        
        let arrayModels = parsingArticles(urlAddress)
        
        let storege = StorageManager()
        
        guard let channel = storege.searchChannelByURL(urlAddress) else {return}
        
        var arrModel = [Model]()
        
        for model in arrayModels {
            if storege.comparisonOfArticles(model.title) {
                arrModel.append(model)
            }
        }
        if !arrModel.isEmpty {
            storege.saveNewArticlesChannel(channel, arrModel)
        }
    }
}
