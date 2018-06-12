//
//  ViewController.swift
//  TableViewReloadAnimation
//
//  Created by yiqiwang(王一棋) on 2018/6/5.
//  Copyright © 2018年 yiqiwang(王一棋). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectedBarItem: UIBarButtonItem? = nil {
        willSet {
            selectedBarItem?.tintColor = UIColor.black
        }
        didSet {
            selectedBarItem?.tintColor = UIColor.red
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initNavigationbar()
        configEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: Init UI

    private func initUI() {
        view.backgroundColor = UIColor.white

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    // MARK: Init Navigationbar

    private func initNavigationbar() {
        let topItem = UIBarButtonItem(title: "top", style: .plain, target: self, action: #selector(self.reloadTableViewWithAnimation(sender:)))
        let leftItem = UIBarButtonItem(title: "left", style: .plain, target: self, action: #selector(self.reloadTableViewWithAnimation(sender:)))
        let bottomItem = UIBarButtonItem(title: "bottom", style: .plain, target: self, action: #selector(self.reloadTableViewWithAnimation(sender:)))
        let rightItem = UIBarButtonItem(title: "right", style: .plain, target: self, action: #selector(self.reloadTableViewWithAnimation(sender:)))
        let rotateItem = UIBarButtonItem(title: "rotate", style: .plain, target: self, action: #selector(self.reloadTableViewWithAnimation(sender:)))
        self.navigationItem.leftBarButtonItems = [topItem, leftItem, bottomItem, rightItem, rotateItem]
    }

    // MARK: Config Events

    private func configEvents() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: Action

    @objc private func reloadTableViewWithAnimation(sender: UIBarButtonItem) {
        self.selectedBarItem = sender

        var style: UITableViewReloadAnimationStyle
        switch self.selectedBarItem?.title {
        case "top":
            style = .fromTop(offset: tableView.frame.size.height)
        case "left":
            style = .fromLeft(offset: tableView.frame.size.width)
        case "bottom":
            style = .fromBottom(offset: tableView.frame.size.height)
        case "right":
            style = .fromRight(offset: 50)
        default:
            style = .rotation(angle: CGFloat(-Double.pi / 2))
        }
        tableView.reloadData(with: style)
    }

    // MARK: Properties

    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.contentView.backgroundColor = UIColor(hex: "dcff93")
        header.textLabel?.text = "header section=\(section)"
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UITableViewHeaderFooterView()
        footer.contentView.backgroundColor = UIColor(hex: "f2debd")
        footer.textLabel?.text = "footer section=\(section)"
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell!.backgroundColor = UIColor(hex: "b8f1ed")
        cell!.textLabel?.text = "section=\(indexPath.section), item=\(indexPath.item)"
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

