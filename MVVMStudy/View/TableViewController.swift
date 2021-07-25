//
//  TableViewController.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class UsingTableViewController : UIViewController {
  
  @IBOutlet weak var textTableView: UITableView!
  @IBOutlet weak var addCellTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    bind()
  }
  func setUpTableView() {
    textTableView.backgroundColor = .lightGray
    textTableView.register(tableViewCell.self, forCellReuseIdentifier: tableViewCell.id)
    textTableView.estimatedRowHeight = 80
    textTableView.rowHeight = UITableView.automaticDimension
    textTableView.separatorStyle = .none
  }
  private let disposeBag = DisposeBag()
  private let loadViewTrigger = PublishSubject<Void>()
  private let viewModel = TableViewViewModel()
  func bind() {
    let deleteItem = Observable.zip(textTableView.rx.itemSelected.asObservable(),
                                    textTableView.rx.modelSelected(TableViewModel.self).asObservable())
    let input = TableViewViewModel.Input(loadView: loadViewTrigger,
                                         newContent: addCellTextField.rx.text.orEmpty.asObservable(),
                                         addContent: addCellTextField.rx.controlEvent(.editingDidEnd).share().asObservable(), deleteContent: deleteItem)
    let output = viewModel.transform(input: input)
    output.tableViewItems.bind(to: textTableView.rx.items(cellIdentifier: tableViewCell.id,
                                                          cellType: tableViewCell.self)) {row, data, cell in
      cell.bind(model: data)
    }.disposed(by: disposeBag)
    
    
    viewModel.state.currentItems.bind{
      print($0)
    }.disposed(by: disposeBag)
    loadViewTrigger.onNext(())
  }
}

 
import SnapKit
class tableViewCell : UITableViewCell {
  static let id : String = "cell"
  private let text: UILabel = {
    let l = UILabel()
    l.textAlignment = .center
    l.textColor = .blue
    return l
  }()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func layout() {
    self.addSubview(text)
    self.backgroundColor = .white
    text.snp.makeConstraints{
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  func bind(model : TableViewModel) {
    self.text.text = model.content
    self.text.textColor = model.textColor
  }
}
