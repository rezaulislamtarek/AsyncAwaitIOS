//
//  CareerViewModel.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import Foundation
import UIKit

class CareerViewModel : ObservableObject{
    @Published var careerResponse: CareerRespose?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @Published var careerRew : CareerReq = CareerReq(name: "", url: "")
    @Published var image : UIImage = UIImage(named: "add_img")!
    
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
    
    @MainActor
    func addCareer() async{
        do {
             try await apiService.uploadMultipartFormData(object: careerRew, image: image , keyForImage: "photo")
            // Upload successful, handle the response
        }   catch let error as APIError {
            print("API Error: \(error.localizedDescription)")
            // Handle the specific API error case
        } catch {
            print("Unknown Error: \(error.localizedDescription)")
            // Handle other types of errors
        }
    }
}
