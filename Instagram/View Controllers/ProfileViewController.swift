//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Allison Reiss on 12/8/17.
//  Copyright © 2017 Allison Reiss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                // Load and show the login view controller
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
