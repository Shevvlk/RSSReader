
import UIKit
import RealmSwift

protocol AddManagerProtocol {
    func addingNewArticles (_ urlAddress: String)
    
    func parsingArticles (_ urlAddress: String) -> [News]

    func addingСhannels(_ nameUrl: String, _ urlAddress: String, _ completionHandler: @escaping () -> Void)
    
    func openNews ( _ channel : Channel, _ indexPathRow : Int )
    
    func openChannels (_ urlAddress: String)

    func deleteChannel ( _ channel : Channel, _ token: [NotificationToken])
}
