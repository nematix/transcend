//
//  TrancendModel.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/15/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation


@objc public protocol TranscendModelProtocol {
    //var _request:[String:Any] {get}
    
    init(response: NSHTTPURLResponse?, representation: AnyObject)
}


class TranscendModel: NSObject, TranscendModelProtocol {
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