//
//  CellBinding.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

protocol CellBinding {
    associatedtype Data: Equatable
    associatedtype Cell: ReuseIdentifying & BindableTableViewCell
    
    func bind(data: Data, to cell: Cell) -> Cell
    func bindDidSelectHandler(cell: Cell, with data: Data, in viewController: UIViewController)
}

extension CellBinding {
    func bindDidSelectHandler(cell: Cell, with data: Data, in viewController: UIViewController) {
        print("extension called")
    }

}
