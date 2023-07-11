//
//  PopoverPresentationTableViewController.swift
//  PullDownPopUpPrac
//
//  Created by Chun-Li Cheng on 2022/7/1.
//

import UIKit

class PopoverPresentationTableViewController: UITableViewController {
    // MARK: - Properties
    private var items = ["天干", "地支", "生年", "大運"]
    private var selectedItems = Set<Int>()
    private let identifier = "checklistCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊 table view cell 的 ID 以重複建構 cell
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: identifier)
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath)
        cell.textLabel?.text = items[indexPath.row]

        // 確認 cellRow 是否有 checkmark
        if selectedItems.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
            // 若點擊的位置在該 indexPathRow
            if let cell = tableView.cellForRow(at: indexPath) {
                // 改變 checkmark 狀態
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    // 記錄 checkmark 狀態
                    selectedItems.remove(indexPath.row)
                } else {
                    cell.accessoryType = .checkmark
                    selectedItems.insert(indexPath.row)
                }
                // 選取 cellRow 反白會消失
                tableView.deselectRow(at: indexPath, animated: true)
            }
    }
    

}
