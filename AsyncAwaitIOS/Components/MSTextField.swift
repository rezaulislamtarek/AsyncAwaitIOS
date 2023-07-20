//
//  MSTextField.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 20/7/23.
//


import SwiftUI

@available(iOS 15.0, *)
public struct MSTextField: View {
    @Binding public var text:String
    public var placeHolder : String
    var color : Color
    var cornerRadious : Float
    @State public var isTapped = false
    
    public init(text: Binding<String>, placeHolder: String, isTapped: Bool = false, color: Color, cornerRadious : Float) {
        self._text = text
        self.placeHolder = placeHolder
        self.isTapped = isTapped
        self.color = color
        self.cornerRadious = cornerRadious
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Text(placeHolder)
            
            TextField("", text: $text){ status in
                withAnimation(.easeIn){
                    isTapped = true
                }
            } onCommit: {
                if text == "" { withAnimation(.easeOut){
                    isTapped = false
                }
                }
            }
            
            
            
        }
        // For ZStack
        .animation(.easeOut)
        .padding(.horizontal)
        .padding(.vertical,10)
        .background(
            RoundedRectangle(cornerRadius: CGFloat(cornerRadious))
                .stroke(isTapped ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}
    
    @available(iOS 15.0.0, *)
    struct MSTextField_Previews: PreviewProvider {
        
        static var previews: some View {
            MSTextField(text: .constant(""), placeHolder: "Enter text", color: Color.gray, cornerRadious: 16.0)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }

