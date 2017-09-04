//
//  ViewController.swift
//  SpreebieCurrencyPickerExample
//
//  Created by Thabo David Klass on 01/09/2017.
//  Copyright © 2017 Open Beacon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// The currency outlet button
    @IBOutlet weak var currencyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToCurrencyPage") {
            let navigator = segue.destination as? UINavigationController
            
            let cltvc = navigator!.topViewController as! CurrencyListTableViewController
            
            cltvc.vc = self
        }
    }
}

