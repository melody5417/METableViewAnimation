//
//  UITableView+Reload.swift
//  TableViewReloadAnimation
//
//  Created by yiqiwang(王一棋) on 2018/6/5.
//  Copyright © 2018年 yiqiwang(王一棋). All rights reserved.
//

import Foundation
import UIKit

public enum UITableViewReloadAnimationStyle {
    case fromTop(offset: CGFloat)
    case fromLeft(offset: CGFloat)
    case fromBottom(offset: CGFloat)
    case fromRight(offset: CGFloat)
    case rotation(angle: CGFloat)
    case rotation3D(anchor: CGPoint, transfrom: CATransform3D)

    func setStartValues(tableView: UITableView, for cell: UIView) {
        cell.alpha = 0
        switch self {
        case .fromTop(let offset):
            cell.frame.origin.y -= offset
        case .fromLeft(let offset):
            cell.frame.origin.x -= offset
        case .fromBottom(let offset):
            cell.frame.origin.y += offset
        case .fromRight(let offset):
            cell.frame.origin.x += offset
        case .rotation(let angle):
            cell.transform = CGAffineTransform(rotationAngle: angle)
        case .rotation3D(let anchor, let transfrom):
            let oldFrame = cell.frame
            cell.layer.anchorPoint = anchor
            cell.layer.transform = transfrom
            cell.frame = oldFrame
        }
    }

    func setEndValues(tableView: UITableView, for cell: UIView) {
        cell.alpha = 1
        switch self {
        case .fromTop(let offset):
            cell.frame.origin.y += offset
        case .fromLeft(let offset):
            cell.frame.origin.x += offset
        case .fromBottom(let offset):
            cell.frame.origin.y -= offset
        case .fromRight(let offset):
            cell.frame.origin.x -= offset
        case .rotation(_):
            cell.transform = .identity
        case .rotation3D(_, _):
            cell.layer.transform = CATransform3DIdentity
        }
    }
}

extension UITableView {

    typealias Complition = (() -> Void)
    typealias HeaderFooterTuple = (header: UIView?, footer: UIView?)
    typealias VisibleHeaderFooter = [Int: HeaderFooterTuple]

    public func reloadData(with animation: UITableViewReloadAnimationStyle) {
        reloadData()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.visibleRowsBeginAnimation(with: animation)
        }
    }

    public func reloadData(with animation: UITableViewReloadAnimationStyle, duration: TimeInterval, interval: TimeInterval, completion: ((Bool) -> Swift.Void)? = nil) {
        reloadData()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.visibleRowsBeginAnimation(with: animation, duration: duration, interval: interval, completion: completion)
        }
    }

    private func visibleRowsBeginAnimation(with animation: UITableViewReloadAnimationStyle, duration: TimeInterval = 0.2, interval: TimeInterval = 0.01, completion: ((Bool) -> Swift.Void)? = nil) {

        let damping: CGFloat = 1
        let velocity: CGFloat = 0

        let indexPathsForVisibleRows = self.indexPathsForVisibleRows
        let grouped = indexPathsForVisibleRows?.grouped(by: { (indexPath: IndexPath) -> Int in
            return indexPath.section
        }).sorted(by: { $0.key < $1.key })

        let visibleHeaderFooter = self.visibleSectionIndexes()
        var visibleViews = [UIView]()

        for items in grouped! {
            var currentViews: [UIView] = items.value.compactMap { self.cellForRow(at: $0) }
            if let header = visibleHeaderFooter[items.key]?.header {
                currentViews.insert(header, at: 0)
            }

            if let footer = visibleHeaderFooter[items.key]?.footer {
                currentViews.append(footer)
            }

            visibleViews += currentViews
        }

        let visibleCellsCount = Double(visibleViews.count)
        visibleViews.enumerated().forEach { item in
            let anchor = item.element.layer.anchorPoint
            let frame = item.element.frame

            let delay: TimeInterval = duration / visibleCellsCount * Double(item.offset) + Double(item.offset) * interval
            animation.setStartValues(tableView: self, for: item.element)

            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: .curveEaseInOut,
                animations: {
                    animation.setEndValues(tableView: self, for: item.element)
            }, completion: { finished in
                item.element.layer.anchorPoint = anchor
                item.element.frame = frame
            })
        }
    }
}

extension UITableView {
    fileprivate func visibleSectionIndexes() -> VisibleHeaderFooter {
        let visibleTableViewRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: bounds.size.width, height: bounds.size.height)

        var visibleHeaderFooter: VisibleHeaderFooter = [:]
        (0..<numberOfSections).forEach {
            let headerRect = rectForHeader(inSection: $0)
            let footerRect = rectForFooter(inSection: $0)

            let header: UIView? = visibleTableViewRect.intersects(headerRect) ? headerView(forSection: $0) : nil
            let footer: UIView? = visibleTableViewRect.intersects(footerRect) ? footerView(forSection: $0) : nil

            let headerFooterTuple: HeaderFooterTuple = (header: header, footer: footer)
            visibleHeaderFooter[$0] = headerFooterTuple
        }

        return visibleHeaderFooter
    }
}

extension Array {
    fileprivate func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
}
