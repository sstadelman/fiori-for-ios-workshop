//
//  ReportDetailsTableViewController.swift
//  TravelExpenseApp
//
//  Created by Stadelman, Stan on 2/23/18.
//  Copyright © 2018 Stadelman, Stan. All rights reserved.
//

import SAPFiori
import UIKit

class ReportDetailsTableViewController: FioriBaseTableViewController {
    
    // MARK: - Model
    
    private var report: ExpenseReportItemType!
    private var isExpenseItemListDirty: Bool = false

    func setReport(_ report: ExpenseReportItemType) {
        self.report = report
        
        self.objectHeader.headlineText = report.reportname
        self.objectHeader.subheadlineText = report.reportid
        self.objectHeader.tags = ["Active", "Not Customer Facing"].map({
            FUITag(title: $0)
        })
        self.objectHeader.bodyText = report.reportlocation
        self.objectHeader.footnoteText = report.rangeString()
    }

    // Hack: in Grouped table view mode, init the Object Header with a non-zero height, to prevent content offset adjustment https://stackoverflow.com/questions/18880341/why-is-there-extra-padding-at-the-top-of-my-uitableview-with-style-uitableviewst?page=2&tab=votes#comment54066953_18880341
    let objectHeader = FUIObjectHeader(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))

    // MARK: View controller hooks
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(FUIKeyValueFormCell.self, forCellReuseIdentifier: FUIKeyValueFormCell.reuseIdentifier)
        self.tableView.tableHeaderView = self.objectHeader
        self.tableView.allowsSelectionDuringEditing = false

        let addButton = UIBarButtonItem(image: FUIIconLibrary.system.create.withRenderingMode(.alwaysTemplate), landscapeImagePhone: nil, style: .plain, target: self, action: nil)
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.toggleEditing))
        self.navigationItem.rightBarButtonItems = [editButton, addButton]
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return self.report.expenseItems.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIKeyValueFormCell.reuseIdentifier, for: indexPath) as! FUIKeyValueFormCell
            cell.keyName = "Report Total"
            let totalAmt: Double = report.expenseItems.reduce(0) { $0 + $1.amount!.doubleValue() }
            cell.value = NumberFormatter(.currency).string(from: totalAmt as NSNumber)!
            cell.isEditable = false

            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIKeyValueFormCell.reuseIdentifier, for: indexPath) as! FUIKeyValueFormCell
            cell.keyName = "Amount Due Employee"
            let dueAmt: Double = report.expenseItems.filter({ $0.expenseType?.expensetypeid == "EMP" }).reduce(0) { $0 + $1.amount!.doubleValue() }
            cell.value = NumberFormatter(.currency).string(from: dueAmt as NSNumber)!
            cell.isEditable = false
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
            cell.preserveIconStackSpacing = true
            let expense = report.expenseItems[indexPath.row]
            cell.iconImages = expense.iconImages()
            cell.headlineText = expense.vendor
            if let date = expense.itemdate {
                cell.subheadlineText = DateFormatter(.medium).string(from: date.utc())
            }
            cell.footnoteText = "Employee Paid"
            cell.statusText = NumberFormatter(.currency).string(from: expense.amount!.doubleValue() as NSNumber)
            return cell
        }
    }
    
    override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }

    // MARK: - Table view delegate
    
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        let expense = report.expenseItems[indexPath.row]
        let detailViewController = ExpenseDetailTableViewController(style: .grouped)
        detailViewController.setExpense(expense)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entity = self.report.expenseItems[indexPath.row]
        entity.reportid = nil
        
        DataHandler.shared.service.updateEntity(entity, completionHandler: { [weak self] error in
            guard error == nil else {
                let errorBanner = FUIBannerMessageView()
                self?.objectHeader.bannerView = errorBanner
                errorBanner.show(message: "Failed to remove item from Report", withDuration: 4.0, animated: true)
                return
            }
            
            self?.tableView.beginUpdates()
            self?.report.expenseItems.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.endUpdates()
        })
    }
    
//    override func tableView(_ tableView: UITableView,
//                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let closeAction = UIContextualAction(style: .destructive, title: "Remove from\nReport") { [weak self] (action, view, success) in
//            guard let entity = self?.report.expenseItems[indexPath.row] else { success(false) }
//            entity.reportid = nil
//
//            DataHandler.shared.service.updateEntity(entity, completionHandler: { [weak self] error in
//                guard error == nil else {
//                    let errorBanner = FUIBannerMessageView()
//                    self?.objectHeader.bannerView = errorBanner
//                    errorBanner.show(message: "Failed to remove item from Report", withDuration: 4.0, animated: true)
//                    return success(false)
//                }
//
//                self?.tableView.beginUpdates()
//                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
//                self?.tableView.endUpdates()
//                success(true)
//            })
//        }
//
//        closeAction.backgroundColor = UIColor.preferredFioriColor(forStyle: .negative)
//
//        let modifyAction = UIContextualAction(style: .destructive, title:  "Accept\nTask", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Update action ...")
//            self.data[indexPath.row].is_accepted = true
//            self.reloadHandler()
//            success(true)
//        })
//        modifyAction.backgroundColor = UIColor.preferredFioriColor(forStyle: .map1)
//
//        return UISwipeActionsConfiguration(actions: [closeAction, modifyAction])
//    }

    // MARK: - Actions

    @objc func toggleEditing() {
        self.setEditing(!self.isEditing, animated: true)
        
        // If changes were made to the data set while in editing mode, reload cleanly
        if !isEditing && isExpenseItemListDirty {
            self.reloadExpenseItems()
        }
    }
    
    func reloadExpenseItems() {
        DataHandler.shared.service.loadProperty(ExpenseReportItemType.expenseItems, into: self.report) { [weak self] (error) in
            guard error == nil else {
                return print(error!)
            }
            self?.tableView.reloadData()
            self?.isExpenseItemListDirty = false
        }
    }
}
