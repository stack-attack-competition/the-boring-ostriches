//
//  Toast.swift
//  the-boring-ostriches-client
//
//  Created by Robert Boros on 2020. 02. 22..
//  Copyright © 2020. Robert Boros. All rights reserved.
//

import Foundation
import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .center) {
                
                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)
                
                VStack {
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 10)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .transition(.slide)
                    .opacity(self.isShowing ? 1 : 0)
                
            }.onTapGesture {
                self.isShowing = false
            }
            
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}
