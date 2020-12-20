
import UIKit

class PreceptBackgroundView : UIView {
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 10
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let firstString = "Список Rss каналов пуст\n\n"
        let secondString  = "Для добавления Rss канала перейдите в слайд меню"
       
        let combination = NSMutableAttributedString()

        var partOne = NSMutableAttributedString()
        
        var partTwo = NSMutableAttributedString()
        
        
        let attrOne = [NSAttributedString.Key.font : UIFont(name: "Geeza Pro", size: 25)]

        let attrTwo: Dictionary = [NSAttributedString.Key.font : UIFont(name: "Geeza Pro", size: 20)]
        
        if let attrOne = attrOne as? [NSAttributedString.Key : NSObject]{
            partOne = NSMutableAttributedString(string: firstString, attributes: attrOne)

        }
        if let attrTwo = attrTwo as? [NSAttributedString.Key : NSObject] {
            partTwo = NSMutableAttributedString(string: secondString , attributes: attrTwo)
        }
        
        combination.append(partOne)
        combination.append(partTwo)
        
        labelDescription.attributedText = combination
        
        self.addSubview(labelDescription)
        
        labelDescription.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -30).isActive = true
        labelDescription.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
