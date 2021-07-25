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
  
  //practice : 약관 동의 조건 추가하기
  //요구사항 : 현재 이메일 비밀번호 닉네임만 받는데, 필수 동의사항과 선택 동의사항을 하나씩 넣어 주세요!
  //         동의한 약관의 경우 isSelected값을 true로 설정해주세요!
  @IBOutlet weak var privacyAgreeBtn: UIButton!
  @IBOutlet weak var promotionAgreeBtn: UIButton!
  
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
