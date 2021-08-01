//
//  RegisterModel.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
struct RegisterModel {
  let email: String
  let passWord: String
  let nickName: String
  let privacy: Bool
  let promotion: Bool
}
enum ValidationRegex: String{
  case email = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
  case password = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
  case nickname = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\\*]{2,}+$"
}

extension String {
  func validate(with regex: String) -> Bool {
    return NSPredicate(format: "SELF MATCHES %@" , regex.trimmingCharacters(in: .whitespaces)).evaluate(with: self)
  }

  func validate(with regex: ValidationRegex) -> Bool {
    return validate(with: regex.rawValue)
  }
}
