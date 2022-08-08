//
//  ContentView.swift
//  Pinch_SwiftUI
//
//  Created by Apple on 07/08/22.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTY
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    //MARK: - FUNCTION
    func resetImageState(){
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    var body: some View {
        NavigationView {
            ZStack{
                Color.clear
                //Here if you remove this color view you can see that this ZStack is not wholly occupying the whole screen. Thats why i added a color view which will add a space on top of image
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: - TAP GESTURE
                    .onTapGesture(count: 2) {
                        if imageScale == 1{
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }
                        else{
                            resetImageState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 0.5)) {
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ _ in
                                withAnimation(.spring()) {
                                    if imageScale <= 1{
                                        resetImageState()
                                    }
                                    else{
                                        
                                    }
                                }
                            })
                    )
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30)
            }
        }//: Navigation
        .navigationViewStyle(.stack) // This navigation style will avoid using the sidebar on iPad devices
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
