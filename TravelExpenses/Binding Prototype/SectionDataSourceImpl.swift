//
//  SectionDataSourceImpl.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit
import SAPOData
import TravelExpensesShared

class SectionDataSourceImpl<Binding: CellBinding>: SectionDataSource {
    
    init(binding: Binding, to query: DataQuery, for section: Int, in tableView: UITableView, viewController: UIViewController) {
        self.binding = binding
        self.section = section
        self.query = query
        self.tableView = tableView
        self.viewController = viewController
        
        self.refresh()
    }
    
    var section: Int
    let binding: Binding
    let query: DataQuery
    var entities: [Binding.Data] = [] {
        didSet {
            let diffIndexPaths = self.entities.diffIndexes(with: oldValue).map { IndexPath(row: $0, section: self.section) }
            
            guard diffIndexPaths.count == 0,
                let tableView = self.tableView,
                let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
            
            let affectedVisibleDiffs = Set(visibleIndexPaths).intersection(diffIndexPaths)
            
            guard affectedVisibleDiffs.count > 0 else { return }
            
            self.tableView?.beginUpdates()
            self.tableView?.reloadRows(at: Array(affectedVisibleDiffs), with: .automatic)
            self.tableView?.endUpdates()
        }
    }
    
    private weak var tableView: UITableView?
    private weak var viewController: UIViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsIn section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt index: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Binding.Cell.reuseIdentifier, for: IndexPath(row: index, section: self.section)) as? Binding.Cell  else { return UITableViewCell() }
        let entity = self.entities[index]
        return binding.bind(data: entity, to: cell) as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt index: Int) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Binding.Cell.reuseIdentifier, for: IndexPath(row: index, section: self.section)) as? Binding.Cell,
        let viewController = self.viewController else { return }
        let entity = self.entities[index]
        binding.bindDidSelect(cell: cell, with: entity, in: viewController)
    }
    
    func refresh() {
        DataHandler.shared.service.executeQuery(query) { [weak self] entities, error in
            guard let entities = entities else { return print(String(describing: error)) }
            do {
                self?.entities = try entities.entityList().toArray() as! [Binding.Data]
            }
            catch {
                print(error)
            }
        }
    }
}

extension Array where Element: Equatable {
    
    /// Compares two arrays, and returns the indexes of mis-matched values, relative to self
    /// if the arrays are of different lengths, the delta will be included as mis-matched indexes
    ///
    /// - Returns: indexes of mis-matched values
    func diffIndexes(with other: Array<Element>) -> [Index] {
        var diffs = zip(self, other).enumerated().reduce(into: [Index](), { (prev, next) in
            if next.1.0 != next.1.1 {
                prev.append(next.0)
            }
        })
        let selfCount = self.count
        let otherCount = other.count
        if selfCount != other.count {
            let minCount = Swift.min(selfCount, otherCount)
            let maxCount = Swift.max(selfCount, otherCount)
            diffs.append(contentsOf: (minCount..<maxCount))
        }
        return diffs
    }
}

