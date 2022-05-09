//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by RUMEN GUIN on 09/05/22.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    
    func fetchImage() async {
        do {
            try? await Task.sleep(nanoseconds: 5_000_000_000) //so that we can cancel task and play
            guard let url = URL(string: "https://picsum.photos/1000") else {return}
            let (data, _) = try await URLSession.shared.data(from: url,delegate: nil)
            await MainActor.run(body: { //put in main thread
                self.image = UIImage(data: data)
                print("Image returned successfully")
            })
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else {return}
            let (data, _) = try await URLSession.shared.data(from: url,delegate: nil)
            await MainActor.run(body: { //put in main thread
                self.image2 = UIImage(data: data)
                print("Image returned successfully")
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click Me ⚽️") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    //@State private var fetchImageTask: Task<(), Never>? = nil
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        //Adds an asynchronous task to perform when this view appears.
        // SwiftUI automatically cancels the task if the view disappears before the action completes.
        .task {
            await viewModel.fetchImage()
        }
        /*
        .onDisappear {
            fetchImageTask?.cancel()
        }
        .onAppear {
            //both at same time as .onAppear is sync code
            fetchImageTask = Task {
                //print(Thread.current)  //main thread
                //print(Task.currentPriority) //rawValue: 25
                await viewModel.fetchImage()
            }
            /*
//            Task {
//                print(Thread.current) //main Thread
//                print(Task.currentPriority) //rawValue: 25
//                await viewModel.fetchImage2()
//            }
            
            //all in main thread
//            Task(priority: .userInitiated) {
//                //try? await Task.sleep(nanoseconds:2000000000) //output at last
//                await Task.yield() //Suspends the current task and allows other tasks to execute
//                print("UserInitiated: \(Thread.current) : \(Task.currentPriority)") //25
//            }
//            Task(priority: .high) {
//                print("High: \(Thread.current) : \(Task.currentPriority)") //25
//            }
//            Task(priority: .medium) {
//                print("Medium: \(Thread.current) : \(Task.currentPriority)") //21
//            }
//            Task(priority: .low) {
//                print("Low: \(Thread.current) : \(Task.currentPriority)") //17
//            }
//            Task(priority: .utility) {
//                print("Utility: \(Thread.current) : \(Task.currentPriority)") //17
//            }
//            Task(priority: .background) {
//                print("Background: \(Thread.current) : \(Task.currentPriority)") //9
//            }
            
            //child task will inherit data from parent task
//            Task(priority: .userInitiated) {
//                print("User Initiated: \(Thread.current) : \(Task.currentPriority)") //25
//
//                Task {
//                    print("User Initiated2: \(Thread.current) : \(Task.currentPriority)") //25
//                }
//
//                //DONT USE DETACHED TASK
//                Task.detached { //detached from the parent task
//                    print("User Initiated(detached): \(Thread.current) : \(Task.currentPriority)") //21
//                }
//            }
            */
           
            
        }
         */
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
