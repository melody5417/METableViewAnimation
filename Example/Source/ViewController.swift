//
//  ViewController.swift
//  Example
//
//  Created by yiqiwang(王一棋) on 2018/6/13.
//  Copyright © 2018年 yiqiwang(王一棋). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate static let cellIdentifier = "cell"

    var dataSource: [UIViewController.Type] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        configEvents()
        loadDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Init UI

    private func initUI() {
        view.backgroundColor = UIColor.white
        title = "TableView 动画合集"

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    // MARK: - Config Events

    private func configEvents() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Load DataSource

    private func loadDataSource() {
        dataSource.append(ReloadViewController.self)
    }

    // MARK: - Properties

    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ViewController.cellIdentifier)
        }
        cell.textLabel?.text = String(describing: dataSource[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clazz = dataSource[indexPath.item]
        let vc = clazz.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

