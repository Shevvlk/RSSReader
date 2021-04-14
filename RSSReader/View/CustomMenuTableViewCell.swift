import UIKit

// MARK: - Настройка кастомной ячейки
final class CustomMenuTableViewCell: UITableViewCell {
    
    /// Метка ячейки
    var markImageView: UIImageView = {
        let mark = UIImageView()
        mark.image = UIImage(systemName: "checkmark")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
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
        contentView.addSubview(markImageView)
        contentView.addSubview(headingLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            markImageView.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 10),
            markImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor,constant: 3),
            markImageView.widthAnchor.constraint(equalToConstant:20),
            markImageView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant: -10),
            
            headingLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor),
            headingLabel.leadingAnchor.constraint(equalTo:self.markImageView.trailingAnchor, constant: 4),
            headingLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -80),
            headingLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor)
        ])
    }
}
