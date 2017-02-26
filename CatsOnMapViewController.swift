//
//  CatsOnMapViewController.swift
//  CatsOnMap
//
//  Created by Nikolay Shubenkov on 26/02/2017.
//  Copyright © 2017 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MapKit

class CatsOnMapViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRequest()
        // Do any additional setup after loading the view.
    }
    
    func testRequest(){
        let servise = APIServise()
        servise.find(searchWord: "котик", success: { photos in
            
            print("а вот и котики:\(photos)")
            
        }) { error in
            
        print("error:\(error)")
        }
    }
}
