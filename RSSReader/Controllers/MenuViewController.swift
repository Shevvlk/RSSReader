

import UIKit
import RealmSwift

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var channelArr:                    Results<Channel>?
    var token:                         NotificationToken? = nil
    weak var delegateMenuController:   MenuControllerDelegate?
    var realm:                         Realm?
    
    var titleViewLabel: UILabel = {
        let label = UILabel()
        label.text = "RSS Каналы"
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let mynavigationItem: UINavigationItem = {
        let navigationItem = UINavigationItem()
        return navigationItem
    }()
    
    let navigationBar : UINavigationBar = {
        let mynavigationBar = UINavigationBar()
        mynavigationBar.layer.borderWidth = 0.3
        mynavigationBar.tintColor = .systemBlue
        mynavigationBar.isTranslucent = false
        mynavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return mynavigationBar
    }()
    
    let tableView: UITableView = {
        let mytableView = UITableView()
        mytableView.separatorInset = .zero
        mytableView.showsVerticalScrollIndicator = false
        mytableView.translatesAutoresizingMaskIntoConstraints = false
        return mytableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.items = [mynavigationItem]
        
        mynavigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(callAlertAdding))
        
        mynavigationItem.titleView = titleViewLabel
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        
        constraintsTableandNavigationBar ()
        
        
        do {
            realm = try Realm()
        } catch {
            callAlertExclusion(title: error.localizedDescription)
        }
        
        channelArr = realm?.objects(Channel.self).sorted(byKeyPath: "nameurl")
        
        token = realm?.observe { [weak self] notification, realm in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Количество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channelArr?.count ?? 0
    }
    
    //     MARK: - Настройка отображения ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let channel = channelArr?[indexPath.row] else {return cell}
        
        if channel.lastOpenChannel {
            
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 0.2142032851)
            
        } else {
            
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.text = channel.nameurl
        
        return cell
    }
    
    
    // MARK: - Выбор новости
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let urlAddress = channelArr?[indexPath.row].urlAddress else { return }
        
        DispatchQueue.global().async {
            let storageManager = StorageManager()
            storageManager.initializationRealm()
            storageManager.preservationOfOpenChannels(urlAddress)
        }
        
        delegateMenuController?.handleMenu()
        
    }
    
    // MARK: - Удаление ячейки
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            
            guard  let сhannel = self.channelArr?[indexPath.row] else {return}
            
            guard  let token = self.token else {return}
            
            let storageManager = StorageManager()
            storageManager.initializationRealm()
            storageManager.deleteChannel(сhannel, [token])
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            complete(true)
        }
        
        deleteAction.image = UIImage(named: "deletebin")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    
    // MARK: - Добавление констрейнтов
    func constraintsTableandNavigationBar () {
        
        navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // Удаление токена
    override func viewWillDisappear(_ animated: Bool) {
        token?.invalidate()
    }
    
}




