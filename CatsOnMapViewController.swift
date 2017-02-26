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
        
        mapView.delegate = self
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

extension CatsOnMapViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let photoToShow = annotation as? PhotoInfo else {
            return nil
        }
        
        let id = "PhotoAnnotationID"
        
        var photoView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if photoView == nil {
            photoView = MKPinAnnotationView(annotation: photoToShow,
                                    reuseIdentifier:id )
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 50,
                                                  height: 50))
        
        //картинка будет сохранять пропорции
        //таким образом, чтобы полностью заполнить ImageView
        imageView.contentMode = .scaleAspectFill
        
        imageView.showImage(with: photoToShow.iconLink)
        
        //сделаем imageView как всплывающее вью при тапе
        photoView?.leftCalloutAccessoryView = imageView
        
        //таогда наша картинка будет появлятся при тапе
        photoView?.canShowCallout = true
        
        photoView?.annotation = photoToShow
        
        return photoView
    }
}
