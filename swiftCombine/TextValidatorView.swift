//
//  TextValidatorView.swift
//  swiftCombine
//
//  Created by Matteo on 19/01/2022.
//

import SwiftUI

fileprivate class TextValidatorViewModel: ObservableObject {
    @Published var userText: String = ""
    @Published var validation: String = ""
    
    init() {
        $userText
            .map { $0.count >= 3 ? "😃" : "😖"}
            .assign(to: &$validation)
    }
}

struct TextValidatorView: View {
    @StateObject private var vm = TextValidatorViewModel()
    
    
    var body: some View {
        VStack(spacing: 20){
            Text("Text Validator")
                .font(.title)
            Text("Enter something in the TextField that is longer than three chars")
                .font(.title3)
            HStack {
                TextField("Enter text here...", text: $vm.userText)
                    .textFieldStyle(.roundedBorder)
                Text(vm.validation)
            }
            .padding(.horizontal)
        }
    }
}

struct TextValidatorView_Previews: PreviewProvider {
    static var previews: some View {
        TextValidatorView()
    }
}
