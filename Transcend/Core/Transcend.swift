//
//  Transcend.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/14/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation
import Alamofire


class Transcend {
    
    //
    // Singletoner
    //
    class var shared: Transcend {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance : Transcend? = nil
        }
        
        // Create instance
        dispatch_once(&Static.onceToken){
            Static.instance = Transcend()
        }
        
        // Return static instance
        return Static.instance!
    }

    
    
    //
    //
    //
    private func _requestGET(target:TranscendModel,subscriber:RACSubscriber){
        let endpoint = target._request["endpoint"] as String
        let params = target._request["params"] as [String:AnyObject]

        Alamofire.request(.GET, endpoint, parameters: params)
            .response{ (request, response, data, error) in
                NSLog("\(response)")
                
            }.responseObject{ (_, _, object:TranscendModel?, _) -> Void in
                subscriber.sendNext(object)
            }
    }
    
    
    //
    //
    //
    func Signalable(target:TranscendModel) -> RACSignal {
        // Create signal from model
        return RACSignal.createSignal{ (subscriber:RACSubscriber!) -> RACDisposable! in
            self._requestGET(target, subscriber: subscriber)
            
            return RACDisposable()
        }
    }
    
    
    //
    //
    //
    func Hydrate<T: TranscendModelProtocol>(data:AnyObject!, completion: (T?,NSError?) -> Void) -> Self {
        completion(T(response: nil, representation: data),nil)

        return self
    }
    
}





