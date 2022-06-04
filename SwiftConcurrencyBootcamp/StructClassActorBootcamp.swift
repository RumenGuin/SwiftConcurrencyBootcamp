//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 28/05/22.
//

/*
 
 VALUE TYPES:
 - Struct, Enum, String, Int etc.
 - Stored in the stack
 - Faster
 - Thread Safe!
 - When you assign or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Functions, Actor
 - Stored in the heap
 - Slower, but synchronized
 - NOT Thread safe!
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 -------------------------------------------------------------------------------------------------------------------------
 
 STACK:
 - Stored Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each thread has it's own stack!
 
 HEAP:
 - Stores Reference types
 - Shared across threads
 
 -------------------------------------------------------------------------------------------------------------------------
 
 STRUCT:
 - Based on VALUES
 - can be mutated
 - Stored in the Stack
 
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Cannot be mutated
 - Stored in the Heap
 - Inherit from other classes
 
 ACTOR:
 - Same as Class, but thread safe
 
 
 -------------------------------------
 
 Structs: Data Models, Views
 Classes: ViewModels
 Actor: Shared 'Manager' and 'Data Store'
 
 
 */

import SwiftUI

class StructClassActorBootcampViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("Viewmodel Init")
    }
    
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear{
                runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    @State private var isActive: Bool = false
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}


struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp(isActive: true)
    }
}

struct MyStruct {
    //structs have default initializers
    var title: String
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started")
        structTest1()
        lineDivider()
        classTest1()
        lineDivider()
        actorTest1()
//        structTest2()
//        lineDivider()
//        classTest2()
    }
    
    private func lineDivider() {
        print("""

        - - - - - - - - - - - - - - - - - - - - - - - - - - -

        """)
    }
    
    private func structTest1() {
        print("Struct Test 1")
        let objectA = MyStruct(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the VALUES of objectA to objectB")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title"
        print("ObjectB title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        print("Class test 1")
        let objectA = MyClass(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title"
        print("ObjectB and ObjectA title changed")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("Actor test 1")
            let objectA = MyActor(title: "Starting Title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB")
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second Title")
            print("ObjectB and ObjectA title changed")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
    
}

// Immutable struct -> means data inside will not change
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
    
}

struct MutatingStruct {
    private(set) var title: String //set it here but get it anywhere from code
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}


extension StructClassActorBootcamp {
    private func structTest2() {
        print("Struct Test 2")
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
        
    }
    
    
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title //self.property = parameter
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title //self.property = parameter
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}



extension StructClassActorBootcamp {
    private func classTest2() {
        print("Class Test 2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2: ", class2.title)
    }
}
