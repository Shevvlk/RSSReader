
import UIKit

// MARK: - Настройка кастомной ячейки
final class CustomHomeTableViewCell: UITableViewCell {
    
    /// Метка ячейки
    var markView: UIView = {
        let mark = UIView()
        mark.layer.cornerRadius = 5
        mark.backgroundColor = .white
        mark.translatesAutoresizingMaskIntoConstraints = false
        return mark
    }()
    
    /// Заголовок
    let headingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont(name: "Geeza Pro", size: 15)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Подзаголовок
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Geeza Pro", size: 11)
        label.textColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///  Контейнер
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(headingLabel)
        containerView.addSubview(subtitleLabel)
        contentView.addSubview(markView)
        contentView.addSubview(containerView)
        self.textLabel?.numberOfLines = 0
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            markView.topAnchor.constraint(equalTo:self.contentView.topAnchor),
            markView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor),
            markView.widthAnchor.constraint(equalToConstant:10),
            markView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor),
            
            headingLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor, constant: 7),
            headingLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor),
            headingLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo:self.headingLabel.lastBaselineAnchor,constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor ),
            subtitleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -6),
            
            containerView.topAnchor.constraint(equalTo:self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.markView.trailingAnchor, constant:7),
            containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-7),
            containerView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor)
        ])
    }
}
