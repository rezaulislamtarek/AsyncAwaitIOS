//
//  AddCareerView.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import SwiftUI

struct AddCareerView: View {
    @State var title: String = ""
    @State var url:String = ""
    var body: some View {
        VStack{
            Image(systemName: "photo")
                .foregroundColor(.brown)
                .font(.system(size: 100))
            Text("Tap to pick a image")
            
            TextField("Enter Title", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("Enter url", text: $url)
                .textFieldStyle(.roundedBorder)
            
            Button{
                
            }label: {
                Text("Upload Data")
            }
                
            
        }.padding()
    }
}

struct AddCareerView_Previews: PreviewProvider {
    static var previews: some View {
        AddCareerView()
    }
}
