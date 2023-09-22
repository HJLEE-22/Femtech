//
//  SigningViewController.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import UIKit
import TouchDraw

protocol SignViewControllereDelegate: AnyObject {
    func getSignatureImage(image: UIImage)
}

final class SignViewController: UIViewController {
    
    // MARK: - Properties

    private let signView = SignView()
    var signatureExport: UIImage?
    
    // 네비게이션 아이템이니까 이건 봐주기
    private lazy var clearBarButton: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .trash,
                                   target: self,
                                   action: #selector(self.clearSignature))
        return item
    }()
    
    weak var delegate: SignViewControllereDelegate?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationButton()
        self.addActionToAttachButton()
        self.setTouchDrawDelegate()
        self.setViewController()
    }
    
    override func loadView() {
        super.loadView()
        self.view = signView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.signView.touchDrawView.clearDrawing()
        self.signatureExport = nil
    }
    
    // MARK: - Helpers
    
    private func setViewController() {
        self.navigationController?.delegate = self
    }
    
    private func setTouchDrawDelegate() {
        self.signView.touchDrawView.delegate = self
    }
    
    private func addActionToAttachButton() {
        self.signView.attachButton.addTarget(self,
                                             action: #selector(self.attachSignature),
                                             for: .touchUpInside)
    }
    
    @objc private func attachSignature() {
        if self.signView.touchDrawView.exportStack().count > 0 {
            self.signatureExport = self.signView.touchDrawView.exportDrawing()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addNavigationButton() {
        self.navigationItem.rightBarButtonItem = self.clearBarButton
        // title이 button은 아니지만...
        self.title = "서명"
    }
    
    @objc private func clearSignature() {
        self.signView.touchDrawView.clearDrawing()
    }
    
}

extension SignViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        guard let signatureExport else {
            print("DEBUG: no signature image")
            return }
        self.delegate?.getSignatureImage(image: signatureExport)
        
    }
}

extension SignViewController: TouchDrawViewDelegate {

}
