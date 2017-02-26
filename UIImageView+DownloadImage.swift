//
//  UIImageView+DownloadImage.swift
//  CatsOnMap
//
//  Created by Nikolay Shubenkov on 26/02/2017.
//  Copyright © 2017 Nikolay Shubenkov. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func showImage(with link:String){
        
        self.image = nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard  let url = URL(string:link) else {
            return
        }

        let task = session.dataTask(with: url) { (data, _, _) in
            //когда загрузка заквершится,
            //проверим, что к нам тчо-то пришло, т.е. есть 
            //набор байт, который потенциально возможно является кратинкой
            guard let imageData = data,
                //попробуем получить картинку из сырого набора байт
                let image = UIImage(data: imageData) else {
                    return
            }
            //Обязательно важно не забыть переключиться в основной потом приложения
            //в нем происходит обработка UI и взаимодействия с пользователем
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
        
    }
    
}
