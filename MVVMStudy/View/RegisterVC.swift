//
//  RegisterVC.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class RegisterVC : UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passWordTextField: UITextField!
  @IBOutlet weak var nickNameTextField: UITextField!
  @IBOutlet weak var registerBtn: UIButton!
  @IBOutlet weak var result: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  private let disposeBag = DisposeBag()
  private let viewModel = RegisterViewModel()
  private func bind() {
    let input = RegisterViewModel.Input(emailText: emailTextField.rx.text.orEmpty.asObservable(),
                                        passwordText: passWordTextField.rx.text.orEmpty.asObservable(),
                                        nickNameText: nickNameTextField.rx.text.orEmpty.asObservable(),
                                        registerBtnClicked: registerBtn.rx.tap.asObservable())
    let output = viewModel.transform(input: input)
    
    output.registerEnabled
      .bind(to: registerBtn.rx.isEnabled)
      .disposed(by: disposeBag)
    
    output.registerResult
      .bind{[weak self] model in
        self?.result.text = """
          아이디 : \(model.email)
          비밀번호 : \(model.passWord)
          닉네임: \(model.nickName)
          """
      }.disposed(by: disposeBag)
    
  }
}
