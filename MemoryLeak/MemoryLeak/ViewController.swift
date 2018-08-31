//
//  ViewController.swift
//  MemoryLeak
//
//  Created by Frank on 2018/8/30.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var delegate: SendDataDelegate?
    
    @IBAction func nilAction(_ sender: UIButton) {
        
       var vc2: VC2? = VC2()
        vc2 = nil
    
    }
    
    @IBAction func closuurNilAction(_ sender: UIButton) {
        
//        var closureVc3: closureDemo = closureDemo()
        
        //closureVc3 = nil
        
        var bobClass: closureDemo? = closureDemo()
        bobClass?.bobClosure?() //執行它裡面的 closure 這樣他才會跑 init 下面只是把 ｃｌｏｓｕｒｅ 存到 property 可是還沒執行 要靠這一行才能執行
        //bobClosure + () 有括號才是執行裡面的 func
        
        // bobClass?.bobClosure 打這樣的話只是去 點他 可是沒做事情
        
        //啟用下面這行就會把它 nil 有沒有 deinit 要看 closure 裡面有沒有用到他的 class
        
        bobClass = nil
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// delegate demo1
class VC1: SendDataDelegate {
    // 有 weak 會跑 deinit VC2 生成 VC2 deinit
    //weak var delegate: SendDataDelegate?
    
    // 沒 weak 只會跑 VC2 生成
    var delegate: SendDataDelegate?
    
    
    //lazy var
//    var sendingVC: ViewController = {
//        let vc = ViewController()
//        //vc.delegate = self // self refers to ReceivingVC object
//        return vc
//    }()
    
//    var vc2 = VC2()
//    init() {
//        print("VC1生成")
//    }
//
//    deinit {
//        print("VC1 deinit")
//    }
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

//    var name: String
//    var number: Int
//
//    var closureProperty = {
//
//    }
//
//    init(name: String, number: Int) {
//        self.name = name
//        self.number = number
//        print("我的名字是\(name)生日\(number)")
//    }
//
//    deinit {
//        print("closureDemo 跑 deinit ")
//    }
}

// Test
class People {
    let name: String
    var macbook: Macbook?
    
    init(name: String, macbook: Macbook?) {
        self.name = name
        self.macbook = macbook
    }
    
    deinit {
        print("\(name) is being deinitialized.")
    }
}

class Macbook {
    let name: String
    var owner: People?
    
    init(name: String, owner: People?) {
        self.name = name
        self.owner = owner
    }
    
    deinit {
        print("Macbook named \(name) is being deinitialized.")
    }
}

func peopleTest() {
    var gavin: People? = People(name: "Gavin", macbook: nil)
    var computer: Macbook? = Macbook(name: "Matilda", owner: nil)
    
    gavin?.macbook = computer
    computer?.owner = gavin

    
    gavin = nil
    
    // print "Gavin is being deinitialized."
    computer = nil
    
    // print "Macbook named Matilda is being deinitialized."
    //https://ithelp.ithome.com.tw/articles/10196788
    
}


