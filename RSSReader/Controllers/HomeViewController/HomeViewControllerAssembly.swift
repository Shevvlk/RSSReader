
import UIKit

/// Сборщик Home контроллера
final class HomeViewControllerAssembly {
    func createViewController() -> HomeViewController {
        let storageManager = StorageManager()
        let addManager = AddManager(storageManager: storageManager)
        let controller = HomeViewController(addManager: addManager)
        return controller
    }
}

