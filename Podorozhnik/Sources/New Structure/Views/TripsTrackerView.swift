//
//  TripsTrackerView.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol TripsTrackerViewDelegate: class {
    func tripsTrackerView(_ tripsTrackerView: TripsTrackerView, cardBalanceDidEndEditing newBalance: Double)
}

class TripsTrackerView: UIView {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var cardBalanceTextField: UITextField!
    
    @IBOutlet fileprivate weak var tripsByMetroLabel: UILabel!
    @IBOutlet fileprivate weak var tripsByGroundLabel: UILabel!
    @IBOutlet fileprivate weak var tripsByCommercialLabel: UILabel!
    
    @IBOutlet fileprivate weak var fareOfMetroLabel: UILabel!
    @IBOutlet fileprivate weak var fareOfGroundLabel: UILabel!
    @IBOutlet fileprivate weak var fareOfCommercialTextField: UITextField!
    
    @IBOutlet fileprivate weak var addTripByMetroButton: UIButton!
    @IBOutlet fileprivate weak var addTripByGroundButton: UIButton!
    @IBOutlet fileprivate weak var addTripByCommercialButton: UIButton!
    
    @IBOutlet fileprivate weak var reduceTripByMetroButton: UIButton!
    @IBOutlet fileprivate weak var reduceTripByGroundButton: UIButton!
    @IBOutlet fileprivate weak var reduceTripByCommercialButton: UIButton!
    
    
    // MARK: - Instance Properties
    var delegate: TripsTrackerViewDelegate?
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.cardBalanceTextField.text = viewModel.cardBalance
            
            self.tripsByMetroLabel.text = viewModel.tripsByMetro
            self.tripsByGroundLabel.text = viewModel.tripsByGround
            self.tripsByCommercialLabel.text = viewModel.tripsByCommercial
            
            self.fareOfMetroLabel.text = viewModel.metroFare
            self.fareOfGroundLabel.text = viewModel.groundFare
            self.fareOfCommercialTextField.placeholder = viewModel.commercialFare
        }
    }
    let currencyTextFieldDelegate = CurrencyTextFieldDelegate()
    let balanceTextFieldDelegate = CurrencyTextFieldDelegate()
    
    override func awakeFromNib() {
        self.cardBalanceTextField.delegate = balanceTextFieldDelegate
        self.cardBalanceTextField.tag = CurrencyTextFieldDelegate.Tag.transportCardBalance.rawValue
        
        self.fareOfCommercialTextField.delegate = currencyTextFieldDelegate
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        
        self.addTripByMetroButton.tag = TransportType.metro.tag
        self.addTripByGroundButton.tag = TransportType.ground.tag
        self.addTripByCommercialButton.tag = TransportType.commercial.tag
        
        self.reduceTripByMetroButton.tag = TransportType.metro.tag
        self.reduceTripByGroundButton.tag = TransportType.ground.tag
        self.reduceTripByCommercialButton.tag = TransportType.commercial.tag
        
        self.balanceTextFieldDelegate.transportCardBalanceDelegate = self
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        self.cardBalanceTextField.resignFirstResponder()
        self.fareOfCommercialTextField.resignFirstResponder()
    }

}

extension TripsTrackerView {
    
    struct ViewModel {
        private var publicTransportFaresController = PublicTransportFaresStateController()
        
        var cardBalance: String
        
        var tripsByMetro: String
        var tripsByGround: String
        var tripsByCommercial: String
        
        var metroFare: String
        var groundFare: String
        var commercialFare: String
    }
}

extension TripsTrackerView.ViewModel {
    
    init(_ card: TransportCard) {
        self.cardBalance = card.balance.rublesGroupedFormatting
        
        self.tripsByMetro = String(card.numberOfTripsByMetro)
        self.tripsByGround = String(card.numberOfTripsByGround)
        self.tripsByCommercial = String(card.numberOfTripsByCommercial)
        
        self.metroFare = "next: " + self.publicTransportFaresController.getMetroFare(numberOfTrip: card.numberOfTripsByMetro + 1).rublesGroupedFormatting
        self.groundFare = "next: " + self.publicTransportFaresController.getMetroFare(numberOfTrip: card.numberOfTripsByGround + 1).rublesGroupedFormatting
        self.commercialFare = 0.0.rublesGroupedFormatting
    }
}

extension TripsTrackerView: TransportCardBalanceDelegate {
    func transportCardBalanceTextField(_ textField: UITextField, cardBalanceDidEndEditing newBalance: Double) {
        self.delegate?.tripsTrackerView(self, cardBalanceDidEndEditing: newBalance)
    }
}

