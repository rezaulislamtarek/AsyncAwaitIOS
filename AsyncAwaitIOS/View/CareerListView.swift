//
//  ContentView.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import SwiftUI

struct CareerListView: View {
    @StateObject var vm = CareerViewModel()
    @State private var showAddCarear: Bool = false
    
    var body: some View {
        NavigationView {
        
            ScrollView(showsIndicators: false){
                
                VStack {
                    LazyVStack(){
                        ForEach(vm.careerResponse?.data ?? []){ item in
                            VStack(alignment: .leading){
                                HStack {
                                    UrlImageView(urlString: "https://digicomapi.diatomicsoft.com"+item.logo)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                    Text(item.name.uppercased())
                                        .bold()
                                }
                                Text(item.logo).font(.system(size: 14))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .background(Color(hex: 0xF8FFF7))
                            .cornerRadius(10)
                        }
                        .shadow(radius: 0.5)
                        .padding(.top, 5)
                        
                    }
                    .padding()
                .cornerRadius(10)
                }
                
                NavigationLink("", destination: AddCareerView(), isActive: $showAddCarear )
            }
            .navigationTitle(vm.careerResponse?.message ?? "")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                           showAddCarear = true
                    } label:{
                        Text("Add")
                    }
                }
            }
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .task {
                await vm.getAllCareer()
        }
        }
        
        
    }
}

struct CareerList_Previews: PreviewProvider {
    static var previews: some View {
        CareerListView()
    }
}
