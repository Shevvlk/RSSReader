
import UIKit

extension HomeViewController {
    func callAlertExclusion(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}
