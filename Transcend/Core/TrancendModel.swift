//
//  TrancendModel.swift
//  Spectrum
//
//  Created by Azri Jamil on 11/15/14.
//  Copyright (c) 2014 Nematix System. All rights reserved.
//

import Foundation


@objc public protocol TranscendModelProtocol {
    //init(response: NSHTTPURLResponse?, representation: AnyObject)
    init(representation: AnyObject)
}



class TranscendModel: NSObject, TranscendModelProtocol {
    private var _knowledges: [TuplecType:Any] = [:]
    
    //var Knowledges: [TuplecType:Any] { get{ return _knowledges } }
    //var _request:[String:Any] = [:]
    
    
    required init(representation: AnyObject) {
        super.init()
        
        let className: AnyObject.Type = representation.dynamicType
        
        _knowledges["Static" ! className] = representation
        Imitate(self)
    }
    
    
    // Imitate
    // Using knowledge to produce another knowledge by educing existing knowledge
    func Imitate<T>(object:T) -> TranscendModel{
        // Get object reflection
        let reflection = reflect(object)
        
        // Get concrete class
        let classConcrete: TranscendModel = object as TranscendModel
        
        // Get static knowledges
        let source = _knowledges[ "Static" ! classConcrete.self ] as TranscendModel
        
        // Iterate all property
        for index in 0 ..< reflection.count {
            let (key,propertyObject) = reflection[index]
            
            // Imitate acceptable knowledge into learner
            if let propertyValue = source.valueForKeyPath(key) as? String {
                classConcrete.setValue(propertyValue, forKey: key)
            }
        }
        
        // Return learner
        return classConcrete
    }
    
    
    // Imitate
    // Using knowledge to produce another knowledge by educing existing knowledge
    /*func Imitate<T,U>(source:T,object:U) -> U{
    
    switch object.dynamicType {
    // TranscendModel learner
    case let TranscendModel :
    let sourceKnowledge = source as TranscendType
    let transcendObject = object as TranscendType
    
    // Get object reflection
    let reflection = reflect(transcendObject)
    
    // Iterate all property
    for index in 0 ..< reflection.count {
    let (key,propertyObject) = reflection[index]
    
    // Imitate acceptable knowledge into learner
    if let propertyValue = sourceKnowledge.Knowledges.valueForKeyPath(key) as? String {
    transcendObject.setValue(propertyValue, forKey: key)
    }
    }
    
    // Return learner
    return transcendObject as U
    }
    }*/
    
}