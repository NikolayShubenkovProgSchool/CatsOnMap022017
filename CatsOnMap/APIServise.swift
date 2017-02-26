//
//  APIServise.swift
//  CatsOnMap
//
//  Created by Nikolay Shubenkov on 26/02/2017.
//  Copyright © 2017 Nikolay Shubenkov. All rights reserved.
//

import Foundation

class APIServise
{
    enum APIError:Error {
        case wrongResponse
        case photosNotFound
    }
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3d790e81c37781d21d0a4cbf7f563a9f&tags=cat&has_geo=&format=json&nojsoncallback=1&auth_token=72157680684632046-2372594dc9e309b7&api_sig=9a2b58395233f0950442451b1b42318e
    func  find(searchWord:String, success:@escaping ( ([PhotoInfo])->Void),
               failure:@escaping ( (Error)->Void)) {
        let url = buildURL(with: searchWord)
        
        //будет создан объект типа URLSessionDataTask
        //его назначение: получить из сети данные
        //и выполнить блок кода, передав туда результат работы,
        //возможную ошибку
        //
        let task = session.dataTask(with: url) { (data, response, error) in
            print("response:\(response)\nerror:\(error)")
            
            guard error == nil else {
                
                failure(error!)
                return
            }
            //проверим, что от сервера пришел отет
            //и помимо ответа пришли данные
            guard let serverResponse = response as? HTTPURLResponse,
                let jsonData = data else {
                    failure(APIError.wrongResponse)
                    return
            }
            
            //
            guard serverResponse.statusCode == 200 else {
                failure(APIError.wrongResponse)
                return
            }
            //попытаемся сконвертировать полученные данные в  словарь типа [String:Any]
            guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData,
                                                          options: []),
                let dictionary = jsonObject as? [String:Any] else {
                    failure(APIError.wrongResponse)
                    return
            }
            
            let photos = self.buildPhotos(from: dictionary)
            guard photos.count > 0 else {
                failure(APIError.photosNotFound)
                return
            }
            
            success(photos)
        }
        //этот метод запустит выполнение нашей задачи
        //по получению данных из сети
        task.resume()
    }
    
    private func buildPhotos(from json:[String:Any])->[PhotoInfo]
    {
        //получим по ключу photos словарь
        guard let photosContainer = json["photos"] as? [String:Any],
            //для словаря photos попробуем получить массив словарей [String:Any]
            let jsonList = photosContainer["photo"] as? [ [String:Any] ] else {
                return []
        }
        
        //пустой массив для наших объектов
        var photos = [PhotoInfo]()
        
        //попробуем для каждого джейсона создать фото и вставит в массив
        for photoJson in jsonList {
            if let photo = PhotoInfo(json: photoJson) {
                photos.append(photo)
            }
        }
        return photos
    }
    
    private func buildURL(with searchWord:String)->URL
    {
        let serviseLink = "https://api.flickr.com/services/rest/"
        
        //сюда мы вставим параметры команды АПИ
        var params = [String:Any]()
        
        params["method"] = "flickr.photos.search"
        params["api_key"] = "2b2c9f8abc28afe8d7749aee246d951c"
        params["tags"] = searchWord
        params["format"] = "json"
        params["has_geo"] = true
        params["nojsoncallback"] = 1
        
        params["extras"] = "geo,url_s,url_l"
        
        var paramsAsString = String()
        
        for (key,value) in params {
            paramsAsString.append("\(key)=\(value)&")
        }
       
        //эта строка может содрежать недопустимые символы для параметров ссылки.
        //поэтому мы ее преобразуем. (ввведите в поисковике
        //любой запрос и посмотрите, что выводится в ссылке с этим запросом
        //вы увидите, что часть символов меняется еа вид %XX
        paramsAsString = paramsAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let link = serviseLink + "?" + paramsAsString
        print(link)
        
        return URL(string: link)!
    }
    
}
