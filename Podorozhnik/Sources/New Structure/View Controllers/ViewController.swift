//
//  ViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    // MARK: - Properties
    private let cardsController = TransportCardsController()
    private let publicTransportFaresController = PublicTransportFaresControler()
    private var card: TransportCard?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.card = self.cardsController.transportCards.first
        self.cardNumberLabel.text = self.card?.code
    }
    
    

}
