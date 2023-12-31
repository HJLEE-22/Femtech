//
//  UIViewController.swift
//  PracticeForLogin
//
//  Created by Lee on 2023/06/28.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, _ message: String, _ okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "취소", style: .cancel))
        if let okAction {
            let ok = UIAlertAction(title: "확인", style: .default){ _ in
                okAction()
            }
            alertVC.addAction(ok)
        }
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
