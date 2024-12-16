//
//  WebView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 23.11.24..
//

import SwiftUI
import QuickLook
@preconcurrency import WebKit
@_spi(Advanced) import SwiftUIIntrospect

struct BrowserView: View {
    @State var navPath: [WebViewVM] = []
    let initVM = WebViewVM()
    @State var isDarkMode = true
    @State var isSettingsPresented = false

    var body: some View {
        NavigationStack(path: $navPath) {
            WebView(vm: initVM, pathChanged: pathChanged, settingsClicked: settingsClicked)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: WebViewVM.self) { vm in
                    WebView(vm: vm, pathChanged: pathChanged, settingsClicked: settingsClicked)
                }
        }
        .tint(.primary)
        .introspect(.navigationStack, on: .iOS(.v17...)) {
            $0.hidesBarsOnSwipe = true
        }
        .onChange(of: isDarkMode) {
        }
        .sheet(isPresented: $isSettingsPresented) {
            NavigationStack {
                List {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                .frame(height: 100)
                .padding(.top)
                .overlay {
                    GeometryReader { g in
                        Color.clear
                            .presentationDetents([.height(g.size.height + 44)])
                    }
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }

    func settingsClicked() {
        isSettingsPresented = true
    }

    func pathChanged(vm: WebViewVM) {
        navPath.append(vm)
    }
}

struct SuggestionsView: View {
    var body: some View {
        Text("suggiestions")
    }
}

struct WebView: View {
    @ObservedObject var vm: WebViewVM
    var pathChanged: (WebViewVM) -> Void
    var settingsClicked: () -> Void
    @State var isImageLoaded = false
    @State var isAboutPresented = false
    @State var isSearchPresented = false

    var body: some View {
        UIWebView(vm: vm)
            .ignoresSafeArea(edges: .top)
//            .overlay {
//                if vm.isLoading {
//                    ZStack {
//                        if let favicon = vm.favicon {
//                            Image(uiImage: favicon)
//                                .resizable()
//                        } else if let favicon = vm.faviconUrlString {
//                            AsyncImage(url: .init(string: favicon)) {
//                                if let image = $0.image {
//                                    image
//                                        .resizable()
//                                }
//                            }
//                        }
//                        Color.clear.background(.ultraThickMaterial)
//                    }
//                }
//            }
            .overlay {
                if vm.isLoading {
                    VStack {
//                        ProgressView(value: vm.progress)
                        about.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(.ultraThickMaterial)
                }
            }
            .navigationTitle(vm.pageTitle?.isEmpty == true ? "\(vm.url.generateTitle() ?? "")" : vm.pageTitle ?? "")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if !vm.isLoading {
                            Button("Reload", systemImage: "arrow.clockwise") {
                                vm.webview?.reload()
                            }
                            Button("About this page", systemImage: "info.circle.fill") {
                                isAboutPresented.toggle()
                            }
                            Button("Settings", systemImage: "gearshape") {
                                settingsClicked()
                            }
                        }
                        ShareView(urlString: vm.url.absoluteString, title: "Share Website")
                    } label: {
                        Label("Menu", systemImage: "ellipsis")
                    }
                }
            }
            .onAppear {
                vm.pathChanged = pathChanged
            }
            .overlay(alignment: .top) {
                Color.clear
                    .background(.ultraThinMaterial)
                    .background {
                        if let accentColor = vm.accentColor {
                            Color(hex: accentColor).opacity(0.3)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 0)
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .quickLookPreview($vm.imageURL)
            .animation(.default, value: vm.isLoading)
            .animation(.default, value: vm.progress)
            .animation(.default, value: vm.pageTitle)
            .animation(.default, value: vm.pageDescription)
            .animation(.default, value: vm.faviconUrlString)
            .animation(.default, value: vm.suggestions)
            .searchable(
                text: $vm.searchText,
                isPresented: $isSearchPresented,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Type URL")
            )
            .overlay {
                if isSearchPresented {
                    ZStack {
                        if !vm.searchText.isEmpty, !vm.suggestions.isEmpty {
                            List(vm.suggestions) { suggestion in
                                Button {
                                    if let url = URL(string: "https://\(suggestion.text)") {
                                        pathChanged(
                                            .init(
                                                url: url,
                                                favicon: suggestion.favicon
                                            )
                                        )
                                    } else {
                                        pathChanged(
                                            .init(
                                                url: .init(string: "https://google.com/search?q=\(suggestion.text)")!,
                                                favicon: suggestion.favicon
                                            )
                                        )
                                    }
                                } label: {
                                    HStack {
                                        if let favicon = suggestion.favicon {
                                            Image(uiImage: favicon)
                                        }
                                        Text(suggestion.text)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .scrollBounceBehavior(.basedOnSize)
                        } else {
                            ContentUnavailableView("No results", systemImage: "minus.magnifyingglass")
                        }
                    }.background(.ultraThickMaterial)
                }
            }
            .onChange(of: vm.searchText) {
                search()
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .onSubmit(of: .search) {
                if let url = URL(string: "https://\(vm.searchText)"), "https://\(vm.searchText)".isValidURL {
                    pathChanged(.init(url: url))
                }
            }
            .keyboardType(.URL)
//            .introspect(.viewController, on: .iOS(.v17...)) {
//                $0.navigationController?.navigationItem.searchController = .init(searchResultsController: UIHostingController(rootView: SuggestionsView()))
//                $0.navigationController?.navigationItem.searchController?.automaticallyShowsSearchResultsController = false
//                $0.navigationController?.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
//                print($0.navigationController?.navigationItem.searchController)
//            }
            .sheet(isPresented: $isAboutPresented) {
               about
                    .padding(.top)
                    .overlay {
                        GeometryReader { g in
                            Color.clear
                                .presentationDetents([.height(g.size.height)])
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    ZStack {
//                        if let favicon = vm.favicon {
//                            Image(uiImage: favicon)
//                                .resizable()
//                        } else if let favicon = vm.faviconUrlString {
//                            AsyncImage(url: .init(string: favicon)) {
//                                if let image = $0.image {
//                                    image
//                                        .resizable()
//                                }
//                            }
//                            .opacity(0.5)
//                        }
                        if let accentColor = vm.accentColor {
//                            Color.clear.background(.ultraThickMaterial)
                            Color(hex: accentColor).opacity(0.1)
                        }
                    }
                }
                .presentationBackground(.regularMaterial)
                .presentationDragIndicator(.visible)
            }
    }

    var about: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack {
                    if let favicon = vm.favicon {
                        Image(uiImage: favicon)
                            .resizable()
                    } else if let faviconUrlString = vm.faviconUrlString {
                        AsyncImage(url: .init(string: faviconUrlString)) {
                            if let image = $0.image {
                                image
                                    .resizable()
                            } else {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .onDisappear {
                                        isImageLoaded = true
                                    }
                            }
                        }
                    } else {
                        Image(systemName: "star.fill")
                            .resizable()
                    }
                }
                .frame(width: 48, height: 48, alignment: .center)
                .redacted(reason: !isImageLoaded && vm.favicon == nil ? .placeholder : [])
                Text(
                    vm.pageTitle?.isEmpty == true
                    ? "\(vm.url.generateTitle() ?? "some page title")"
                    : vm.pageTitle ?? "some page title"
                )
//                    .lineLimit(2)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .redacted(reason: vm.pageTitle == nil ? .placeholder : [])
            }
            Text(vm.pageDescription ?? "some description some description some description")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .redacted(reason: vm.pageDescription == nil ? .placeholder : [])
        }
        .padding()
    }

    func search() {
        Task {
            do {
                let suggestions = try await vm.getSearchSuggestions(for: vm.searchText)
                vm.suggestions = suggestions.map { Suggestion(text: $0) }
                for i in suggestions.indices {
                    do {
                        vm.suggestions[i].favicon = try await vm.getFavicon(for: suggestions[i])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct Suggestion: Identifiable, Equatable {
    let text: String
    var favicon: UIImage?
    let id = UUID()
}

final class WebViewVM: NSObject, ObservableObject {
    @Published var url: URL
    @Published var faviconUrlString: String?
    @Published var favicon: UIImage?
    @Published var pageTitle: String?
    @Published var pageDescription: String?
    var pathChanged: ((WebViewVM) -> Void)?
    @Published var isLoading = true
    @Published var progress: Double = 0
    @Published var imageURL: URL?
    @Published var accentColor: Int?
    @Published var suggestions: [Suggestion] = []
    @Published var searchText: String = ""
    var webview: WKWebView?

    init(
        url: URL = .init(string: "https://google.com")!,
        faviconUrlString: String? = nil,
        favicon: UIImage? = nil,
        title: String? = nil,
        pathChanged: ((WebViewVM) -> Void)? = nil
    ) {
        self.url = url
        self.faviconUrlString = faviconUrlString
        self.favicon = favicon
        self.pageTitle = title
        self.pathChanged = pathChanged
        searchText = url.absoluteString.replacingOccurrences(of: "https://", with: "")
    }

    @MainActor @objc func reloadWebView() {
        webview?.reload()
    }

    @MainActor
    func downloadImage(from url: URL, alt: String) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            saveImageToDocumentsDirectory(
                imageData: data,
                alt: alt.isEmpty ? url.lastPathComponent : "\(alt).jpg"
            )
        } catch {
            print("Error downloading image: \(error)")
        }
    }

    @MainActor
    func saveImageToDocumentsDirectory(imageData: Data, alt: String) {
        let fileURL: URL = .documentsDirectory.appendingPathComponent(alt)
        do {
            try imageData.write(to: fileURL)
            imageURL = fileURL
            print("Image saved at: \(fileURL)")
        } catch {
            print("Error saving image: \(error)")
        }
    }

    @MainActor
    func getSearchSuggestions(for term: String) async throws -> [String] {
        let baseURL = "https://suggestqueries.google.com/complete/search"
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client", value: "firefox"),
            URLQueryItem(name: "q", value: term)
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any],
               let suggestionsArray = json[1] as? [String] {
                return suggestionsArray
            } else {
                throw URLError(.cannotParseResponse)
            }
        } catch {
            throw error
        }
    }

    @MainActor
    func getFavicon(for domain: String, size: Int = 32) async throws -> UIImage? {
        guard let url = URL(string: "https://www.google.com/s2/favicons?domain=\(domain)&sz=\(size)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return UIImage(data: data)
    }

    @MainActor func changeTheme() {
        let toggleThemeJs = """
        const links = document.querySelectorAll('a');
        for (let link of links) {
            if (link.innerHTML.toLowerCase().includes('theme')) {
                link.click();
                console.log("Theme toggled!");
                break;
            }
        }
        """
        webview?.evaluateJavaScript(toggleThemeJs, completionHandler: nil)
    }
}

extension WebViewVM: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.evaluateJavaScript(
                       """
                          (function () {
                            var title = document.title;
                            var description = document.querySelector('meta[name="description"]')?.content || '';
                            var themeColor = document.querySelector('meta[name="theme-color"]')?.content || '';
                            var favicon = document.querySelector('link[rel="icon"], link[rel="shortcut icon"]')?.href || '';
                            return {title: title, description: description, favicon: favicon, themeColor: themeColor};
                          })();
                       """
        ) { [self] (result, error) in
            if let dict = result as? [String: String], let themeColor = dict["themeColor"] {
                pageTitle = dict["title"]
                pageDescription = dict["description"]
                faviconUrlString = dict["favicon"]
                accentColor = Int(themeColor.dropFirst(), radix: 16)
                print("themeColor", themeColor)
            }
            if let error = error {
                print("Error retrieving: \(error)")
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
        webView.scrollView.refreshControl?.endRefreshing()
        let js = """
            document.addEventListener('click', function(event) {
                let img = event.target.tagName === 'IMG' ? event.target : event.target.querySelector('img');
                if (img && !img.closest('a')) {
                    window.webkit.messageHandlers.imageClicked.postMessage({
                        src: img.src,
                        alt: img.alt
                    });
                }
            });
        """
        webView.evaluateJavaScript(js, completionHandler: nil)
        let removeCookiesBannerJs = """
    document.querySelectorAll('[id*="cookie"], [class*="cookie"]').forEach(element => {
        element.remove();
    });
    """
        webView.evaluateJavaScript(removeCookiesBannerJs, completionHandler: nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if navigationAction.navigationType == .linkActivated,
           let newURL = navigationAction.request.url,
           !newURL.absoluteString.contains("/#"),
           newURL.scheme == "http" || newURL.scheme == "https" {
            pathChanged?(.init(url: newURL))
            return .cancel
        } else {
            return .allow
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        webView.load(.init(url: .init(string: "https://www.google.com/search?q=\(url.absoluteString.replacingOccurrences(of: "https://", with: ""))")!))
    }

//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(WKWebView.estimatedProgress) {
//            if let webView = object as? WKWebView {
//                Task { @MainActor in
//                    self.progress = webView.estimatedProgress
//                }
//            }
//        }
//    }
}

extension WebViewVM: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "imageClicked" {
            if let imageUrlString = message.body as? [String: String],
                let src = imageUrlString["src"],
               let alt = imageUrlString["alt"],
                let imageUrl = URL(string: src) {
                Task {
                    await downloadImage(from: imageUrl, alt: alt)
                }
            }
        } else if message.name == "getSuggestions" {
            if let suggestions = message.body as? [String] {
                print(suggestions)
            }
        }
    }
}

struct UIWebView: UIViewRepresentable {
    let vm: WebViewVM

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(vm, name: "imageClicked")
        config.userContentController.add(vm, name: "getSuggestions")
        config.mediaTypesRequiringUserActionForPlayback = .all
        config.allowsInlineMediaPlayback = true
        let jsonRules = """
                [
                    {
                        "trigger": {
                            "url-filter": ".*ad.doubleclick.net.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    },
                    {
                        "trigger": {
                            "url-filter": ".*googleads.g.doubleclick.net.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    },
                    {
                        "trigger": {
                            "url-filter": ".*googlesyndication.com.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    },
                    {
                        "trigger": {
                            "url-filter": ".*pagead2.googlesyndication.com.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    },
                    {
                        "trigger": {
                            "url-filter": ".*securepubads.g.doubleclick.net.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    },
                    {
                        "trigger": {
                            "url-filter": ".*ads.pubmatic.com.*"
                        },
                        "action": {
                            "type": "block"
                        }
                    }
                ]

        """
        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "BlockAds",
            encodedContentRuleList: jsonRules
        ) { ruleList, error in
            if let error = error {
                print("Failed to compile content rule list: \(error)")
                return
            }
            if let ruleList = ruleList {
                config.userContentController.add(ruleList)
            }
        }
        let webview = WKWebView(frame: .zero, configuration: config)
//        webview.addObserver(vm, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(vm, action: #selector(vm.reloadWebView), for: .valueChanged)
        webview.scrollView.refreshControl = refreshControl
        webview.navigationDelegate = vm
        vm.webview = webview
        return webview
    }

    func updateUIView(_ webview: WKWebView, context: Context) {
        let request = URLRequest(url: vm.url)
        webview.load(request)
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true)) {
            BrowserView()
        }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension URL {
    func generateTitle() -> String? {
        guard let lastPath = lastPathComponent.removingPercentEncoding else {
            return nil
        }
        let words = lastPath
            .split(separator: "-")
            .map { $0.capitalized }
        return words.joined(separator: " ")
    }
}

extension WKWebView {
    func takeScreenshot(completion: @escaping (UIImage?) -> Void) {
        let config = WKSnapshotConfiguration()
        self.takeSnapshot(with: config) { image, error in
            guard let image = image else {
                print("Error taking snapshot: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
