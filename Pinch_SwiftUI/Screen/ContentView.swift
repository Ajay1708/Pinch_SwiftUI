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
    @State private var isDrawerOpen: Bool = false
    
    let pages:[Page] = pagesData
    
    @State private var pageIndex: Int = 1
    func pageImg() -> String{
        return pages[pageIndex - 1].name
    }
    
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
                Image(pageImg())
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
                // MARK: - DRAG GESTURE
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
                // MARK: - MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    }
                                    else if imageScale > 5{
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5{
                                    imageScale = 5
                                }
                                else if imageScale <= 1{
                                    resetImageState()
                                }
                            }
                    )
                
            }//: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            // MARK: - INFO PANEL VIEW
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30)
            }
            // MARK: - CONTROLS
            .overlay(alignment: .bottom) {
                Group{
                    HStack{
                        // Scale Down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1{
                                    imageScale -= 1
                                }
                                else{
                                    resetImageState()
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        // Reset
                        Button {
                            withAnimation(.spring()){
                                resetImageState()
                            }
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        // Scale Up
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5{
                                    imageScale += 1
                                }
                                else{
                                    imageScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .padding(.bottom, 30)
            }//: CONTROLS
            // MARK: - DRAWER
            .overlay(alignment: .topTrailing){
                HStack(spacing: 12){
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    // MARK: - THUMNAILS
                    ForEach(pages){ item in
                        Image(item.thumbImg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut, value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20:215)
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
