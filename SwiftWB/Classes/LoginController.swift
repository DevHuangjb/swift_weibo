//
//  LoginController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/17.
//  Copyright © 2017 huangjinbiao. All rights reserved.
//

import UIKit
import MJExtension
import SVProgressHUD

class LoginController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=3558842167&redirect_uri=http://www.520it.com"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(url: url as! URL)
        webView.loadRequest(request as URLRequest)
        SVProgressHUD.show(withStatus: "登录页面加载中...")
    }
    @IBAction func cancelClick(_ sender: Any) {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
}

//8cd0119160f9223ef52f786d3729bb8c
extension LoginController: UIWebViewDelegate
{
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        let str = "document.getElementsByClassName('header')[0].remove();";
//        webView.stringByEvaluatingJavaScript(from: str)
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix("http://www.520it.com/") {
            return true
        }
        let key = "code="
        
        if urlStr.components(separatedBy: key).count > 0
        {
            // url的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
            guard let code = request.url!.query?.substring(from: key.endIndex) else{
                return false
            }
            loadAccessToken(codeStr: code)
            return false
        }
        MYLOG(message: "授权失败")
        return false
    }

    private func loadAccessToken(codeStr: String)
    {
        weak var weakSelf = self
        let path = "oauth2/access_token"
        // 2.准备请求参数
        let parameters = ["client_id": "3558842167", "client_secret": "e60a1e86efe85384816c82df621948be", "grant_type": "authorization_code", "code": codeStr, "redirect_uri": "http://www.520it.com"]
        NetworkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (task, dict) in
            let userAccount = UserAccount.mj_object(withKeyValues: dict!)
            UserTools.setUser(user: userAccount!)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                weakSelf?.dismiss(animated: true, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = MainViewController()
            })
        }) { (task, error) in
            MYLOG(message: error)
        }
    }
}


