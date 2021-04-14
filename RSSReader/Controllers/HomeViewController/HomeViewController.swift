
import UIKit
import RealmSwift

final class HomeViewController: UITableViewController {
    weak var delegate:  HomeControllerDelegate?
    
    private var channelArr:  Results<Channel>?
    
    private var token:       NotificationToken? = nil
    private var realm:       Realm?
    private let addManager:  AddManagerProtocol
    private var mistake:     String?
    private let backgroundView = PreceptBackgroundView()
    
    init(addManager: AddManagerProtocol) {
        self.addManager = addManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let image = UIImage(systemName: "line.horizontal.3")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    
    private let barTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont(name: "Geeza Pro", size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        tableView.backgroundView = backgroundView
        tableView.tableFooterView = UIView()
        tableView.register(CustomHomeTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...")
        refreshControl.addTarget(self, action: #selector(updatingArticles), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        do {
            realm = try Realm()
        } catch {
            mistake = error.localizedDescription
        }
        
        channelArr = realm?.objects(Channel.self).filter("lastOpenChannel == true")
        
        token = realm?.observe { [weak self] notification, realm in
            if self?.channelArr?.count != 0  {
                self?.backgroundView.labelDescription.isHidden = true
            }else {
                self?.backgroundView.labelDescription.isHidden = false
            }
            self?.navigationBarTitle()
            self?.tableView.reloadData()
        }
        navigationBarTitle()
        updatingArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = realm
        else {
            callAlertExclusion(title: mistake!)
            return
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelArr?.first?.arrayNews.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomHomeTableViewCell else { fatalError("Unable to Dequeue Image Table View Cell") }
        guard let channelFirst = channelArr?.first else { return cell }
        
        if channelFirst.arrayNews[indexPath.row].viewedNews {
            
            cell.markView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else {
            
            cell.markView.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 0.3991687093)
        }
        
        cell.headingLabel.text = channelFirst.arrayNews[indexPath.row].title
        cell.subtitleLabel.text = channelFirst.arrayNews[indexPath.row].date
        
        return cell
    }
    
    /// Переход на NewsReaderViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsReaderController = NewsReaderViewController()
        
        guard let channelFirst = channelArr?.first else { return }
        
        addManager.openNews(channelFirst, indexPath.row)
        
        let sample = channelFirst.arrayNews[indexPath.row].depiction
        
        DispatchQueue.global().async {
            let text = sample.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Geeza Pro", size: 17), csscolor: "black", lineheight: 20, csstextalign: "left")
            DispatchQueue.main.async {
                newsReaderController.activityIndicator.isHidden = true
                newsReaderController.newsText.attributedText = text
            }
        }
        self.navigationController?.pushViewController(newsReaderController, animated: true)
    }
    
    /// Настройка навигационного бара
    private func configureNavigationBar() {
        navigationController?.view.layer.borderWidth = 0.3
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barStyle = .default
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleMenu))
    }
    
    ///  Переход на  MenuViewController
    @objc private func toggleMenu() {
        delegate?.toggleMenu()
    }
    
    /// Настройка заголовка навигационного бара
    private func navigationBarTitle() {
        
        if let channelFirst = channelArr?.first { title = channelFirst.nameurl }
        else { title = "Новостная лента" }
        
        barTitleLabel.text = title
        self.navigationItem.titleView = barTitleLabel
    }
    
    /// Обновление статей
    @objc private func updatingArticles() {
        guard let channelFirst = channelArr?.first
        else {
            tableView.refreshControl?.endRefreshing()
            return
        }
        let urlAddress = channelFirst.urlAddress
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            self?.addManager.addingNewArticles(urlAddress)
            DispatchQueue.main.async {[weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
}


