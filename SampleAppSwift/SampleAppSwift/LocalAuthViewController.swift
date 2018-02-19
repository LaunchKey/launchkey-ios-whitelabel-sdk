//
//  LocalAuthViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 1/5/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

import Foundation

class LocalAuthViewController: UIViewController
{
    
    @IBOutlet weak var tfCountInput: UITextField!
    @IBOutlet weak var switchCount: UISwitch!
    @IBOutlet weak var switchType: UISwitch!
    @IBOutlet weak var switchKnowledge: UISwitch!
    @IBOutlet weak var switchInherence: UISwitch!
    @IBOutlet weak var switchPossession: UISwitch!
    @IBOutlet weak var btnGenerateAuth: UIButton!
    @IBOutlet weak var tfLARName: UITextField!
    @IBOutlet weak var tfExpirationDuration: UITextField!
    
    var localAuthRequestName: String?
    var policy: LKPolicy!
    var expirationDuration : Int32?
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        self.title = "Test Local Auth"
        
        tfCountInput.isEnabled = false
        switchKnowledge.isEnabled = false
        switchInherence.isEnabled = false
        switchPossession.isEnabled = false
        localAuthRequestName = ""
        expirationDuration = 60
        
        switchCount.addTarget(self, action: #selector (LocalAuthViewController.stateChangedCount(_:)), for: UIControlEvents.valueChanged)
        
        switchType.addTarget(self, action: #selector (LocalAuthViewController.stateChangedType(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector:#selector(deviceIsUnlinked), name: NSNotification.Name(rawValue: deviceUnlinked), object: nil)
    }
    
    func deviceIsUnlinked()
    {
        self.navigationController?.popViewController(animated:false)
    }
    
    func stateChangedCount(_ switchState: UISwitch)
    {
        if switchState.isOn
        {
            switchType.isEnabled = false
            tfCountInput.isEnabled = true
        }
        else
        {
            switchType.isEnabled = true
            tfCountInput.isEnabled = false
        }
    }
    
    func stateChangedType(_ switchState: UISwitch)
    {
        if switchState.isOn
        {
            switchCount.isEnabled = false
            switchKnowledge.isEnabled = true
            switchInherence.isEnabled = true
            switchPossession.isEnabled = true
        }
        else
        {
            switchCount.isEnabled = true
            switchKnowledge.isEnabled = false
            switchInherence.isEnabled = false
            switchPossession.isEnabled = false
        }
    }
    
    @IBAction func btnGenerateLocalAuthPressed(_ sender: Any)
    {
        localAuthRequestName = tfLARName.text
        LocalAuthManager.shared().setTitle(localAuthRequestName)
        let expirationDurationString = self.tfExpirationDuration.text
        if(expirationDurationString != nil)
        {
            LocalAuthManager.shared().setExpiration(Int32(expirationDurationString!)!)
        }
        else
        {
            LocalAuthManager.shared().setExpiration(expirationDuration!)
        }
        
        if switchCount.isOn || switchType.isOn
        {
            // Check type of Policy to be built
            if switchCount.isOn
            {
                policy = LKPolicy.make(countBuilder: { (builder) in
                    let countTotalString = self.tfCountInput.text
                    builder?.countTotal = Int32(countTotalString!)!
                })
            }
            else if switchType.isOn
            {
                policy = LKPolicy.make(typeBuilder: { (builder) in
                    
                    builder?.knowledge = self.switchKnowledge.isOn
                    builder?.inherence = self.switchInherence.isOn
                    builder?.possession = self.switchPossession.isOn
                })
            }
        
            self.presentLocalAuthWithPolicy(policy: policy)
        }
        else
        {
            policy = LKPolicy.make(countBuilder: { (builder) in
                builder?.countTotal = 0
            })
            self.presentLocalAuthWithPolicy(policy: policy)
        }
        
    }
    
    func presentLocalAuthWithPolicy(policy: LKPolicy)
    {
        LocalAuthManager.shared().presentLocalAuth(self.navigationController, with: policy, withCompletion: { (localAuthResponse, error) in
            
            self.displayResult(authenticated: localAuthResponse)
            print("local auth error: \(error)")
        })
    }
    
    func displayResult(authenticated: Bool)
    {
        if(authenticated)
        {
            let alert = UIAlertView()
            alert.title = "Approved"
            alert.message = "User authenticated"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "Denied"
            alert.message = "User denied"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    
}
