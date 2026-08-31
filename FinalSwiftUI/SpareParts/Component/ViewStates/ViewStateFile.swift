//
//  ViewStateFile.swift
//  SpareParts
//
//  Created by مهاب موافي on 1/24/26.
//

import Foundation
import SwiftUI
enum LoadingState {
    case progress
    case Skeliton
    
}

enum viewState<T> {
    case loading(loading: LoadingState)
    case loaded(data: T?)
    case idle
    case error(String)
    case emptyScreen
    
    var data: T? {
        
        if case let .loaded(data) = self {
            return data
           }
           return nil
       }
}

struct ShowViewState<T, Content: View>: View {
    let state: viewState<T>
      
    @ViewBuilder let content: (T?) -> Content
    @State private var rotation: Double = 0
    @State private var isLoading = true
   
  
    var body: some View {
        getViewState(state: state)
    }
    
   
    
    @ViewBuilder
    func getViewState(state: viewState<T>) -> some View {
        switch state {
        case .loading(let state):
            switch state {
            case .progress:
                LoaderView(rotation: $rotation, isLoading: $isLoading)
                    .frame(width: 100, height: 100)
            case .Skeliton:
                skeletonView()
            }
                
        case .loaded(let data):
            content(data)
            
        case .error(let error):
            ZStack {
                content(nil)
                errorToast(msg: error)
            }
           
        case .idle:
            content(nil)
        case .emptyScreen:
            emptyView
           
        }
        
        
    }
    
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image("noResultImage")
            Text("No Results found".localized)
                .font(.custom(AppFont.bold.rawValue, size: 20))
            Text("Please try again".localized)
                .font(.custom(AppFont.Regular.rawValue, size: 16))
            Spacer()
        }
    }
    
    @ViewBuilder
    func errorToast(msg: String?) -> some View {
        if let errorMessage = msg, !errorMessage.isEmpty {
            ToastView(message: errorMessage, backgroundColor: Color.CRed)
                .transition(.move(edge: .top))
                .zIndex(0.1)
        }
    }
}


struct skeletonView: View {
    
    var body: some View {
        Text("Load As Skeleton")
    }
}
