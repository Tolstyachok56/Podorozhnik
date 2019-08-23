//
//  MainTabBarController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 21/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let transportCardsController = TransportCardsStateController()
    private let publicTransportFaresController = PublicTransportFaresStateController()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDataSourcesForViewControllers()
        self.setupView()
    }
    
    // MARK: - View Methods
    private func setupView() {
        self.tabBar.tintColor = AppsColors.chateauGreen
        self.tabBar.addShadow(color: AppsColors.chateauGreen, radius: 4, opacity: 0.5)
    }
    
    // MARK: - Methods
    private func setDataSourcesForViewControllers() {
        guard let viewControllers = self.viewControllers else { return }
        
        for viewController in viewControllers {
            if let tripsViewController = viewController as? TripsTrackerViewController {
                tripsViewController.transportCardsController = self.transportCardsController
                tripsViewController.publicTransportFaresController = self.publicTransportFaresController
            } else if let calculatorViewController = viewController as? CalculatorViewController {
                calculatorViewController.transportCardsController = self.transportCardsController
                calculatorViewController.publicTransportFaresController = self.publicTransportFaresController
            } else if let statisticsViewController = viewController as? StatisticsViewController {
                statisticsViewController.transportCardsController = self.transportCardsController
            }
        }
    }

}
