//
//  ExpiringAsyncCache.swift
//  AsyncCache
//
//  Created by jordanebelanger on 5/30/18.
//

import Foundation

/// Wrapper arounds a generic `AsyncCache` that will automatically invalidate the
/// cache after a certain amount of time.
public final class ExpiringAsyncCache<T>: AsyncCache {
    public typealias DataType = T
    
    public let lifeTimeInS: TimeInterval
    
    private var expirationDate: Date?
    private let cache: AnyAsyncCache<DataType>
   
    /// Init by passing in a more generic cache and specifying the cache `lifetime`
    /// in seconds.
    public init<CacheType: AsyncCache>(using cache: CacheType, lifetime: TimeInterval) where CacheType.DataType == DataType {
        self.cache = AnyAsyncCache(cache)
        self.lifeTimeInS = lifetime
    }
    
    public func updateValue(with value: DataType) {
        self.cache.updateValue(with: value)
        self.expirationDate = Date().addingTimeInterval(lifeTimeInS)
    }
    
    public func value(_ completion: @escaping (Result<DataType>) -> Void) {
        if let expirationDate = self.expirationDate, expirationDate.timeIntervalSinceNow < 0 {
            self.invalidate()
        }
        
        cache.value { [weak self] (result) in
            guard let strongSelf = self else { return }
            if case .success(_) = result {
                if strongSelf.expirationDate == nil {
                    strongSelf.expirationDate = Date().addingTimeInterval(strongSelf.lifeTimeInS)
                }
            }
            
            completion(result)
        }
    }
    
    public func invalidate() {
        self.expirationDate = nil
        cache.invalidate()
    }
    
    public var isValid: Bool {
        return cache.isValid
    }
    
    public var isLoading: Bool {
        return cache.isLoading
    }
    
}
