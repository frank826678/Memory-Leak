# Memory Leak
-----

# 1.closure

-----

當 class 裡面的 closure 指向 class 本身的 property 會產生 retain cycle 只要這時候用了 `bobClass = nil` 切斷外部的連結時，就會產生 memory leak，範例如下。

```
@IBAction func closuurNilAction(_ sender: UIButton) {
       
        
        var bobClass: closureDemo? = closureDemo()
        bobClass?.bobClosure?() //執行它裡面的 closure 這樣他才會跑 init 下面只是把 ｃｌｏｓｕｒｅ 存到 property 可是還沒執行 要靠這一行才能執行
        //bobClosure + () 有括號才是執行裡面的 func
        
        // bobClass?.bobClosure 打這樣的話只是去 點他 可是沒做事情
        
        //啟用下面這行就會把它 nil 有沒有 deinit 要看 closure 裡面有沒有用到他的 class
        
        bobClass = nil
        
    }
    
```    

```
class closureDemo {
    
    // lazy
    var bobClosure: (() -> ())?
    var name =  "frank"
    init() {
        
        //用下面這行就會跑 deinit
        //self.bobClosure = { print("Bob the Developer") }
        print("closure 生成33")
        
        //用下面這行會 memory leak
        self.bobClosure = { print("\(self.name) the Developer") }
    }
    
    //print(self.bobClosure)
    //用下面時不會跑 deinit 會有 retain cycle
//    init() {
//        self.bobClosure = { print("\(self.name) the Developer") }
//    }
    
    deinit {
        print(" closure 跑了 deinit I’m gone... ☠️")
    }

}

```

-----

# 2.delegate

生成順序如下

1. 按下 `nilAction` Button 時，生成 VC2 ( VC2 ARC +1 )
2. 接著從 VC2 生成 VC1 ( VC1 ARC +1 )
3. ` vc1.delegate = self ` 透過 delegate 找到 VC2 ( VC2 ARC +1 )

4. 若是沒有使用 `weak` 這時候把 `VC2 = nil` (VC2 ARC 從 2 變 1) 
5. 則會產生 Memory Leak (VC1 VC2 ARC各一 產生 retain cycle )

範例如下：


-----

`var delegate: SendDataDelegate?`

```
    @IBAction func nilAction(_ sender: UIButton) {
        
       var vc2: VC2? = VC2()
        vc2 = nil
    
    }


```

```

// delegate demo1

class VC1: SendDataDelegate {
    // 有 weak 會跑 deinit VC2 生成 VC2 deinit
    //weak var delegate: SendDataDelegate?
    
    // 沒 weak 只會跑 VC2 生成
    var delegate: SendDataDelegate?
    
    
   }

class VC2: SendDataDelegate {
    
    //lazy
    lazy var vc1 = VC1()
    
    //weak 無用
    weak var delegate: SendDataDelegate?
    
    init() {
        print("VC2 生成")
        vc1.delegate = self
    }
    
    deinit {
        print("VC2 deinit")
    }
}


protocol SendDataDelegate: class {}

// delegate End


```

-----

