//
//  ViewController.swift
//  Makub
//
//  Created by Елена Яновская on 11.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let authBackgroundImage = "auth_background"
        static let logoImage = "logo"
        static let userImage = "user"
        static let lockImage = "lock"
        
        static let usernamePlaceholder = "Имя пользователя"
        static let passwordPlaceholder = "Пароль"
        static let loginButton = "Войти"
        static let forgotButton = "Забыли пароль?"
    }
    
    private enum LayoutConstants {
        static let standard: CGFloat = 8
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var backgoundImageView: UIImageView!
    
    @IBOutlet private var usernameTextField: AuthTextField!
    @IBOutlet private var passwordTextField: AuthTextField!
    
    @IBOutlet private var forgotButton: UIButton!
    @IBOutlet private var loginButton: AuthPassButton!
    
    // MARK: - Private Properties
    
    private let presentationModel = AuthPresentationModel()
    
    private let router = AuthRouter()
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePKHUD()
        bindEvents()
        
        hideKeyboardWhenTappedAround()
        configureBackgroundImage()
        configureImageView()
        configureTextFields()
        configureLoginButton()
        enableLoginButton()
        configureForgotButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { status in
            switch status {
            case .loading:
                HUD.show(.progress)
            case .rich:
                HUD.hide()
                self.router.showTabBar()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                case 1:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.input.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
            }
        }
    }
    
    private func configurePKHUD() {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
    }
    
    private func configureBackgroundImage() {
        backgoundImageView.image = UIImage(named: Constants.authBackgroundImage)
        backgoundImageView.contentMode = .scaleAspectFill
    }
    
    private func configureImageView() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .white
        logoImageView.image = UIImage(named: Constants.logoImage)?.withRenderingMode(.alwaysTemplate)
        logoImageView.layer.opacity = 0.95
        
        logoImageView.layer.shadowOpacity = 0.16
        logoImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        logoImageView.layer.shadowColor = UIColor.gray.cgColor
        logoImageView.layer.shadowRadius = 6
    }
    
    private func configureTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.placeholder = Constants.usernamePlaceholder
        passwordTextField.placeholder = Constants.passwordPlaceholder
        
        usernameTextField.attributePlaceholder()
        passwordTextField.attributePlaceholder()
        
        usernameTextField.addImage(Constants.userImage)
        passwordTextField.addImage(Constants.lockImage)
    }
    
    private func configureLoginButton() {
        loginButton.setTitle(Constants.loginButton, for: .normal)
    }
    
    private func configureForgotButton() {
        forgotButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        forgotButton.titleLabel?.font = UIFont.customFont(.robotoLightFont(size: 13))
        forgotButton.setTitle(Constants.forgotButton, for: .normal)
    }
    
    private func enableLoginButton() {
        loginButton.isEnabled = false
        usernameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    private func fixTextFieldWidth() {
        let width = usernameTextField.frame.width
        usernameTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    @objc private func editingChanged() {
        guard
            let username = usernameTextField.text?.removeWhitespaces(), username.count > 2,
            let password = passwordTextField.text?.removeWhitespaces(), password.count > 2
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text?.removeWhitespaces(),
            let password = passwordTextField.text else { return }
        presentationModel.authorizeUser(inputValues: [username, password])
    }
    
    @IBAction private func forgotButtonTapped(_ sender: Any) {
        router.showRecoverVC(source: self)
    }
    
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
