//
//  AddCareerView.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import SwiftUI


struct AddCareerView: View {
    @StateObject var vm = CareerViewModel()
    @State private var isShowingPhotoPicker: Bool = false
   
    @State private var showingPicker = false
    var body: some View {
        VStack{
            Image(uiImage: vm.image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(50)
                .padding()
                .onTapGesture {
                    isShowingPhotoPicker = true
                }
            
            TextField("Enter title", text: $vm.careerRew.name)
                .textFieldStyle(.roundedBorder)
                 
            TextField("Enter url", text: $vm.careerRew.url)
                .textFieldStyle(.roundedBorder)
            
            Button{
                print("tap on submit")
                Task{
                    await vm.addCareer()
                }
            }label: {
                Text("Upload Data")
            }
            
        }
        .navigationTitle("Add Career")
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPicker(avatarImage: $vm.image)
        })
        .padding()
        .padding()
    }
}

struct AddCareerView_Previews: PreviewProvider {
    static var previews: some View {
        AddCareerView()
    }
}
