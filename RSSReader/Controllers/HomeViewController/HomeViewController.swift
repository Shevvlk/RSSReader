
import UIKit
import RealmSwift

class HomeViewController: UITableViewController {
    weak var delegate:  HomeControllerDelegate?
    
    private var channelArr:  Results<Channel>?
    private var token:       NotificationToken? = nil
    private var realm:       Realm?
    private let addManager:  AddManagerProtocol
    private var mistake:     String?
    
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
            
            cell.markView.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 0.2142032851)
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
                newsReaderController.newsText.attributedText = text
            }
        }
        self.navigationController?.pushViewController(newsReaderController, animated: true)
    }
    
    /// Настройка навигационного бара
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.barStyle = .default
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleMenu))
    }
    
    ///  Переход на  MenuViewController
    @objc func toggleMenu() {
        delegate?.toggleMenu()
    }
    
    /// Настройка заголовка навигационного бара
    func navigationBarTitle() {
        
        if let channelFirst = channelArr?.first { title = channelFirst.nameurl }
        else { title = "Добавьте Rss канал" }
        
        barTitleLabel.text = title
        self.navigationItem.titleView = barTitleLabel
    }
    
    /// Обновление статей
    @objc func updatingArticles() {
        guard let channelFirst = channelArr?.first else { return }
        let urlAddress = channelFirst.urlAddress
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            self?.addManager.addingNewArticles(urlAddress)
            DispatchQueue.main.async {[weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
}


