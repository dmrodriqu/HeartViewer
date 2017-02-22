//
//  ViewController.swift
//  HeartViewer
//
//  Created by Dylan Rodriquez on 2/20/17.
//  Copyright © 2017 Dylan Rodriquez. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    var heartRate = 0.0{
        didSet{
            if resultLabel != nil{
                updateUI()
            }
        }
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func startQuery(_ sender: UIButton) {
        firstQuery()
    }
    

    
    func firstQuery(){
        let queries = Queries()
        queries.fetchHeartRateWithCompletionHandler(){
            resuls, error in
            if resuls != nil{
                print ("HUEHUE")
                let queryResult = String(describing: resuls!)
                self.resultLabel.text = queryResult
            }else{
                print(error!)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let healthManagement = HealthManager()
        healthManagement.getHealthAuthorization(){succeeded, _ in
            // if succeeded or iOS
            guard succeeded || (TARGET_OS_SIMULATOR != 0) else {return}
            
        }
        resultLabel.text = String(heartRate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        resultLabel.text = String(heartRate)
    }
    
}

