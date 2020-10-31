//
//  Api.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 19/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class Api {
    static let baseURL = "https://thespiritthief.com:443/"
    static let headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    static func getCount(request: SearchRequest, callback: @escaping (Int?) -> Void) {
        request.calculateCount = true
        request.setDeliveryCountry()
        print(request.toJSONString())
        let req = Alamofire.request(baseURL + "bottles/",
                                    method: .post,
                                    parameters: request.toJSON(),
                                    encoding: JSONEncoding.default,
                                    headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Bottle>>) in
                if (response.error == nil) {
                    callback(response.result.value!.meta!.count)
                } else {
                    callback(nil)
                }
        }
        request.calculateCount = false
    }
    
    static func searchBottles(request: SearchRequest, callback: @escaping (ApiResponse<Bottle>?) -> Void) -> DataRequest{
        let req = Alamofire.request(baseURL + "bottles/",
                                    method: .post,
                                    parameters: request.toJSON(),
                                    encoding: JSONEncoding.default,
                                    headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Bottle>>) in
                if (response.error == nil) {
                    callback(response.result.value!)
                } else {
                    print(response.error)
                    callback(nil)
                }
        }
        
        return req
    }
    
    static func getAutoCompleteOptions(for q: String, callback: @escaping ([String]) -> Void) -> DataRequest{
        let url = baseURL + "autocomplete"
        let params: [String : Any] = ["name" : q]
        
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: params)
            .responseArray { (response: DataResponse<[AutoCompleteOption]>) in
                if (response.error == nil) {
                    callback(response.result.value!.map({$0.name}))
                }
        }
    }
    
    static func getBottlers(request: BaseApiRequest, callback: @escaping ([String]) -> Void) {
        request.sortBy = "bottler"
        Alamofire.request(baseURL + "bottlers/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Bottler>>) in
                if (response.error == nil) {
                    let options = response.result.value!.results!.map({$0.name})
                    callback(options)
                }
        }
    }
    
    static func getCasks(callback: @escaping ([CaskType]) -> Void) {
        Alamofire.request(baseURL + "casks/",
                          method: .post,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<CaskType>>) in
                if (response.error == nil) {
                    callback(response.result.value!.results!)
                }
        }
    }
    
    static func getBrands(request: BaseApiRequest, callback: @escaping ([String]) -> Void) {
        request.sortBy = "brand"
        Alamofire.request(baseURL + "distilleries/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Distillery>>) in
                if (response.error == nil) {
                    let options = response.result.value!.results!.map({$0.name!}).filter({!$0.isEmpty})
                    callback(options)
                }
        }
    }
    
    static func getStores(for productId: UInt64, callback: @escaping (SortedStores?) -> Void) {
        let request = StoreRequest()
        request.productId = productId
        request.sortBy = "price"
        
        Alamofire.request(baseURL + "shops/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseArray { (response: DataResponse<[Store]>) in
                if (response.error == nil) {
                    callback(SortedStores(stores: response.result.value!))
                } else {
                    callback(nil)
                }
        }
    }
    
    static func getCountries(callback: @escaping ([Country]) -> Void) {
        let request = BaseApiRequest()
        request.sortBy = "country"
        
        Alamofire.request(baseURL + "countries/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Country>>) in
                if (response.error == nil) {
                    callback(response.result.value!.results!)
                }
        }
    }
    
    static func getRegions(callback: @escaping ([Region]) -> Void) {
        let request = BaseApiRequest()
        request.sortBy = "region"
        
        Alamofire.request(baseURL + "regions/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Region>>) in
                if (response.error == nil) {
                    callback(response.result.value!.results!)
                }
        }
    }
    
    static func getCategories(callback: @escaping ([Category]) -> Void) {
        let request = BaseApiRequest()
        request.sortBy = "category"
        
        Alamofire.request(baseURL + "types/",
                          method: .post,
                          parameters: request.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseObject { (response: DataResponse<ApiResponse<Category>>) in
                if response.error == nil {
                    callback(response.result.value!.results!)
                }
        }
    }
    
    static func getStats(callback: @escaping ([Stats]) -> Void) {
        Alamofire.request(baseURL + "stats/",
                          method: .post,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseArray { (response: DataResponse<[Stats]>) in
                if (response.error == nil) {
                    callback(response.result.value!)
                }
        }
    }
    
    static func getShopStats(callback: @escaping ([ShopStats]) -> Void) -> DataRequest{
        let url = baseURL + "shop_stats/"
        
        let req = BaseApiRequest()
        req.country.append(UserSettings.getDeliveryCountryName())
        print("REQ: " + req.toJSONString()!)
        
        return Alamofire.request(url,
                                 method: .post,
                                 parameters: req.toJSON(),
                                 encoding: JSONEncoding.default,
                                 headers: headers)
            .responseArray { (response: DataResponse<[ShopStats]>) in
                if (response.error == nil) {
                    callback(response.result.value!)
                }
        }
    }
    
    static func getMissingBarcodeOptions(for barcode: String, callback: @escaping (String?) -> Void) -> DataRequest{
        let url = "https://api.upcitemdb.com/prod/trial/lookup"
        let params: [String : Any] = ["upc" : barcode]
        
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: params)
            .responseObject { (response: DataResponse<MissingBarcode>) in
                let res = response.result.value
                var title: String? = nil
                if let mb = res {
                    if let items = mb.items {
                        if (items.count > 0) {
                            title = items[0].title
                        }
                    }
                }
                
                callback(title)
        }
    }
    
    static func repordInvalidImage(bottleId: String, imageUrl: String){
        let url = baseURL + "invalid_img/"
        
        let req = InvalidImage(bottleId: bottleId, imageUrl: imageUrl)
        
        print("REQ: " + req.toJSONString()!)
        
        Alamofire.request(url,
                          method: .post,
                          parameters: req.toJSON(),
                          encoding: JSONEncoding.default,
                          headers: headers)
    }
    
    static func addBarcode(bottleId: String, barcode: String, callback: @escaping (Bool) -> Void) {
        var params = ["ID": bottleId,
                      "barcode": barcode]
        
        Alamofire.request(baseURL + "add_barcode/",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).response(completionHandler: { (res) in
                            if let code = res.response?.statusCode {
                                callback(true)
                            } else {
                                callback(false)
                            }
                          })
    }
    
}
