//
//  NameEntryView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/02/29.
//

import SwiftUI

struct NameEntryView: View {
    let explanationText = ExplanationText()
    @Binding var name: String
    @Binding var registrationState: RegistrationState
    @State var isNameValid: Bool = false
    let minNameCount: Int = 10
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Text(explanationText.nameEntryReason)
                        .font(.title3)
                        .padding()
                    
                    TextField("ニックネームを入力", text: $name)
                        .padding()
                        .font(.title)
                        .padding(.horizontal, 40)
                        .onChange(of: name) {
                            if name.count <= minNameCount {
                                isNameValid = true
                            } else {
                                isNameValid = false
                            }
                        }
                    
                    if isNameValid {
                        Text(explanationText.nameEntryError)
                            .foregroundStyle(Color.red)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    
                    Spacer()
                }
                .navigationTitle("ニックネーム")
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    registrationState = .name
                }, label: {
                    Text("次へ")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(isNameValid ? Color.pink.opacity(0.8) : Color(UIColor.lightGray))
                        .clipShape(Capsule())
                        .padding()
                })
                .disabled(!isNameValid)
            }
        }
    }
}

#Preview {
    struct PreviewView: View {
        @State var name: String = ""
        @State var registrationState: RegistrationState = .noting
        var body: some View {
            NameEntryView(name: $name, registrationState: $registrationState)
        }
    }
    
    return PreviewView()
}
