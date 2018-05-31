//
//  AsyncCache.swift
//  AsyncCache
//
//  Created by jordanebelanger on 5/30/18.
//

import Foundation

public protocol AsyncCache {
    associatedtype DataType
    
    var isValid: Bool { get }
    var isLoading: Bool { get }
    
    func updateValue(with value: DataType)
    func value(_ completion: @escaping (Result<DataType>) -> Void)
    func invalidate()
}
