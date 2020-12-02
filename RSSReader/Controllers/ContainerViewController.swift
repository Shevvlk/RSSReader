
import UIKit

class ContainerViewController: UIViewController {
    
    var menuController:    MenuViewController!
    var homeController:    HomeViewController!
    var centerController:  UIViewController!
    var blackScreen:       UIView!
    var isExpanded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeController ()
        
    }
    
    // MARK: - Создание дочерних контроллеров представления
    func configureHomeController () {
        homeController = HomeViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }
    
    // MARK: - Создание дочернего контроллера выбора канала
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuViewController()
            menuController.delegateMenuController = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self )
        }
    }
    
    // MARK: - Реализация слайд - меню
    func showMenuController (shouldExpand: Bool) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: {
                            self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80},
                           completion: nil)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { self.blackScreen.frame = CGRect(x: self.centerController.view.frame.origin.x, y: 0 , width:80, height: self.view.bounds.height)},
                           completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut, animations: { self.centerController.view.frame.origin.x = 0 },
                           completion: nil)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = isExpanded
        isExpanded = !isExpanded
        blackScreen.frame = self.view.bounds
        showMenuController (shouldExpand: isExpanded)
    }
    
    func blackScreenCustomization() {
        blackScreen = UIView()
        blackScreen.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9138484589)
        blackScreen.isHidden = !isExpanded
        blackScreen.layer.zPosition = 100
        self.view.addSubview(blackScreen)
        
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
}

// MARK: - Передача информации из HomeController
extension ContainerViewController: HomeControllerDelegate {
    func handleMenuToggle() {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        blackScreenCustomization()
        showMenuController(shouldExpand: isExpanded)
    }
}


// MARK: - Передача информации из MenuController
extension ContainerViewController: MenuControllerDelegate {
    func handleMenu() {
        blackScreen.isHidden = isExpanded
        blackScreen.frame = self.view.bounds
        isExpanded = !isExpanded
        showMenuController (shouldExpand: isExpanded)
        homeController.tableView.reloadData()
    }
    
}
