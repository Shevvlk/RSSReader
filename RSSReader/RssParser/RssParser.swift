
import UIKit


class RssParser: NSObject, XMLParserDelegate {
    
    struct CopyModel {
        var title:      String
        var date:       String
        var depiction:  String
    }
    
    var parser:       XMLParser?
    var copyModel:    CopyModel? = nil
    var currentTag:   String?
    var arrayModels:  [Model] = []
    
    var isExpanded = false
    
    // MARK: - Запуск синтаксического анализа
    func startParsingWithContentsOfURL (url: URL ) -> [Model] {
        
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        
        return arrayModels
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
            copyModel = CopyModel(title: "", date: "", depiction: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        if let copyModelTwo = copyModel {
            
            switch currentTag {
            
            case "title":
                copyModel?.title = copyModelTwo.title + string.replacingOccurrences(of: "\n", with: "")
                copyModel?.depiction = copyModelTwo.depiction + string
            case "pubDate":
                if let date = dateRU(dateString: string)  {copyModel?.date = date}
            case "description":
                copyModel?.depiction = copyModelTwo.depiction + string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            
            if let copyModelTwo = copyModel {
                if copyModelTwo.date == "" {
                    copyModel?.date = "Дата и время не установлены"
                }
                let model = Model(copyModelTwo.title, copyModelTwo.date , copyModelTwo.depiction)
                arrayModels.append(model)
            }
            
            copyModel = nil
        }
    }
    
    // Преобразование даты в стандарт RU
    func dateRU (dateString: String) -> String? {
        
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
