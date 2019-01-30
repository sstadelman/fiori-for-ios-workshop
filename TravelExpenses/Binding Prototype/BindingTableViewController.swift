//
//  BindingTableViewController.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPOData

protocol DataFetching {
    associatedtype Data: Equatable
    
    var query: DataQuery { get }
    var didFetchHandler: (([Data]) -> Void)? { get }
}

struct AnyDataFetching<Data: Equatable>: DataFetching {
    let query: DataQuery
    let didFetchHandler: (([Data]) -> Void)?

    init<Binding: DataFetching>(_ base: Binding) where Data == Binding.Data {
        query = base.query
        didFetchHandler = base.didFetchHandler
    }
}

class BindingTableViewController: FioriBaseTableViewController, UITableViewDataSourcePrefetching {

    // MARK: - Bindings model
    
    var dataSources: [Int: SectionDataSource] = [:]
    
    func registerDataBinding<Data, Cell: UITableViewCell & ReuseIdentifying>(_ dataBinding: AnyCellBinding<Data, Cell>, forSection section: Int, with dataFetching: AnyDataFetching<Data>) {
        
        self.tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        let dataSource = SectionDataSourceImpl<AnyCellBinding<Data, Cell>, AnyDataFetching<Data>>(binding: dataBinding, to: dataFetching, for: section, in: tableView, viewController: self)
        self.dataSources.updateValue(dataSource, forKey: section)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSources[section] else { return 0 }
        return dataSource.tableView(tableView, numberOfRowsIn:section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSources[indexPath.section] else { return UITableViewCell() }
        return dataSource.tableView(tableView, cellForRowAt: indexPath.row)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSources[indexPath.section] else { return }
        dataSource.tableView(tableView, didSelectRowAt: indexPath.row)
    }
    
    // MARK: - Table view data source prefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let dataSource = dataSources[indexPath.section] else { continue }
            dataSource.refresh()
        }
    }

}
