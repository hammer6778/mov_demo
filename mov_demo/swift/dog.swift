//
//  dog.swift
//  mov_demo
//
//  Created by Mountain on 07/04/2024.
//

import Foundation

@objcMembers class dog:NSObject{
    @objc (name)
    var age = 12
    
    func add(){
        print("新加的东西")
    }
    
    func run(){
        print("奔跑吧")
    }
}
