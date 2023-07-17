//
//  CareerViewModel.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import Foundation

class CareerViewModel : ObservableObject{
    @Published var careerResponse: CareerRespose?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    let apiService = APIService()
    
    @MainActor
    func getAllCareer() async{
        isLoading.toggle()
        defer{
            isLoading.toggle()
        }
        do{
            careerResponse = try await apiService.getJSON(endPoint: "/api/career/get")
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
        
    }
}
