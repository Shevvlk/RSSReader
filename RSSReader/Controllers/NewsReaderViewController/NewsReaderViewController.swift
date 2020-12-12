
import UIKit

class NewsReaderViewController: UIViewController {
    
    var newsText : UITextView = {
        let newsText = UITextView()
        newsText.isEditable = false
        newsText.font = UIFont(name: "Verdana", size: 25)
        newsText.textAlignment = .left
        newsText.translatesAutoresizingMaskIntoConstraints = false
        
        return newsText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(newsText)
        
        constraints ()
    }

    func constraints () {
        newsText.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        newsText.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 3).isActive = true
        newsText.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -3).isActive = true
        newsText.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
    }
}
