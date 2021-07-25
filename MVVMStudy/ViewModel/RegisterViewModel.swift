//
//  RegisterViewModel.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
  struct Input {
    let emailText: Observable<String>
    let passwordText: Observable<String>
    let nickNameText: Observable<String>
    let registerBtnClicked: Observable<Void>
  }
  struct Output {
    let registerResult: Observable<RegisterModel>
    let registerEnabled: Observable<Bool>
  }
}
extension RegisterViewModel {
  func transform (input: Input) -> Output {
    //텍스트 입력 시 모델을 계속 업데이트한다
    let registerModel = Observable.combineLatest(input.emailText,
                                                 input.passwordText,
                                                 input.nickNameText)
      .map{ email, passwd, nickname -> RegisterModel in
        return .init(email: email, passWord: passwd, nickName: nickname)
      }
    
    
    let emailEnabled = input.emailText.map{$0.validate(with: .email)}
    let passwordEnabeld = input.passwordText.map{$0.validate(with: .password)}
    let nickNameEnabeld = input.nickNameText.map{$0.validate(with: .nickname)}
    let registerEnabled = Observable.combineLatest(emailEnabled, passwordEnabeld, nickNameEnabeld)
      .map{$0.0 && $0.1 && $0.2}

    let register = input.registerBtnClicked
      .flatMapLatest{
        return registerModel
      }
    return .init(registerResult: register, registerEnabled: registerEnabled)
  }
}
