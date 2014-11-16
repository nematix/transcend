//
//  Transcend.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/14/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation



// Tuplec Equatable
func ==<L,R>(r:Tuplec<L,R>,l:Tuplec<L,R>) -> Bool {
    return r.hashValue == l.hashValue
}

// Tuplec Hashable
class Tuplec<L,R> : Hashable {
    var _tuplet: (Any,Any)
    
    var hashValue: Int {
        get {
            let leftTupleReflection = reflect(_tuplet.0)
            let leftHash = leftTupleReflection.value
            
            let rightTupleReflection = reflect(_tuplet.1)
            let rightHash = rightTupleReflection.value
            
            return "\(leftHash)\(rightHash)".hashValue
        }
    }
    
    init(l:L,r:R){
        _tuplet = (l,r)
    }
}


// Tuplec infix operator
infix operator ! {}
func ! <L,R>(l:L,r:R) -> Tuplec<L,R> {
    return Tuplec(l: l,r: r)
}

typealias TuplecType = Tuplec<Any,Any>


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
    /*private func _requestGET(target:TranscendModel,subscriber:RACSubscriber){
        let endpoint = target._request["endpoint"] as String
        let params = target._request["params"] as [String:AnyObject]

        Alamofire.request(.GET, endpoint, parameters: params)
            .response{ (request, response, data, error) in
                NSLog("\(response)")
                
            }.responseObject{ (_, _, object:TranscendModel?, _) -> Void in
                subscriber.sendNext(object)
            }
    }*/
    
    
    //
    // Signalable
    //
    /*func Signalable(target:TranscendModel) -> RACSignal {
        // Create signal from model
        return RACSignal.createSignal{ (subscriber:RACSubscriber!) -> RACDisposable! in
            self._requestGET(target, subscriber: subscriber)
            
            return RACDisposable()
        }
    }*/
    
    
    //
    // Hydrate
    //
    func Hydrate<T: TranscendModelProtocol>(data:AnyObject!, completion: (T?,NSError?) -> Void) -> Self {
        completion(T(representation: data),nil)
        return self
    }
    
}





