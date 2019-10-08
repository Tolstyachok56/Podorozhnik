//
//  StatisticsViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 11/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Enums
    private enum StatisticsDimension: Int {
        case month = 0
        case day
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 61
            self.tableView.separatorColor = AppsColors.chateauGreen
        }
    }
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: - Properties
    var transportCardsController: TransportCardsStateController!
    var statistics: [Date: [Trip]]?
    var transportCard: TransportCard? { return self.transportCardsController.transportCards.first }
    private var statisticsDimension: StatisticsDimension = .month {
        didSet {
            self.updateViewWithStatistics()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let segmentedControl = UISegmentedControl(items: ["Month".localized, "Day".localized])
        segmentedControl.addTarget(self, action: #selector(dimensionSegmentedControlPressed(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = self.statisticsDimension.rawValue
        segmentedControl.autoresizingMask = .flexibleWidth
        segmentedControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 30)
        if #available(iOS 13.0, *) {
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            segmentedControl.setTitleTextAttributes([.foregroundColor: AppsColors.chateauGreen], for: .normal)
            segmentedControl.selectedSegmentTintColor = AppsColors.chateauGreen
        } else {
            segmentedControl.tintColor = AppsColors.chateauGreen
        }
        self.navigationItem.titleView = segmentedControl
        
        self.navigationController?.navigationBar.addShadow(color: AppsColors.chateauGreen, radius: 4, opacity: 0.5)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateViewWithStatistics()
    }
    
    // MARK: - View Methods
    private func updateViewWithStatistics() {
        self.updateStatistics(to: self.statisticsDimension)
        if let statistics = self.statistics, statistics.isEmpty {
            self.tableView.isHidden = true
            self.messageLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.messageLabel.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Methods
    private func updateStatistics(to dimension: StatisticsDimension) {
        guard let transportCard = self.transportCard else { return }
        switch dimension {
        case .month:
            self.statistics = transportCard.monthStatistics
        case .day:
            self.statistics = transportCard.dayStatistics
        }
    }
    
    // MARK: - Actions
    @objc func dimensionSegmentedControlPressed(_ sender: UISegmentedControl) {
        self.statisticsDimension = StatisticsDimension(rawValue: sender.selectedSegmentIndex) ?? .month
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
        guard let dimension = self.statistics?.keys.sorted(by: { $0<$1 }).reversed()[indexPath.section],
            let trips = self.statistics?[dimension] else { return UITableViewCell() }
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
        switch self.statisticsDimension {
        case .month:
            return self.statistics?.keys.sorted(by: { $0<$1 }).reversed()[section].monthFormatting ?? "?"
        case .day:
            return self.statistics?.keys.sorted(by: { $0<$1 }).reversed()[section].dayFormatting ?? "?"
        }
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



