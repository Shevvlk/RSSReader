
import UIKit
import RealmSwift

class HomeViewController: UITableViewController {
    
    var channelArr:     Results<Channel>?
    var token:          NotificationToken? = nil
    weak var delegate:  HomeControllerDelegate?
    var realm:          Realm?
    
    let barTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont(name: "Al Nile", size: 25)
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
            let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
            let buttond = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            alert.addAction(buttond)
            self.present(alert, animated: true, completion: nil)
        }
        
        channelArr = realm?.objects(Channel.self).filter("lastOpenChannel == true")
        
        token = realm?.observe { [weak self] notification, realm in
            self?.navigationBarTitle()
            self?.tableView.reloadData()
        }
        
        navigationBarTitle()
        
        updatingArticles()
    }
    
    //     MARK: - Количество ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channelArr?.first?.arrayModels.count ?? 0
    }
    
    //     MARK: - Настройка отображения ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomHomeTableViewCell else { fatalError("Unable to Dequeue Image Table View Cell") }
        
        guard let channelFirst = channelArr?.first else { return cell }
        
        if channelFirst.arrayModels[indexPath.row].cell {
            
            cell.highlighting.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else {
            
            cell.highlighting.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 0.2142032851)
        }
        
        cell.headingLabel.font = UIFont(name: "Al Nile", size: 18)
        
        cell.headingLabel.text = channelFirst.arrayModels[indexPath.row].title
        cell.subtitleLabel.text = channelFirst.arrayModels[indexPath.row].date
        
        return cell
    }
    
    //     MARK: - Переход на NewsReaderViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsReaderController = NewsReaderViewController()
        
        guard let channelFirst = channelArr?.first else { return }
        
        StorageManager().rewritingAnOpenArticle(channelFirst, indexPath.row)
        
        let sample = channelFirst.arrayModels[indexPath.row].depiction
        
        newsReaderController.newsText.attributedText = sample.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Arial", size: 18), csscolor: "black", lineheight: 5, csstextalign: "left")
        
        tableView.reloadData()
        
        self.navigationController?.pushViewController(newsReaderController, animated: true)
    }
    
    //     MARK: - Настройка навигационного бара
    func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        navigationController?.navigationBar.barStyle = .default
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Data-Information-24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
       
    }
    
    //     MARK: - Переход на экран Rss каналов
    @objc func handleMenuToggle() {

        delegate?.handleMenuToggle()
    }
    
    //    MARK: - Настройка заголовка навигационного бара
    func navigationBarTitle() {
        
        if let channelFirst = channelArr?.first {
            
            title = channelFirst.nameurl
        } else {
            
            title = "Добавьте Rss канал"
        }
        
        barTitleLabel.text = title
        
        self.navigationItem.titleView = barTitleLabel
      
    }
    //    MARK: - Обновление статей
    @objc func updatingArticles() {
        
        guard let channelFirst = channelArr?.first else { return }
        let urlAddress = channelFirst.urlAddress
        DispatchQueue.global(qos: .userInteractive).async {
            AddManager().addingNewArticles(urlAddress)
            DispatchQueue.main.async { [unowned self] in
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}


