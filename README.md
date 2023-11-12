# SourceCenter
用 Swift 简单实现一个广播中心，代码不到50行.

# 核心代码
```
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
```

# 用法
```
class AuthManager: BaseManager {
    static let shared = AuthManager()
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            /// 发送事件
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
        /// 监听事件
        AddListener(AuthListener.self, self)
    }
}

extension UseCase: AuthListener {
    func onLoggedInSuccess(_ data: Any) {
        
    }
}
```
