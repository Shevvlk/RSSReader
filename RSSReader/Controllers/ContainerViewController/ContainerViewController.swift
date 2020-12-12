
import UIKit

class ContainerViewController: UIViewController {
    
    private var menuController:    MenuViewController!
    private var homeController:    HomeViewController!
    private var centerController:  UIViewController!
    private var blackScreen:       UIView!
    private var isExpanded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController ()
    }
    
    /// Создание дочернего контролера представления
    func configureHomeController () {
        let assemby = HomeViewControllerAssembly()
        homeController = assemby.createViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    /// Создание дочернего контролера представления
    func configureMenuController() {
        if menuController == nil {
            let assemby = MenuViewControllerAssembly()
            menuController = assemby.createViewController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self )
        }
    }
    
    func blackScreenCustomization() {
        blackScreen = UIView()
        blackScreen.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.82)
        blackScreen.isHidden = !isExpanded
        blackScreen.layer.zPosition = 100
        self.view.addSubview(blackScreen)
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    
    /// Вызов функции открытия и закрыти слайд меню при нажатии на view
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = isExpanded
        isExpanded = !isExpanded
        blackScreen.frame = self.view.bounds
        showMenuController (shouldExpand: isExpanded)
    }
    
    /// Открытие и закрытие слайд меню
    /// - Parameter shouldExpand: Переменная информирующая о состоянии слайд меню (открыто или закрыто)
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
}

/// Передача информации из HomeController (переход на  MenuController)
extension ContainerViewController: HomeControllerDelegate {
    func toggleMenu() {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded = !isExpanded
        blackScreenCustomization()
        showMenuController(shouldExpand: isExpanded)
    }
}

/// Передача информации из MenuController (переход на  HomeController )
extension ContainerViewController: MenuControllerDelegate {
    func toggleHome() {
        blackScreen.isHidden = isExpanded
        blackScreen.frame = self.view.bounds
        isExpanded = !isExpanded
        showMenuController (shouldExpand: isExpanded)
    }
}
