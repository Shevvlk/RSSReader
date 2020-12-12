

import UIKit
import RealmSwift

class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    weak var delegate: MenuControllerDelegate?
    
    let addManager: AddManagerProtocol
    
    private var channelArr: Results<Channel>?
    private var token:      NotificationToken? = nil
    private var realm:      Realm?
    
    init(addManager: AddManagerProtocol) {
        self.addManager = addManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var titleViewLabel: UILabel = {
        let label = UILabel()
        label.text = "RSS Каналы"
        label.textColor = .systemBlue
        label.font = UIFont(name: "Geeza Pro", size: 17)
        return label
    }()
    
    private let mynavigationItem: UINavigationItem = {
        let navigationItem = UINavigationItem()
        return navigationItem
    }()
    
    private let navigationBar : UINavigationBar = {
        let mynavigationBar = UINavigationBar()
        mynavigationBar.layer.borderWidth = 0.3
        mynavigationBar.tintColor = .systemBlue
        mynavigationBar.isTranslucent = false
        mynavigationBar.translatesAutoresizingMaskIntoConstraints = false
        return mynavigationBar
    }()
    
    private let tableView: UITableView = {
        let mytableView = UITableView()
        mytableView.tableFooterView = UIView()
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
            print(error.localizedDescription) 
        }
        
        channelArr = realm?.objects(Channel.self).sorted(byKeyPath: "nameurl")
        
        token = realm?.observe { [weak self] notification, realm in
            self?.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channelArr?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let channel = channelArr?[indexPath.row] else {return cell}
        
        if channel.lastOpenChannel {
            
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.5294117647, blue: 1, alpha: 0.2142032851)
            
        } else {
            
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.textLabel?.font = UIFont(name: "Geeza Pro", size: 18)
        cell.textLabel?.text = channel.nameurl
        return cell
    }
    
    
    /// Выбор канала новостей
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let urlAddress = channelArr?[indexPath.row].urlAddress else { return }
        
        DispatchQueue.global().async {
            self.addManager.openChannels(urlAddress)
        }
        delegate?.toggleHome()
    }
    
    /// Удаление ячейки
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            
            guard  let сhannel = self.channelArr?[indexPath.row] else {return}
            guard  let token = self.token else {return}
            
            self.addManager.deleteChannel(сhannel, [token])
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            complete(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    func constraintsTableandNavigationBar () {
        
        navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    /// Удаление токена
    override func viewWillDisappear(_ animated: Bool) {
        token?.invalidate()
    }
    
}



