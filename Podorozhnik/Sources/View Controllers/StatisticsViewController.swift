//
//  StatisticsViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 11/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 61
            self.tableView.separatorColor = AppsColors.chateauGreen
        }
    }
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    
    // MARK: - Properties
    var transportCardsController: TransportCardsStateController!
    var statistics: [String: [Trip]]?
    var transportCard: TransportCard? { return self.transportCardsController.transportCards.first }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let transportCard = self.transportCard {
            self.statistics = transportCard.monthStatistics
            if let statistics = self.statistics, statistics.isEmpty {
                self.tableView.isHidden = true
                self.messageLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.messageLabel.isHidden = true
            }
        }
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.statistics?.keys)?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let month = self.statistics?.keys.sorted(by: { $0<$1 })[indexPath.section],
            let trips = self.statistics?[month] else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath) as! StatisticsTableViewCell
            cell.viewModel = StatisticsTableViewCell.ViewModel(transportType: .metro, trips: trips.filter {$0.transportType == .metro})
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath) as! StatisticsTableViewCell
            cell.viewModel = StatisticsTableViewCell.ViewModel(transportType: .ground, trips: trips.filter {$0.transportType == .ground})
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath) as! StatisticsTableViewCell
            cell.viewModel = StatisticsTableViewCell.ViewModel(transportType: .commercial, trips: trips.filter {$0.transportType == .commercial})
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTotalAmountTableViewCell.identifier, for: indexPath) as! StatisticsTotalAmountTableViewCell
            cell.viewModel = StatisticsTotalAmountTableViewCell.ViewModel(trips)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.statistics?.keys.sorted(by: { $0<$1 })[section] ?? "?"
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(24), weight: .bold)
        headerView.textLabel?.textColor = AppsColors.chateauGreen
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
}



