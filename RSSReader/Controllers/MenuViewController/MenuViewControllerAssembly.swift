
import UIKit

/// Сборщик Menu контроллера
final class MenuViewControllerAssembly {
    func createViewController() -> MenuViewController {
        let storageManager = StorageManager()
        let addManager = AddManager(storageManager: storageManager)
        let controller = MenuViewController(addManager: addManager)
        return controller
    }
}
