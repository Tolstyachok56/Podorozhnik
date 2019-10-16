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
    @IBOutlet private weak var cardBalanceTextField: UITextField!
    @IBOutlet private weak var lastTripDateLabel: UILabel!
    
    @IBOutlet private weak var cardBalanceViewContainer: UIView!
    @IBOutlet private weak var metroViewContainer: UIView!
    @IBOutlet private weak var groundViewContainer: UIView!
    @IBOutlet private weak var commercialViewContainer: UIView!
    
    @IBOutlet private weak var tripsByMetroLabel: UILabel!
    @IBOutlet private weak var tripsByGroundLabel: UILabel!
    @IBOutlet private weak var tripsByCommercialLabel: UILabel!
    
    @IBOutlet private weak var fareOfMetroLabel: UILabel!
    @IBOutlet private weak var fareOfGroundLabel: UILabel!
    @IBOutlet private weak var fareOfCommercialTextField: UITextField!
    
    @IBOutlet private weak var addTripByMetroButton: UIButton!
    @IBOutlet private weak var addTripByGroundButton: UIButton!
    @IBOutlet private weak var addTripByCommercialButton: UIButton!
    
    @IBOutlet private weak var reduceTripByMetroButton: UIButton!
    @IBOutlet private weak var reduceTripByGroundButton: UIButton!
    @IBOutlet private weak var reduceTripByCommercialButton: UIButton!
    
    
    // MARK: - Instance Properties
    var delegate: TripsTrackerViewDelegate?
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.cardBalanceTextField.text = viewModel.cardBalance
            self.lastTripDateLabel.text = viewModel.lastTripDate
            
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
        self.balanceTextFieldDelegate.transportCardBalanceDelegate = self
        
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
        
        self.addBorderAndShadow(to: self.cardBalanceViewContainer)
        self.addBorderAndShadow(to: self.metroViewContainer)
        self.addBorderAndShadow(to: self.groundViewContainer)
        self.addBorderAndShadow(to: self.commercialViewContainer)
    }
    
    private func addBorderAndShadow(to view: UIView) {
        view.addBorder(width: 1, color: AppColors.chateauGreen)
        view.addShadow(color: AppColors.chateauGreen, radius: 2, opacity: 0.5)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        self.cardBalanceTextField.resignFirstResponder()
        self.fareOfCommercialTextField.resignFirstResponder()
    }
    
    func hideKeyboard() {
        self.cardBalanceTextField.resignFirstResponder()
        self.fareOfCommercialTextField.resignFirstResponder()
    }

}

extension TripsTrackerView {
    
    struct ViewModel {
        private var publicTransportFaresController = PublicTransportFaresStateController()
        
        var cardBalance: String
        var lastTripDate: String
        
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
        self.lastTripDate = "Last: ".localized + (card.lastTrip?.date.dayTimeFormatting ?? "no trips".localized)
        
        self.tripsByMetro = String(card.numberOfTripsByMetro)
        self.tripsByGround = String(card.numberOfTripsByGround)
        self.tripsByCommercial = String(card.numberOfTripsByCommercial)
        
        self.metroFare = "Fare: ".localized + self.publicTransportFaresController.getMetroFare(numberOfTrip: card.numberOfTripsByMetro + 1).rublesGroupedFormatting
        self.groundFare = "Fare: ".localized + self.publicTransportFaresController.getGroundFare(numberOfTrip: card.numberOfTripsByGround + 1).rublesGroupedFormatting
        self.commercialFare = 0.0.rublesGroupedFormatting
    }
}

extension TripsTrackerView: TransportCardBalanceDelegate {
    func transportCardBalanceTextField(_ textField: UITextField, cardBalanceDidEndEditing newBalance: Double) {
        self.delegate?.tripsTrackerView(self, cardBalanceDidEndEditing: newBalance)
    }
}

