//
//  SourceCenter.swift
//  Broadcast
//
//  Created by 黄凯文 on 2023/11/12.
//

import Foundation

func AddListener<T>(_ t: T.Type, _ listener: Listener) {
    SourceCenter.addListener(t, listener)
}

func RemoveListener<T>(_ t: T.Type, _ listener: Listener) {
    SourceCenter.removeListener(t, listener)
}

func NotifyListener<T>(_ t: T.Type, emiter: (T) -> Void) {
    SourceCenter.notifyListener(t, emiter: emiter)
}

class SourceCenter {
    static private(set) var data: [String: [ListenerItem]] = [:]
    
    static func addListener<T>(_ t: T.Type, _ listener: Listener) {
        var list = data["\(t)"] ?? []
        if (list.contains(where: { $0.listener != nil && $0.listener! == listener })) {
            return
        }
        list.append(.init(listener))
        data["\(t)"] = list
    }
    
    static func removeListener<T>(_ t: T.Type, _ listener: Listener) {
        data["\(t)"]?.removeAll(where: { $0.listener != nil && $0.listener! == listener })
    }
    
    static func notifyListener<T>(_ t: T.Type, emiter: (T) -> Void) {
        data["\(t)"]?.forEach { item in
           if let listener = item.listener as? T {
               emiter(listener)
           }
       }
   }
}

class ListenerItem {
    private(set) weak var listener: Listener?
    
    init(_ listener: Listener? = nil) {
        self.listener = listener
    }
}
