//
//  StatisticsTableViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UITableViewController {

    // MARK: -
    
    var statistics: [MonthStatistics]?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (statistics?.isEmpty)! {
            self.showSimpleAlert(title: "There is no statistics yet", message: "")
        } else {
            statistics?.sort(by: { $0.month < $1.month})
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (statistics?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if indexPath.row != 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            
            var trips: Int = 0
            var cost: Double = 0
            var averageTariff: String = Double(0).priceFormat()
            
            switch indexPath.row {
            case 0:
                cell.transportImageView.image = UIImage(named: TransportImageName.metro)
                trips = statistics![section].tripsByMetro
                cost = statistics![section].costByMetro
                
            case 1:
                cell.transportImageView.image = UIImage(named: TransportImageName.ground)
                trips = statistics![section].tripsByGround
                cost = statistics![section].costByGround
                
            case 2:
                cell.transportImageView.image = UIImage(named: TransportImageName.commercial)
                trips = statistics![section].tripsByCommercial
                cost = statistics![section].costByCommercial
                
            default:
                break
            }
            
            if trips != 0 {
                averageTariff = (cost / Double(trips)).priceFormat()!
            }
            
            cell.tripsLabel.text = "\(trips)"
            cell.averageTariffLabel.text = averageTariff
            cell.costLabel.text = cost.priceFormat()
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountTableViewCell.reuseIdentifier, for: indexPath) as? TotalAmountTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            let monthStatistic = statistics![section]
            let totalAmount = monthStatistic.costByMetro + monthStatistic.costByGround + monthStatistic.costByCommercial
            
            cell.totalAmountLabel.text = totalAmount.priceFormat()
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statistics?[section].month
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(24), weight: .semibold)
        headerView.textLabel?.textColor = UIColor.black
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }

}
