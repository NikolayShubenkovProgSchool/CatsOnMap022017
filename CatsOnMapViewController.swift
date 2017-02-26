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

    @IBOutlet var mapView: MKMapView!
    
    var photos = [PhotoInfo]() {
        didSet {
            updateMapView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRequest()
        // Do any additional setup after loading the view.
    }
    
    private func updateMapView(){
        // удалим предыдущие метки
        clearMapView()
        self.mapView.addAnnotations(photos)
    }
    
    private func clearMapView(){
        //annotations = это метки на карте
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
    private func testRequest(){
        let servise = APIServise()
        servise.find(searchWord: "котэ", success: { photos in
            
            print("а вот и коты:\(photos)")
            
            //т.к. полчение данных из сети выполняется в фоне, 
            //тем самым не затормаживая работу интерфейса приложения
            //то и это замыкание вызывает в фоновом потоке
            //если в фоновом потоке обращаться к UI
            //это может привести к непредсказуемым последствиям
            //поэтому переключимся в основной поток, т.к.
            //нам необхоидмо обновить контент приложения
            DispatchQueue.main.async {
                self.photos = photos
            }
            
            
        }) { error in
            
        print("error:\(error)")
        }
    }
}
