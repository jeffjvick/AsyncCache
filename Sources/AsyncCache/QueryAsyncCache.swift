//
//  QueryAsyncCache.swift
//  AsyncCache
//
//  Created by jordanebelanger on 5/30/18.
//

import Foundation

/// Generic AsyncCache instance, use to cache any asynchronous query you have that
/// can be described by a closure.
public final class QueryAsyncCache<T>: AsyncCache {
    public typealias DataType = T
    
    public typealias QueryFunction = (@escaping (Result<DataType>) -> Void) -> Void
    
    private var _value: DataType?
    
    public private(set) var isValid: Bool
    
    public var isLoading: Bool {
        return token != nil
    }
    
    // Empty class used as a "dumb" reference to track mid request cancellations
    // of a query from a manual update of the cache.
    private final class CancellationToken {}
    private var token: CancellationToken?
    
    private var subscriptions: [(Result<DataType>) -> Void] = []
    private let queryFunction: QueryFunction
    
    public init(value: DataType? = nil, queryFunction: @escaping QueryFunction) {
        self._value = value
        self.isValid = value != nil
        self.queryFunction = queryFunction
    }
    
    public func updateValue(with value: DataType) {
        self._value = value
        self.isValid = true
        self.token = nil
        self.flushSubscription(with: .success(value))
    }
    
    public func value(_ completion: @escaping (Result<DataType>) -> Void) {
        self.subscriptions.append(completion)
        if let value = self._value, isValid {
            flushSubscription(with: .success(value))
            return
        }
        
        if token == nil {
            let token = CancellationToken()
            self.token = token
            
            queryFunction { [weak token, weak self] result in
                guard let strongSelf = self, token != nil else { return }
                
                switch result {
                case .success(let value):
                    strongSelf._value = value
                    strongSelf.isValid = true
                default:
                    break
                }
                
                strongSelf.token = nil
                strongSelf.flushSubscription(with: result)
            }
        }
    }
    
    public func invalidate() {
        self.isValid = false
    }
    
    private func flushSubscription(with result: Result<DataType>) {
        let subs = self.subscriptions
        self.subscriptions.removeAll()
        for sub in subs {
            sub(result)
        }
    }
    
}
