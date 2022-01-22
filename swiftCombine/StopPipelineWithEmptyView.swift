//
//  StopPipelineWithEmptyView.swift
//  swiftCombine
//
//  Created by Matteo on 22/01/2022.
//

import SwiftUI
import Combine

class StopPipelineWithEmptyViewModel: ObservableObject {
    @Published var selectors = [5, 10, 20]
    @Published var selectedStop = 5
    @Published var numsToPublish: [Int] = []
    private var numbers = Range(1...50)
    
    func fetchNumbers() {
        numsToPublish = []

        _ = numbers.publisher
            .tryMap { num -> Int in
                if num == self.selectedStop {
                    throw NumStopError.stopError
                }
                return num
            }
            .catch { error in
                Empty(completeImmediately: true)
            }
            .sink { [unowned self] value in
                numsToPublish.append(value)
            }
    }
    
}

enum NumStopError: Error {
    case stopError
}



struct StopPipelineWithEmptyView: View {
    @StateObject fileprivate var vm = StopPipelineWithEmptyViewModel()
    
    var body: some View {
        VStack (alignment: .center, spacing: 20){
            Text("The Empty Publisher")
                .font(.title)
            
            Text("The pipeline will be interrupted at the position of your choice")
                .font(.title3)
            
            Picker("Stopping at", selection: $vm.selectedStop) {
                ForEach(vm.selectors, id: \.self) { value in
                    Text(String(value))
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            List {
                ForEach(vm.numsToPublish, id: \.self) { num in
                    Image(systemName: "\(num).circle.fill")
                        .font(.title)
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
            Button("Fetch") {
                vm.fetchNumbers()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.title3)
            .cornerRadius(20)
        }
    }
}

struct StopPipelineWithEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        StopPipelineWithEmptyView()
    }
}
