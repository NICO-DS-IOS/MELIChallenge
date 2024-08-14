//
//  Dynamic.swift
//  MVVMExample
//
//  Created by Dino Bartosak on 25/09/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    
    var forceCurrentThread = false
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    func executeMain() {
        if Thread.isMainThread || forceCurrentThread {
            listener?(value)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    print("Error self not present in Dynamic execute")
                    return
                }
                strongSelf.listener?(strongSelf.value)
            }
        }
    }
    
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func setValueAtMain(value:T) {
        if Thread.isMainThread || forceCurrentThread {
            self.value = value
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.listener?(value)
            }
        }
    }
}
