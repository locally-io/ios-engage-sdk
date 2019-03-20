//
//  ConsoleDelegate.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 26/02/19.
//  Copyright © 2019 Locally. All rights reserved.
//

import Foundation

public protocol ConsoleDelegate: class {
    func showMessage(content: ConsoleContent)
}

public class ConsolePresenter {
    
    weak var delegate: ConsoleDelegate?
    
    static let shared = ConsolePresenter()
    
    private init() { }
    
    func sendMessage(content: ConsoleContent) {
        
        guard let delegate = self.delegate else { return }
        delegate.showMessage(content: content)
    }
}
