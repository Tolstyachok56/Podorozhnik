//
//  SMSViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 14.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class SMSViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardNumberTextField: CardNumberTextField!
    @IBOutlet weak var amountTextField: AmountTextField!
    
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
    
    // MARK: -
    
    var card: Card?
    var amount: Int? = 0
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        cardNumberTextField.setup(card: card!)
        amountTextField.setup(amount: amount!)
        setupTopTextView()
        setupBottomTextView()
    }
    
    private func setupTopTextView() {
        let attributedString = getAttributedStringWithLink(
            string: "You can replenish the card from your mobile phone account by sending SMS to number 7878 (Information on the subway's website)",
            link: Link.metroInfo,
            rangeOfLinkInString: NSMakeRange(89, 35)
        )

        self.topTextView.attributedText = attributedString
    }
    
    private func setupBottomTextView() {
        let attributedString = getAttributedStringWithLink(
            string: "In response, a SMS will come with the amount of the commission and a request for confirmation of payment. (Trust the commission fee in advance).\n\nAfter replenishing the card account, the accrued funds must be activated by attaching the card to any card verification device in the metro.",
            link: Link.commission,
            rangeOfLinkInString: NSMakeRange(107, 35)
        )
        
        self.bottomTextView.attributedText = attributedString
    }
    
    private func getAttributedStringWithLink(string: String, link: String, rangeOfLinkInString range: NSRange) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        
        let textAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraph
        ]
        
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: link)!,
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        attributedString.setAttributes(textAttributes, range: NSMakeRange(0, attributedString.length))
        attributedString.setAttributes(linkAttributes, range: range)
        
        return attributedString
    }
    
    private func updateView() {
        cardNumberTextField.update()
        amountTextField.setup(amount: amount!)
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cardNumberTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func makeTopUpTheBalanceMessage(_ sender: UIButton) {
        let cardNumber = (card?.number)!
        self.amount = Int(amountTextField.text!)
        
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "pod \(cardNumber) \(amount!)"
            messageVC.recipients = [MessageSettings.recipient]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        } else {
            showSimpleAlert(title: "Sorry...", message: "This device is not configured to send messages.")
        }
    }
    
    // MARK: - Notifications methods
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc private func keyboardWasShown(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect, let tabBarHeight = tabBarController?.tabBar.frame.height {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - tabBarHeight + 10, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

}

// MARK: - MFMessageComposeViewControllerDelegate methods

extension SMSViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextViewDelegate methods

extension SMSViewController: UITextViewDelegate {
    
}
