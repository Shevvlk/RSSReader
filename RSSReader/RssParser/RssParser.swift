
import UIKit

final class RssParser: NSObject, XMLParserDelegate {
    
    private struct CopyNews {
        var title:      String
        var date:       String
        var depiction:  String
    }
    
    private var parser:     XMLParser?
    private var copyNews:   CopyNews? = nil
    private var currentTag: String?
    private var arrayNews:  [News] = []
    
    private var isExpanded = false
    
    // MARK: - Запуск синтаксического анализа
    func startParsingWithContentsOfURL (url: URL) -> [News] {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        
        return arrayNews
    }
    
    private func parser(parser: XMLParser, parseErrorOccurred parseError: NSError) {
        print("parse error: \(parseError)")
    }
    
    private func parser(parser: XMLParser, validationErrorOccurred validationError: NSError!) {
        print(validationError.description)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentTag = elementName
        if elementName == "item" {
            copyNews = CopyNews(title: "", date: "", depiction: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if let copyNewsTwo = copyNews {
            
            switch currentTag {
            case "title":
                copyNews?.title = copyNewsTwo.title + string.replacingOccurrences(of: "\n", with: "")
                copyNews?.depiction = copyNewsTwo.depiction + string + "</p>"
            case "pubDate":
                if let date = dateRU(dateString: string)  {copyNews?.date = date}
            case "description":
                copyNews?.depiction = copyNewsTwo.depiction + string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            
            if let copyNewsTwo = copyNews {
                if copyNewsTwo.date == "" {
                    copyNews?.date = "Дата и время не установлены"
                }
                let news = News(copyNewsTwo.title, copyNewsTwo.date , copyNewsTwo.depiction)
                arrayNews.append(news)
            }
            
            copyNews = nil
        }
    }
    
    // Преобразование даты в стандарт RU
    private func dateRU (dateString: String) -> String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        formatter.locale = Locale(identifier: "RU")
        formatter.setLocalizedDateFormatFromTemplate("E, dd-MM-yyyy, HH:mm")
        
        let dateStringRU = formatter.string(from: date)
        
        return dateStringRU
    }
}
