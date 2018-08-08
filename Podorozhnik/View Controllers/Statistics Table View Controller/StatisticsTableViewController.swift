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
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
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
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        let section = indexPath.section
        var trips: Int = 0
        var cost: Double = 0
        var averageFare: String = "0"
        
        switch indexPath.row {
        case 0:
            cell.transportImageView.image = UIImage(named: "BlueTrain")
            trips = statistics![section].tripsByMetro
            cost = statistics![section].costByMetro
            
        case 1:
            cell.transportImageView.image = UIImage(named: "BlueTrain")
            trips = 0
            cost = 0
            
        case 2:
            cell.transportImageView.image = UIImage(named: "BlueTrain")
            trips = 0
            cost = 0
            
        default:
            break
        }
        
        if trips != 0 {
            averageFare = numberFormatter.string(from: (cost / Double(trips)) as NSNumber)!
        } else {
            averageFare = "0"
        }
        
        cell.tripsLabel.text = "\(trips)"
        cell.averageFareLabel.text = averageFare
        cell.costLabel.text = "\(cost)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statistics?[section].month
    }

}
