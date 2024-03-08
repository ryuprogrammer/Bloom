//
//  ResidenceEntryView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/02.
//

import SwiftUI

struct AddressEditView: View {
    let explanationText = ExplanationText()
    @State var prefecture: String = ""
    @Binding var address: String
    @State var isAddressValid: Bool = false
    let registrationVM = RegistrationViewModel()
    
    @Binding var path: [MyPagePath]
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(registrationVM.prefectures.prefectures, id: \.self) { prefecture in
                    if self.prefecture == prefecture {
                        Text(prefecture)
                            .font(.title)
                            .foregroundStyle(Color.pink.opacity(0.8))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background {
                                Capsule().stroke(Color.pink.opacity(0.8), lineWidth: 5)
                            }
                            .padding(2)
                    } else {
                        Text(prefecture)
                            .font(.title)
                            .foregroundStyle(Color(UIColor.lightGray))
                            .onTapGesture {
                                withAnimation {
                                    self.prefecture = prefecture
                                    
                                    if !address.isEmpty && prefecture != address {
                                        isAddressValid = true
                                    } else if prefecture == address {
                                        isAddressValid = false
                                    }
                                }
                            }
                            .padding(2)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(height: 130)
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    address = prefecture
                    path.removeAll()
                }, label: {
                    Text("居住地を更新")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(isAddressValid ? Color.pink.opacity(0.8) : Color(UIColor.lightGray))
                        .clipShape(Capsule())
                        .padding()
                })
                .disabled(!isAddressValid)
            }
        }
        .onAppear {
            prefecture = address
        }
    }
}

#Preview {
    struct PreviewView: View {
        @State var address: String = ""
        @State var path: [MyPagePath] = []
        var body: some View {
            AddressEditView(address: $address, path: $path)
        }
    }
    
    return PreviewView()
}
