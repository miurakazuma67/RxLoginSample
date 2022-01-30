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
    private var disoseBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isValidEmail = emailTextField.rx.text
            .map { $0 ?? "" }
            .map { $0.count >= 10 }
        
        let isValidPassword1 = password1TextField.rx.text
            .map { $0 ?? "" }
            .map { $0.count >= 8 }
        
        let isValidPassword2 = password2TextField.rx.text
            .map { $0 ?? "" }
            .map { $0.count >= 8 }
        
        let isValidPassword = Observable.combineLatest(password1TextField.rx.text.map { $0 ?? "" },
                                                       password2TextField.rx.text.map { $0 ?? "" }
        )
            .map { password1, password2 in
                password1 == password2 && password1.count >= 8
            }
            .subscribe( onNext: { [weak self] in
                self.registerButton.isEnabled = $0
            } )
            .disposed(by: disoseBag)
    }
    
    
}

