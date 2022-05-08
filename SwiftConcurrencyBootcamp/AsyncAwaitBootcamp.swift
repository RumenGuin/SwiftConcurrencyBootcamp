//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 08/05/22.
//
//when using async await we dont use dispatchqueue
import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1: \(Thread.current)") //main thread
        }
    }
    
    func addTitle2() {
        
        //background thread
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "title2: \(Thread.current)"
            
            DispatchQueue.main.async {
                self.dataArray.append(title) //background thread
                
                let t3 = "Title3 : \(Thread.current)" //main thread
                self.dataArray.append(t3)
            }
        }
    }
    
    func addAuthor1() async{
        let author1 = "Author1: \(Thread.current)" //main thread
        self.dataArray.append(author1)
        
        //try? await doSomething() //always on main thread
        
        //delay task by putting task to sleep (went to bg thread)
        try? await Task.sleep(nanoseconds: 2_000_000_000) //sleep for 2 sec
        
        let author2 = "Author2: \(Thread.current)" //background thread
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let a3 = "Author3: \(Thread.current)" // back in main thread
            self.dataArray.append(a3)
        })
        
        await doSomething()
    }
    
    func doSomething() async {
        try? await Task.sleep(nanoseconds: 2000_000_000)
        
        let something1 = "Somthing 1: \(Thread.current)" //background thread
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let s3 = "s3: \(Thread.current)" // back in main thread
            self.dataArray.append(s3)
        })
    }
    
}

struct AsyncAwaitBootcamp: View {
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    var body: some View {
        List{
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            
            Task {
                await viewModel.addAuthor1()
                
                let finalText = "Final Text: \(Thread.current)" //main thread
                viewModel.dataArray.append(finalText)
            }
            
            //viewModel.addTitle1()
            //viewModel.addTitle2()
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
