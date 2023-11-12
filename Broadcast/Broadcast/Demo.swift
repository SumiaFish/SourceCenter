//
//  Demo.swift
//  Broadcast
//
//  Created by 黄凯文 on 2023/11/12.
//

import Foundation

class BaseManager: NSObject {
 
}

class AuthManager: BaseManager {
    static let shared = AuthManager()
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotifyListener(AuthListener.self) {
                $0.onLoggedInSuccess(1)
            }
        }
    }
}

protocol AuthListener: Listener {}

extension AuthListener {
    func onLoggedInSuccess(_ data: Any) {}
}

class UseCase: NSObject {
    override init() {
        super.init()
        AddListener(AuthListener.self, self)
    }
}

extension UseCase: AuthListener {
    func onLoggedInSuccess(_ data: Any) {
        
    }
}

