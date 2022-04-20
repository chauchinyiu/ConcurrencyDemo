//
//  ContentView.swift
//  ConcurrencyDemo
//
//  Created by Chinyiu Chau on 20.04.22.
//

import SwiftUI
import Foundation
 
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
        }.onAppear{
            //TODO: please choose your test case
            // testAsyncInParallel()
            // testAsyncAwait()
             testActor()
        }
    }
    
    
    func testAsyncAwait()  {
        Task {
            let result = try await multiply(2,3)
            let result2 = try await multiply(4, result)
            let finalresult = try await multiply(result2, 5)
            print(finalresult)
        }
    }
    
    func testAsyncInParallel() {
        Task {
            async let result1 = multiply(2,3,10)
            async let result2 = multiply(6,7,5)
            async let result3 = multiply(4,5,1)
            let response = try await [result1, result2, result3]
            print(response)
        }
    }
 
    func testActor() {
        let counter = Counter()

        Task.detached {
            for _ in 1...1000 {
                print("In Task A: \( await counter.increment())")
            }
          
        }
        Task.detached {
            for _ in 1...1000 {
                print("In Task B: \( await counter.increment())")
            }
        }

         
        sleep(10)
        Task.detached {
            print("total: \(await counter.value)")
        }

    }
    
    func multiply(_ input_a: Int, _ input_b: Int, _ delayInSec: Double = 2) async throws -> Int{
        try await Task.sleep(nanoseconds: UInt64(delayInSec * Double(NSEC_PER_SEC)))  //some async delay
        let result = input_a * input_b
        print(result)
        return result
    }
    
}

actor Counter {
  var value = 0
  func increment() -> Int {
    value = value + 1
    return value
  }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
