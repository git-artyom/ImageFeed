//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) // WebViewViewController получил код
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) // пользователь отменил авторизацию.
}

final class WebViewViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var UIProgressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // Unsplash’s OAuth2 path
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    // делегат
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeProgress()
        webView.navigationDelegate = self
        
        // формируем URL из компонентов
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    
    // метод вызывается, когда в результате действий пользователя WKWebView готовится совершить навигационные действия (например, загрузить новую страницу). Благодаря этому мы узнаем, когда пользователь успешно авторизовался.
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) { // возвращает код авторизации, если он получен.
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel) // Если код успешно получен, отменяем навигационное действие
        } else {
            decisionHandler(.allow) // и код не получен, разрешаем навигационное действие
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         // Получаем из навигационного действия navigationAction URL.
            let urlComponents = URLComponents(string: url.absoluteString),  // Получаем значения компонентов из URL.
            urlComponents.path == "/oauth/authorize/native",                //Проверяем совпадение адреса запроса с адресом получения
            let items = urlComponents.queryItems,                           // Проверяем, есть ли в URLComponents компоненты запроса
            let codeItem = items.first(where: { $0.name == "code" })        // ищем в массиве компонентов подходящее значение
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
    // блок методов логики индикатора активности
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingIndicator()
    }
}

extension WebViewViewController {
    func observeProgress() {
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    private func updateProgress() {
        UIProgressView.progress = Float(webView.estimatedProgress)
        UIProgressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// метод очистки куки
extension WebViewViewController {
    static func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
            // Массив полученных записей удаляем из хранилища
            records in records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}

