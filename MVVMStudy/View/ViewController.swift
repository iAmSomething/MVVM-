//
//  ViewController.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var firstBtn: UIButton!
  @IBOutlet weak var secondBtn: UIButton!
  @IBOutlet weak var thirdBtn: UIButton!
  @IBOutlet weak var btnInfo: UILabel!
  
  
  //practice : 글자수 세기
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var wordCount: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  private let disposeBag = DisposeBag()
  private let viewModel = ViewModel()
  private let buttonClickSubject = PublishSubject<Int>()
  private let textSubject = PublishSubject<String>()
  func bind() {
    
    //practice tip : textfield의 text값은 String?타입인데, .orEmpty 프로퍼티로 null을 걸러낼 수 있다!
    let input = ViewModel.Input(buttonClicked: buttonClickSubject,
                                textfieldStr: textSubject)

    
    let output = viewModel.transform(input: input)
    output.selectedBtn.bind(onNext: { [weak self] model in
      print(model.buttonInfo)
      print(model.buttonNumber)
      
    }).disposed(by: disposeBag)
//    output.selectedBtn
//      .share()
//      .bind(onNext: {[weak self] btnModel in
//      self?.btnInfo.text = btnModel.buttonInfo
//      self?.firstBtn.isSelected = btnModel.buttonNumber == 1
//      self?.secondBtn.isSelected = btnModel.buttonNumber == 2
//      self?.thirdBtn.isSelected = btnModel.buttonNumber == 3
//    }).disposed(by: disposeBag)
    
    output.selectedBtn
      .share()
      .map{$0.buttonInfo}
      .bind(to: btnInfo.rx.text)
      .disposed(by: disposeBag)
    output.selectedBtn
      .share()
      .map{$0.buttonNumber == 1}
      .bind(to: firstBtn.rx.isSelected)
      .disposed(by: disposeBag)
    output.selectedBtn
      .share()
      .map{$0.buttonNumber == 2}
      .bind(to: secondBtn.rx.isSelected)
      .disposed(by: disposeBag)
    output.selectedBtn
      .share()
      .map{$0.buttonNumber == 3}
      .bind(to: thirdBtn.rx.isSelected)
      .disposed(by: disposeBag)
    output.textCount
      .map{ count in
        return String(count)
      }
      .bind(to: wordCount.rx.text)
      .disposed(by: disposeBag)
    
    
    firstBtn.rx.tap.map{return 1}
      .bind(to: buttonClickSubject)
      .disposed(by: disposeBag)
    secondBtn.rx.tap.map{return 2}
      .bind(to: buttonClickSubject)
      .disposed(by: disposeBag)
    thirdBtn.rx.tap.map{return 3}
        .bind(to: buttonClickSubject)
        .disposed(by: disposeBag)
    
    textField.rx.text.orEmpty
      .bind(to: textSubject)
      .disposed(by: disposeBag)
  }
}

