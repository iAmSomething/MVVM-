//
//  TableViewModel.swift
//  MVVMStudy
//
//  Created by 김태훈 on 2021/07/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TableViewViewModel {
  struct Input {
    let loadView: Observable<Void>
    let newContent: Observable<String>
    let addContent: Observable<Void>
    let deleteContent: Observable<(IndexPath, TableViewModel)>
    
    let deleteAll: Observable<Void>
  }
  struct Output {
    let tableViewItems: Observable<[TableViewModel]>
  }
  struct State {
    var currentItems = BehaviorSubject<[TableViewModel]>(value: [])
  }
  var state = State()
}

extension TableViewViewModel {
  func transform(input : Input) -> Output {
    weak var `self` = self

    let addItem = input.addContent
      .withLatestFrom(input.newContent)
      .map{TableViewModel(content: $0, textColor: .brown)}
    
    let items = input.loadView
      .withLatestFrom(self?.state.currentItems ?? .empty())
      .flatMapLatest{ usecase -> Observable<[TableViewModel]> in
        return self?.addTableView(addItem: addItem,
                                  deleteItem: input.deleteContent,
                                  deleteAll: input.deleteAll,
                                  usecase: usecase) ?? .empty()
      }
    return .init(tableViewItems: items)
  }
  func addTableView (
    //action
    addItem : Observable<TableViewModel>,
    deleteItem: Observable<(IndexPath, TableViewModel)>,
    deleteAll: Observable<Void>,
    //data
    usecase : [TableViewModel]) -> Observable<[TableViewModel]> {
    weak var `self` = self
    enum Action {
      case add(TableViewModel)
      case delete(IndexPath, TableViewModel)
      case deleteAll(Void)
    }
    return Observable.merge(addItem.map(Action.add),
            deleteItem.map(Action.delete),
            deleteAll.map(Action.deleteAll))
      .scan(into:usecase) { state, action in
        switch action {
        case .add(let model):
          state.append(model)
          self?.state.currentItems.onNext(state)
        case .delete(let indexpath, let model):
          if state[indexpath.row].content == model.content {
            state.remove(at: indexpath.row)
          }
        case .deleteAll:
          state = []
        }
      }.startWith(usecase)
  }
}

