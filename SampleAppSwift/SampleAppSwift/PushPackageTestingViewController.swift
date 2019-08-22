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
    
    @IBAction func pressedSubmit(_ sender: UIButton) {
        if let payload = pushPackageTextField.text, payload.count > 0 {
            AuthenticatorManager.sharedClient().handlePushPackage(payload)
        }
    }
}
