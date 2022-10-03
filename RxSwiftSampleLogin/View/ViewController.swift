//
//  ViewController.swift
//  RxSwiftSampleLogin
//
//  Created by SANG HOON HAN on 2022/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton(isEnabled: false)
        
        // UITextField의 값을 뷰모델의 property에 바인딩
        _ = txfUsername.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.username)
        _ = txfPassword.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.password)
        
        // 뷰모델의 isBind를 btnLogin에 바인딩
        _ = loginViewModel.isValid.bind(to: btnLogin.rx.isEnabled)
        
        // 뷰모델의 isValid를 subscribe(구독)한다.
        // 텍스트필드에 값이 입력되면 onNext가 실행되고
        // 뷰모델의 Observable.combineLatest가 유효성 검사를 한 뒤
        // Observable<Bool> 타입의 값을 반환한다.
        // 그 값이 클로저 함수 안의 isValid와 연동된다.
        _ = loginViewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            
            // 상태 레이블 서식 변경
            configureStatuslabel(isEnabled: isValid)
            // 텍스트 필드에 값을 입력할 때마다 isValid가 실시간으로 변경된다.
            print("isValid:", isValid)
            // 버튼 서식 변경
            configureLoginButton(isEnabled: isValid)
        })
    }
    
    func configureLoginButton(isEnabled: Bool) {
        btnLogin.isEnabled = isEnabled
        btnLogin.backgroundColor = isEnabled ? .orange : .lightGray
    }
    
    func configureStatuslabel(isEnabled: Bool) {
        lblStatus.text = isEnabled ? "Enabled" : "Disabled"
        lblStatus.textColor = isEnabled ? UIColor(red: 55/255, green: 168/255, blue: 82/255, alpha: 1) : .red
    }
}
