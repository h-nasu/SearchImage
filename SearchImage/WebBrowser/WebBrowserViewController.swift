//
//  WebBrowserViewController.swift
//  SearchImage
//
//  Created by Hiroshi Nasu on 8/8/19.
//  Copyright © 2019 Hiroshi Nasu. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class WebBrowserViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewToolBar: UIToolbar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var lastContentOffset: CGFloat = 0
    let window = UIApplication.shared.keyWindow
    private var webViewToolBarHideHeight: CGFloat = 0
    private var searchbar: UISearchBar!
    private var imageArray: [String]!
    private var senderBuff: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.allowsBackForwardNavigationGestures = true
        self.webViewToolBarHideHeight = self.view.frame.height + (window?.safeAreaInsets.bottom)!
        self.webViewToolBar.center.y = self.webViewToolBarHideHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchbar = UISearchBar()
        self.searchbar.delegate = self
        self.searchbar.returnKeyType = .go
        self.searchbar.searchBarStyle = .prominent
        self.searchbar.placeholder = "Search or enter website name"
        self.searchbar.autocapitalizationType = .none
        self.searchbar.autocorrectionType = .no
        self.navigationItem.titleView = self.searchbar
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.webView.scrollView.delegate = self
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.webView.configuration.preferences.javaScriptEnabled = true

        //let scriptSource = "document.body.style.backgroundColor = `red`; alert('test');"
        //let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //self.webView.configuration.userContentController.addUserScript(script)
        /*
        let scriptSource2 = "function testGo() {window.webkit.messageHandlers.test.postMessage('Hello Word!');}"
        let script2 = WKUserScript(source: scriptSource2, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.webView.configuration.userContentController.add(self, name: "test")
        self.webView.configuration.userContentController.addUserScript(script2)
        */
        
        guard let scriptPath = Bundle.main.path(forResource: "SIUtils", ofType: "js"),
        let scriptSource3 = try? String(contentsOfFile: scriptPath) else { return }
        let userScript3 = WKUserScript(source: scriptSource3, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript3)
 
        
        //let myURL = URL(string:"https://www.apple.com")
        let myURL = URL(string:"https://instagram.com")
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
      
    }
    
    private func _scrollDown(numTimes: Int = 1, heightBefore: CGFloat = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let height = self.webView.scrollView.contentSize.height - self.webView.frame.size.height
            if numTimes > 0 && height > heightBefore {
                let scrollPoint = CGPoint(x: 0, y: height)
                self.webView.scrollView.setContentOffset(scrollPoint, animated: true)
                let next = numTimes - 1
                self._scrollDown(numTimes: next, heightBefore: height)
            } else {
                self._getImages()
            }
        }
    }
    
    private func _getImages() {
        self.webView.evaluateJavaScript("SIutils.getAllImages()") { (result, error) in
            if error != nil {
                print(error)
            } else {
                if let images = result as? [String] {
                    self.imageArray = images
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "PageImagesViewController", sender: self.senderBuff)
                    }
                }
                
            }
        }
    }
    
    @IBAction func pressBack(_ sender: UIBarButtonItem) {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
    }
    
    @IBAction func pressForward(_ sender: UIBarButtonItem) {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        }
    }
    
    @IBAction func pressRefresh(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    @IBAction func pressAction(_ sender: UIBarButtonItem) {
        /*
        self.webView.evaluateJavaScript("testGo();", completionHandler: {
            result, error in
            if error != nil {
                print(error)
            }
        })
        */
        /*
        let height = self.webView.scrollView.contentSize.height - self.webView.frame.size.height
        let scrollPoint = CGPoint(x: 0, y: height)
        self.webView.scrollView.setContentOffset(scrollPoint, animated: true)
 */
        self.senderBuff = sender
        //self._scrollDown(numTimes: 4)
        self._getImages()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "PageImagesViewController":
            guard let PageImagesVC = segue.destination as? PageImagesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            // pass to vc properties
            PageImagesVC.imagesArray = self.imageArray
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // Scroll View Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                self.webViewToolBar.center.y = self.view.frame.height - 44
            })
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                self.webViewToolBar.center.y = self.webViewToolBarHideHeight
            })
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // Searchbar Delegates
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchbar.resignFirstResponder()
        
        var sText: String
        guard let searchText = self.searchbar.text else {
            return
        }
        if !searchText.contains("http://") && !searchText.contains("https://") {
            sText = "https://"+searchText
        } else {
            sText = searchText
        }
        
        if let url = URL(string: sText) {
            //Get the URL from the search bar. Create a new NSURLRequest with it and tell the webView to navigate to that URL/Page. Also specify a timeout for if the page takes too long. Also handles cookie/caching policy.
            
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            //let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    // WebView Delegates
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow) //allow the user to navigate to the requested page.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow) //allow the webView to process the response.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
        
        //Handle the error. Display an alert to the user telling them what happened.
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        
        // Update our search bar with the webPage's final endpoint-URL.
        if let url = self.webView.url {
            self.searchbar.text = url.absoluteString
        }
        
        // Init Utils.js
        self.webView.evaluateJavaScript("let SIutils = new SIUtils()") { (result, error) in
            if error != nil {
                print(error)
            }
        }
 
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //When the webview receives a "Redirect" to a different page or endpoint, this is called.
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //When the content for the webpage starts arriving, this is called.
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        //completionHandler(.performDefaultHandling, .none) //Handle SSL connections by default. We aren't doing SSL pinning or custom certificate handling.
        
        if let trust = challenge.protectionSpace.serverTrust {
            let exceptions = SecTrustCopyExceptions(trust)
            SecTrustSetExceptions(trust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.performDefaultHandling, .none)
        }
 
        
 
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
            //UIApplication.shared.open(navigationAction.request.url!, options: [:])
        }
        return nil
    }
    
    //WebView's UINavigation Delegates
    /*
    //This is called when a webView or existing loaded page wants to open a new window/tab.
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        //The view that represents the new tab/window. This view will have an X button at the top left corner + a webView.
        let container = UIView()
        
        //New tabs need an exit button.
        let XButton = UIButton()
        XButton.addTarget(self, action: #selector(onWebViewExit), for: .touchUpInside)
        XButton.layer.cornerRadius = 22.0
        
        //Create the new webView window.
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        //Layout the tab.
        container.addSubview(XButton)
        container.addSubview(webView)
        
        let views: [String: AnyObject] = ["XButton": XButton, "webView": webView];
        var constraints = Array<String>()
        
        constraints.append("H:|-(-22)-[XButton(44)]")
        constraints.append("H:|-0-[webView]-0-|")
        constraints.append("V:|-(-22)-[XButton(44)]-0-[webView]-0-|")
        
        
        //constrain the subviews.
        for constraint in constraints {
            container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        }
        
        for view in container.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //TODO: Add the containerView to self.view or present it with a new controller. Keep track of tabs..
        
        return webView
    }
    
    @objc func onWebViewExit(button: UIButton) {
        //TODO: Destroy the tab. Remove the new tab from the current window or controller.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
extension WebBrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received Message!")
        if message.name == "test", let messageBody = message.body as? String {
            print(messageBody)
        }
    }
}

*/
