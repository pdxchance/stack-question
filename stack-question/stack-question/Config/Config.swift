//
//  Config.swift
//  stack-question
//
//  Created by Deanne Chance on 8/7/20.
//  Copyright © 2020 Deanne Chance. All rights reserved.
//

import Foundation
import Alamofire

let API_KEY = "u225vZYSBzkUrYVt61gaqg(("

let baseURL = "https://api.stackexchange.com//2.2"
let searchFilter = "/search/advanced?site=stackoverflow&filter=!5-dmZUPQyv_-cPv(D30VgU)hf1C)YXwx*dvVom&accepted=true&answers=2"

func requestGET(_ strURL: String, params: [String : Any]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void) {
    
    AF.request(strURL, parameters: params).validate().responseJSON { (responseObject) -> Void in

        switch(responseObject.result) {
            case .success:
                if let resData = responseObject.data {
                    success(resData)
                }
            case .failure:
                let error : Error = responseObject.error!
                failure(error)
        }
    }
}
