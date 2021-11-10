//
//  SwiftUIView.swift
//  
//
//  Created by Rob Jonson on 09/11/2021.
//

import SwiftUI

@available(macOS 10.15.0,iOS 13.0, *)
public struct SignupNotificationView: View {
    var text:SignupText
    var close:()->Void
    
    public init(text:SignupText,close:@escaping ()->Void){

        self.close = close
        self.text = text
        
        self.text.doReplacements()
    }

    public var body: some View {
        VStack(spacing:20) {
            Text("Wanna Notification??")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(text.emailBody)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth:.infinity)
                .multilineTextAlignment(.leading)
            
            if let from = text.from {
                Text(from)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }

            Button(text.emailNoButton) {
                self.close()
            }
        }
        .padding()
        .padding(.vertical)
        .background(Color.backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

@available(macOS 10.15.0,iOS 13.0, *)
struct SignupNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        SignupNotificationView(text:SignupText.newFeaturesOtherApps.from("-Rob"), close:{})
    }
}
