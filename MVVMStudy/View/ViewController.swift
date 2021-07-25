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
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  private let disposeBag = DisposeBag()
  private let viewModel = ViewModel()
  private let buttonClickSubject = PublishSubject<Int>()
  func bind() {
    let input = ViewModel.Input(buttonClicked: buttonClickSubject)
    
    let output = viewModel.transform(input: input)
    
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
    
    
    firstBtn.rx.tap.map{return 1}
      .bind(to: buttonClickSubject)
      .disposed(by: disposeBag)
    secondBtn.rx.tap.map{return 2}
      .bind(to: buttonClickSubject)
      .disposed(by: disposeBag)
    thirdBtn.rx.tap.map{return 3}
        .bind(to: buttonClickSubject)
        .disposed(by: disposeBag)
  }
}

