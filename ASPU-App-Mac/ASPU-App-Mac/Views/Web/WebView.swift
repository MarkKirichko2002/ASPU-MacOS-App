//
//  WebView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 16.08.2024.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    
    @State var isLoading = true
    var url: String
    
    func makeNSView(context: Context)-> NSView {
        let view = WKWebView()
        DispatchQueue.main.async {
            view.load(URLRequest(url: URL(string: url)!))
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let currentURL = (nsView as? WKWebView)?.url?.absoluteString, currentURL != url {
            (nsView as? WKWebView)?.load(URLRequest(url: URL(string: url)!))
        }
    }
}

#Preview {
    WebView(url: "")
}
