//
//  TextValidatorWithSink.swift
//  swiftCombine
//
//  Created by Matteo on 19/01/2022.
//

import SwiftUI
import Combine

fileprivate class TextValidatorWithSinkViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var validation: String = ""
    var cancellable: AnyCancellable?
    
    // We can use [unowned self] instead of [weak self] as .sink is referencing something within the same class.
    // This means that when the ViewModel class (TextValidatorWithSinkViewModel) is de-initialized, the pipeline (cancellable) will also de-initialized destroying the subscriber.
    // This means the .sink's closure will no longer run.
    // HOWEVER, if .sink was referencing something outside of the class (outside TextValidatorWithSinkViewModel) you couldn't garantee that the outside reference would de-initialize first and there is a risk the app would crash.
    // In this case use [weak self] !!
    // Pag 77 CombineMastery Book
    init() {
        cancellable = $password
            .map { $0.count >= 6 ? "🥳" : "😭"}
            .sink {[unowned self] value in
                self.validation = value
            }
    }
}


struct TextValidatorWithSink: View {
    @StateObject private var vm = TextValidatorWithSinkViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            Text("Text Validator")
                .font(.title)
            
            Text("Enter something in the TextField that is longer than three chars")
                .font(.title3)
            
            Group {
                TextField("Name", text: $vm.name)
                
                HStack {
                    TextField("Password (min 6 chars)", text: $vm.password)
                    Text(vm.validation)
                }
                
                Button("DO NOT VALIDATE") {
                    vm.validation = "🤐"
                    vm.cancellable?.cancel()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.title3)
                .cornerRadius(20)
            }
            .font(.title3)
            
            
            
        }
        .padding(.horizontal)
        .textFieldStyle(.roundedBorder)
    }
}

struct TextValidatorWithSink_Previews: PreviewProvider {
    static var previews: some View {
        TextValidatorWithSink()
    }
}
