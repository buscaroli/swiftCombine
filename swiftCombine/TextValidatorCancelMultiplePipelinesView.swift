//
//  TextValidatorCancelMultiplePipelinesView.swift
//  swiftCombine
//
//  Created by Matteo on 19/01/2022.
//

import SwiftUI
import Combine

fileprivate class TextValidatorCancelMultiplePipelinesModelView: ObservableObject {
    @Published var name: String = ""
    
    @Published var email: String = ""
    @Published var emailValidation: String = ""
    
    @Published var password: String = ""
    @Published var passwordValidation: String = ""
    
    private var cancellables = [AnyCancellable]()
    
    init() {
        $email
            .map {value in
                self.isValidEmail(value) ? "😀" : "😖"
            }
            .sink{ [unowned self] value in
                self.emailValidation = value
            }
            .store(in: &cancellables)
        
        $password
            .map { value in
                self.isValidPassword(value) ? "😀" : "😖"
            }
            .sink { [unowned self] value in
                self.passwordValidation = value
            }
            .store(in: &cancellables)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let isValid = email.contains("@") && email.contains(".")
        return isValid
    }
    
    func isValidPassword(_ pw: String) -> Bool {
        return pw.count >= 6
    }
    
    func cancellAllValidations() {
        cancellables.removeAll()
    }
    
    
}


struct TextValidatorCancelMultiplePipelinesView: View {
    @StateObject fileprivate var vm = TextValidatorCancelMultiplePipelinesModelView()
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter your details").font(.title)
                
                TextField("Name", text: $vm.name).frame(width: 300)
                
                HStack {
                    TextField("Email", text: $vm.email).frame(width: 300)
                    Text(vm.emailValidation)
                }
                
                HStack {
                    TextField("Password", text: $vm.password).frame(width: 300)
                    Text(vm.passwordValidation)
                }
                
                Button("CANCEL ALL\nVALIDATION") {
                    vm.emailValidation = "🤐"
                    vm.passwordValidation = "🤐"
                    vm.cancellAllValidations()
                }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .font(.title3)
                    .cornerRadius(20)
            }
            .font(.title3)
            .padding()
            .textFieldStyle(.roundedBorder)
        }
    }
}

struct TextValidatorCancelMultiplePipelinesView_Previews: PreviewProvider {
    static var previews: some View {
        TextValidatorCancelMultiplePipelinesView()
    }
}
