//
//  SectionDataSource.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import UIKit

protocol SectionDataSource {
    
    func refresh()
    
    func tableView(_ tableView: UITableView, numberOfRowsIn section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt index: Int) -> UITableViewCell
}
