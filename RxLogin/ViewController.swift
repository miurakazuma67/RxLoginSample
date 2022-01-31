//
//  ViewController.swift
//  RxLogin
//
//  Created by 三浦　一真 on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var password1TextField: UITextField!
    @IBOutlet private weak var password2TextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isValidEmail = emailTextField.rx.text
            .map { $0 ?? "" }
            .map { $0.count >= 10 }
        
        let password1 = password1TextField.rx.text
            .map { $0 ?? "" }
        
        let password2 = password2TextField.rx.text
            .map { $0 ?? "" }
        
        let isValidPassword = Observable
            .combineLatest(password1, password2)
            .map { password1, password2 in
                password1 == password2 && password1.count >= 8
            }
        
        Observable
            .combineLatest(isValidEmail, isValidPassword)
            .map { email, password in
                email == true && password == true
            }
            .subscribe( onNext: { [weak self] in
                self?.registerButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
    
}

