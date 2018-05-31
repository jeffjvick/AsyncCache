//
//  AnyAsyncCache.swift
//  AsyncCache
//
//  Created by jordanebelanger on 5/30/18.
//

import Foundation

public struct AnyAsyncCache<T>: AsyncCache {
    public typealias DataType = T
    
    private let _isValid: () -> Bool
    private let _isLoading: () -> Bool
    private let _updateValue: (DataType) -> Void
    private let _value: ( @escaping (Result<DataType>) -> Void) -> Void
    private let _invalidate: () -> Void
    
    public init<CacheType: AsyncCache>(_ cache: CacheType) where CacheType.DataType == DataType {
        self._isValid = {cache.isValid}
        self._isLoading = {cache.isLoading}
        self._updateValue = cache.updateValue
        self._value = cache.value
        self._invalidate = cache.invalidate
    }
    
    public var isValid: Bool {
        return _isValid()
    }
    public var isLoading: Bool {
        return _isLoading()
    }
    public func updateValue(with value: DataType) {
        _updateValue(value)
    }
    public func value(_ completion: @escaping (Result<DataType>) -> Void) {
        _value(completion)
    }
    public func invalidate() {
        _invalidate()
    }
    
}
