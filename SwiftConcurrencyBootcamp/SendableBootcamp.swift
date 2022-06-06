//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 06/06/22.
//
//sendable: only for value types (like structs)
//mark class as final class if you want to use sendable
//The Sendable protocol indicates that value of the given type can be safely used in concurrent code.
import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
    
}

struct MyUserInfo: Sendable {
    let name: String
}

//@unchecked -> compiler doesnot checking if it is sendable
final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    //we make it thread safe manually
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassUserInfo(name: "Info")
        
        await manager.updateDatabase(userInfo: info)
    }
    
}

struct SendableBootcamp: View {
    @StateObject private var viewModel = SendableBootcampViewModel()
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
