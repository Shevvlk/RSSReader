

import UIKit
import RealmSwift

extension MenuViewController {
    
    /// AlertController для Добавление канала
    @objc func callAlertAdding () {
        
        let alertController = UIAlertController(title: "Добавление канала", message: "Введите название канала и URL", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            
            guard let textFieldFirst = alertController.textFields?.first, let nameUrlTextFieldText = textFieldFirst.text else { return }
            
            guard let textFieldLast = alertController.textFields?.last, let urlAddressTextFieldText = textFieldLast.text else { return }
            
            guard let _ = URL(string: urlAddressTextFieldText) else {
                self.callAlertExclusion(title:"URL адрес не найден")
                return
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.addManager.addingСhannels(nameUrlTextFieldText, urlAddressTextFieldText) {
                    DispatchQueue.main.async { [weak self] in
                        self?.callAlertExclusion(title: "Канал уже добален")
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        saveAction.isEnabled = false
        
        alertController.addTextField { (nameText) in
            
            nameText.placeholder = "Введите название канала"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                   object: nameText,
                                                   queue: OperationQueue.main)
            { _ in
                let textCount = nameText.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                saveAction.isEnabled = textIsNotEmpty
            }
        }
        
        alertController.addTextField { (urlText) in
            urlText.placeholder = "Введите URL адрес"
        }
        self.present(alertController, animated: true)
    }
}

/// AlertController для уведомлений
extension MenuViewController {
    func callAlertExclusion(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}
