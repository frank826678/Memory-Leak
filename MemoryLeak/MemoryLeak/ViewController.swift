//
//  ViewController.swift
//  MemoryLeak
//
//  Created by Frank on 2018/8/30.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func nilAction(_ sender: UIButton) {
        
       var vc1: VC1? = VC1()
        vc1 = nil
    
    }
    
    var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class VC1: SendDataDelegate {
    
    //lazy var
//    var sendingVC: ViewController = {
//        let vc = ViewController()
//        //vc.delegate = self // self refers to ReceivingVC object
//        return vc
//    }()
    
    var vc2 = VC2()
    init() {
        print("VC1生成")
    }
    
    deinit {
        print("VC1 deinit")
    }
}

class VC2: SendDataDelegate {
    
    var vc1 = VC1()
    weak var delegate: SendDataDelegate?
    
    init() {
        print("VC2 生成")
    }
    
    deinit {
        print("VC2 deinit")
    }
}


protocol SendDataDelegate: class {}


