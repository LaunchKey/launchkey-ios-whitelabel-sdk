//
//  PushPackageTestingViewController.swift
//  SampleAppSwift
//
//  Created by Steven Gerhard on 7/15/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

import Foundation
import UIKit

class PushPackageTestingViewController : UIViewController {
    @IBOutlet var pushPackageTextField: UITextField!
    @IBOutlet weak var labelTestPushPackage: UILabel!
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            pushPackageTextField.attributedPlaceholder = NSAttributedString(string: "Push Package", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderTextColor")!])
            labelTestPushPackage.textColor = UIColor(named:"viewTextColor")
        } else {
            pushPackageTextField.attributedPlaceholder = NSAttributedString(string: "Push Package", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            labelTestPushPackage.textColor = UIColor.black
        }
    }
    
    @IBAction func pressedSubmit(_ sender: UIButton) {
        if let payload = pushPackageTextField.text, payload.count > 0 {
            LKCAuthenticatorManager.sharedClient().handleThirdPartyPushPackage(payload)
        }
    }
}
