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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let section = indexPath.section
        
        switch indexPath.row {
        case 0:
            let trips = statistics![section].tripsByMetro
            let cost = statistics![section].costByMetro
            cell.textLabel?.text = "Metro trips: \(trips), cost: \(cost)"
        case 1:
            cell.textLabel?.text = "Ground transport"
        case 2:
            cell.textLabel?.text = "Commercial transport"
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statistics?[section].month
    }

}
