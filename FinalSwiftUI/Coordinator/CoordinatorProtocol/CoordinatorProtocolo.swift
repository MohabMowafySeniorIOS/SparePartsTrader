//
//  CoordinatorProtocolo.swift
//  MyAuctions
//
//  Created by مهاب موافي on 12/12/25.
//

import Foundation
import SwiftUI
protocol Coordinator: ObservableObject {
    var path: NavigationPath { get set }

    func push(_ route: AppFlow)
    func pop()
    func popToRoot()
}
