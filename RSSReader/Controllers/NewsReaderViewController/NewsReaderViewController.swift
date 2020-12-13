
import UIKit

class NewsReaderViewController: UIViewController {
    
    let newsText : UITextView = {
        let newsText = UITextView()
        newsText.isEditable = false
        newsText.textAlignment = .left
        newsText.translatesAutoresizingMaskIntoConstraints = false
        return newsText
    }() 
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(newsText)
        view.addSubview(activityIndicator)
        
        constraints ()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func constraints () {
        
        activityIndicator.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true

        newsText.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        newsText.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 3).isActive = true
        newsText.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -4).isActive = true
        newsText.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
    }
}
