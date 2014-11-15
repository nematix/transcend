//
//  Request.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/15/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation
import Alamofire


extension Alamofire.Request {
    
    public func responseObject<T: TranscendModelProtocol>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
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