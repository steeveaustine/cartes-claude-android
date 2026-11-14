import SwiftUI
import UIKit
import WebKit

@main
struct ClaudeEnMainApp: App {
    var body: some Scene {
        WindowGroup {
            PageView()
                .ignoresSafeArea()
                .background(Color("Bg").ignoresSafeArea())
        }
    }
}

/// La page de l'appli, rangée dans le paquet (dossier Web), affichée en plein écran.
/// Elle gère elle-même les encoches grâce à viewport-fit=cover et aux marges env(safe-area-inset-*).
struct PageView: UIViewRepresentable {
    func makeCoordinator() -> Bridge { Bridge() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let scripts = config.userContentController
        scripts.add(context.coordinator, name: "copy")
        scripts.add(context.coordinator, name: "open")
        if let url = Bundle.main.url(forResource: "bridge", withExtension: "js", subdirectory: "Web"),
           let source = try? String(contentsOf: url, encoding: .utf8) {
            scripts.addUserScript(WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        }

        let web = WKWebView(frame: .zero, configuration: config)
        let bg = UIColor(named: "Bg") ?? .systemBackground
        web.isOpaque = false
        web.backgroundColor = bg
        web.scrollView.backgroundColor = bg
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.allowsBackForwardNavigationGestures = true
        web.allowsLinkPreview = false
        web.uiDelegate = context.coordinator

        if let page = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Web") {
            web.loadFileURL(page, allowingReadAccessTo: page.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ web: WKWebView, context: Context) {}
}

/// Reçoit les messages de bridge.js : copier un texte, ouvrir un lien hors de l'appli.
final class Bridge: NSObject, WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let text = message.body as? String else { return }
        switch message.name {
        case "copy":
            UIPasteboard.general.string = text
        case "open":
            Bridge.openOutside(URL(string: text))
        default:
            break
        }
    }

    // Filet de sécurité pour les liens target="_blank" qui échapperaient à bridge.js.
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        Bridge.openOutside(navigationAction.request.url)
        return nil
    }

    /// Safari, ou l'appli concernée quand elle est installée (Claude, Mail, Téléphone…).
    static func openOutside(_ url: URL?) {
        guard let url = url, !url.isFileURL else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
}
