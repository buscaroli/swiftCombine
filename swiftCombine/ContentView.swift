//
//  ContentView.swift
//  swiftCombine
//
//  Created by Matteo on 19/01/2022.
//

import SwiftUI



struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            List{
                NavigationLink("Text Validator with .assign()", destination: TextValidatorView())
                NavigationLink("Text Validator with .sink()", destination: TextValidatorWithSink())
                NavigationLink("Text Validator that cancels multiple pipelines", destination: TextValidatorCancelMultiplePipelinesView())

                    
            }
            .listStyle(.plain)
            .navigationTitle("Combine examples.")
            .padding(.top, 40)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
