//
//  SwiftUIView.swift
//  
//
//  Created by Rob Jonson on 09/11/2021.
//

import SwiftUI

@available(macOS 10.15.0, iOS 13.0, *)
public struct SignupEmailView: View {
    var text: SignupText
    var close:() -> Void

    public init(text: SignupText, close:@escaping () -> Void) {

        self.close = close
        self.text = text

        self.text.doReplacements()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(text.emailHeading)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            Text(text.emailBody)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)

            if let from = text.emailFrom {
                Text(from)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }

            EnterEmailView(text: text, close: close)

            CenteredIfCompact {
                Button(text.emailNoButton) {
                    self.close()
                }
                .font(.subheadline)
            }

        }
        .padding()
        .padding(.vertical)
        .background(
            LinearGradient(gradient: Gradient(colors: text.backgroundColors),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(10)
        .shadow(radius: 5)
    }

}

@available(macOS 10.15.0, iOS 13.0, *)
struct SignupEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignupEmailView(text: SignupText.newFeaturesOtherApps.from("-Rob"), close: {})
    }
}

@available(macOS 10.15.0, iOS 13.0, *)
struct EnterEmailView: View {
    var text: SignupText
    var close:() -> Void



    @State private var email: String = ""
    @State private var errorMessage: String?

    init(text: SignupText, close:@escaping () -> Void) {

        self.text = text
        self.close = close


    }

    var body: some View {
        VStackIfCompact {

            VStack(spacing: 5) {
                if #available(macOS 12.0, iOS 15.0, *) {
                    TextField("Your Email", text: $email)
                        .disableAutocorrection(true)
                        .padding(10)
                        .cornerRadius(5)
                        .border(.selection)
                        .backport.defaultFocus()
                } else {
                    TextField("Your Email", text: $email)
                        .disableAutocorrection(true)
                        .padding(10)
                        .cornerRadius(5)
                        .border(Color.gray)
                }

                Text(errorMessage ?? "")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
                    .frame(height: errorMessage == nil ? 0 : nil)
            }

            Button(text.emailYesButton) {
                submitEmail()
            }
            .backport.keyboardShortcutDefault()
        }

    }

    func submitEmail() {
        do {
            try Zaphod.shared.set(email: email)
            withAnimation {
                errorMessage = nil
            }
        } catch {
            withAnimation {
                errorMessage = "Please check that your email is correct..."
            }
            return
        }

        self.close()
    }
}
