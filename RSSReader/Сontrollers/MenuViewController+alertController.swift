

import UIKit
import RealmSwift

extension MenuViewController {
    
    // MARK: - Добавление канала
    @objc func callAlert () {
        
        let alertController = UIAlertController(title: "Добавление канала", message: "Введите название канала и URL", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            
            guard let textFieldFirst = alertController.textFields?.first, let nameUrlTextFieldText = textFieldFirst.text else { return }
            
            guard let textFieldLast = alertController.textFields?.last, let urlAddressTextFieldText = textFieldLast.text else { return }
            
            guard let _ = URL(string: urlAddressTextFieldText) else {
                let alertController = UIAlertController(title: "URL адрес не найден", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                return
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                AddManager().addingСhannels(nameUrlTextFieldText, urlAddressTextFieldText)
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
