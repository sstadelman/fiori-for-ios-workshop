//
//  AnyCellBinding.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

struct AnyCellBinding<Data: Equatable, Cell: ReuseIdentifying & BindableTableViewCell>: CellBinding {

    private let _bindDidSelect: (Cell, Data, UIViewController) -> Void
    private let _bind: (Data, Cell) -> Cell
    
    init<Binding: CellBinding>(_ base: Binding) where Data == Binding.Data, Cell == Binding.Cell {
        _bind = base.bind
        _bindDidSelect = base.bindDidSelectHandler
    }
    
    func bind(data: Data, to cell: Cell) -> Cell {
        return _bind(data, cell)
    }
    
    func bindDidSelectHandler(cell: Cell, with data: Data, in viewController: UIViewController) {
        return _bindDidSelect(cell, data, viewController)
    }
}
