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
        //optional
            .map { $0 ?? "" }
        //10文字以上だったら、trueを返す
            .map { $0.count >= 10 }
        
        let password1 = password1TextField.rx.text
            .map { $0 ?? "" }
        
        let password2 = password2TextField.rx.text
            .map { $0 ?? "" }
        
        let isValidPassword = Observable
        //combineLatestは、更新されたら上書きしたものがマージされるから便利
        //２つ引数に渡して、更新されるたびにマージされるから、passwordを一文字入力するごとに更新される
            .combineLatest(password1, password2)
            .map { password1, password2 in
                //password1とpassword2が同じで、かつ8文字以上だったらtrueを返す
                password1 == password2 && password1.count >= 8
            }
        
        Observable
            .combineLatest(isValidEmail, isValidPassword)
            .map { email, password in
                email == true && password == true
            }
        //emailとpasswordがそれぞれ条件を満たした際に、ボタンを押せるようにする
            .subscribe( onNext: { [weak self] in
                //combineLatestの第一引数がisvalidEmailで、$0は第一引数の省略形なので、trueがはいる?
                self?.registerButton.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
    
}

