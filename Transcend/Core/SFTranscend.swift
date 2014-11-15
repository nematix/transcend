//
//  SFTranscend.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/14/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation
import Alamofire
import Realm


@objc public protocol SFTranscendModelProtocol {
    //var _request:[String:Any] {get}
    
    init(response: NSHTTPURLResponse?, representation: AnyObject)
}


class SFTranscend {
    
    //
    // Singletoner
    //
    class var shared: SFTranscend {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance : SFTranscend? = nil
        }
        
        // Create instance
        dispatch_once(&Static.onceToken){
            Static.instance = SFTranscend()
        }
        
        // Return static instance
        return Static.instance!
    }

    
    
    //
    //
    //
    private func _requestGET(target:SFTranscendModel,subscriber:RACSubscriber){
        let endpoint = target._request["endpoint"] as String
        let params = target._request["params"] as [String:AnyObject]

        Alamofire.request(.GET, endpoint, parameters: params)
            .response{ (request, response, data, error) in
                NSLog("\(response)")
                
            }.responseObject{ (_, _, object:SFTranscendModel?, _) -> Void in
                subscriber.sendNext(object)
            }
    }
    
    
    //
    //
    //
    func Signalable(target:SFTranscendModel) -> RACSignal {
        // Create signal from model
        return RACSignal.createSignal{ (subscriber:RACSubscriber!) -> RACDisposable! in
            self._requestGET(target, subscriber: subscriber)
            
            return RACDisposable()
        }
    }
    
    
    //
    //
    //
    func Hydrate<T: SFTranscendModelProtocol>(data:AnyObject!, completion: (T?,NSError?) -> Void) -> Self {
        completion(T(response: nil, representation: data),nil)

        return self
    }
    
}



class SFTranscendModel: NSObject, SFTranscendModelProtocol {
    var _request:[String:Any] = [:]
    
    required init(response: NSHTTPURLResponse?, representation: AnyObject) {
        super.init()
        
        // Get self reflection
        let me = reflect(self)
        
        // Iterate all property
        for index in 0 ..< me.count {
            let (key,propertyObject) = me[index]
            
            if let propertyValue = representation.valueForKeyPath(key) as? String {
                self.setValue(propertyValue, forKey: key)
            }
        }
    }
}




extension Alamofire.Request {
    
    public func responseObject<T: SFTranscendModelProtocol>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        // Custom serializer
        let serializer: Serializer = { (request, response, data) in
            // JSON serializer instance
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            
            // Serialize response
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            
            // Check i success return with type of T
            if response != nil && JSON != nil {
                return (T(response: response!, representation: JSON!), nil)
            } else {
                // Return ni and error info from serializer
                return (nil, serializationError)
            }
        }
        
        // Return response with created serializer to customizer
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            // Call completion block provided
            completionHandler(request, response, object as? T, error)
        })
    }
    
}
