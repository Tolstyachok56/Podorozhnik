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
    
    // MARK: -
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    // MARK: - View life cycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statistics?.sort(by: { $0.month < $1.month})
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
            var averageTariff: String = "0.00"
            
            switch indexPath.row {
            case 0:
                cell.transportImageView.image = UIImage(named: "BlueTrain")
                trips = statistics![section].tripsByMetro
                cost = statistics![section].costByMetro
                
            case 1:
                cell.transportImageView.image = UIImage(named: "GreenBus")
                trips = statistics![section].tripsByGround
                cost = statistics![section].costByGround
                
            case 2:
                cell.transportImageView.image = UIImage(named: "YellowCommercial")
                trips = statistics![section].tripsByCommercial
                cost = statistics![section].costByCommercial
                
            default:
                break
            }
            
            if trips != 0 {
                averageTariff = numberFormatter.string(from: (cost / Double(trips)) as NSNumber)!
            }
            
            cell.tripsLabel.text = "\(trips)"
            cell.averageTariffLabel.text = averageTariff
            cell.costLabel.text = numberFormatter.string(from: cost as NSNumber)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountTableViewCell.reuseIdentifier, for: indexPath) as? TotalAmountTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            let monthStatistic = statistics![section]
            let totalAmount = monthStatistic.costByMetro
            
            cell.totalAmountLabel.text = numberFormatter.string(from: totalAmount as NSNumber)
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statistics?[section].month
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = headerView.textLabel?.font.withSize(CGFloat(20))
        headerView.textLabel?.textColor = UIColor.black
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }

}
