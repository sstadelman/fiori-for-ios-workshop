//
//  ReuseIdentifying.swift
//  TravelExpenses
//
//  Created by Stadelman, Stan on 1/2/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import SAPFiori

protocol ReuseIdentifying: class {
    static var reuseIdentifier: String { get }
}

extension FUIObjectTableViewCell: ReuseIdentifying {}
