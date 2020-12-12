import UIKit

// MARK: - Настройка кастомной ячейки
class CustomMenuTableViewCell: UITableViewCell {
    
    /// Метка ячейки
    var markImage: UIImageView = {
        let mark = UIImageView()
        mark.image = UIImage(systemName: "checkmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        mark.translatesAutoresizingMaskIntoConstraints = false
        return mark
    }()
    
    /// Заголовок
    let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Geeza Pro", size: 18)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(markImage)
        contentView.addSubview(headingLabel)
        constraints ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constraints () {
        markImage.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 10).isActive = true
        markImage.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor,constant: 3).isActive = true
        markImage.widthAnchor.constraint(equalToConstant:20).isActive = true
        markImage.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant: -10).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo:self.markImage.trailingAnchor, constant: 4).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -80).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor).isActive = true
    }
}
