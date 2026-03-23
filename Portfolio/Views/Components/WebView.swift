//
//  WebView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 23.11.24..
//

#if os(iOS)
import SwiftUI
import QuickLook
@preconcurrency import WebKit
@_spi(Advanced) import SwiftUIIntrospect
import Combine

struct BrowserView: View {
    let initVM = WebViewVM()
    @State var navPath: [WebViewVM] = []
    @State var isDarkMode = true
    @State var isSettingsPresented = false
    @State var isSearchPresented = false
    @State var rssParser = RSSParser()
    @State var searchNewsText = ""

    var body: some View {
        NavigationStack(path: $navPath) {
            if navPath.isEmpty {
                ScrollView {
                    VStack(spacing: 20) {
                        if rssParser.items.isEmpty {
                            ContentUnavailableView.search(text: searchNewsText)
                        } else {
                            ForEach(rssParser.items) { item in
                                Button {
                                    navPath.append(
                                        .init(
                                            url: .init(string: NetworkManager.extractQueryParameter(from: item.link, parameter: "url")!)!,
                                            title: item.title,
                                            pageDescription: item.description
                                        )
                                    )
                                } label: {
                                    NewsView(item: item)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 15)
                }
                .refreshable {
                    if !isSearchPresented {
                        rssParser.parseRSS(url: .init(string: "https://www.bing.com/news/search?q=\(searchNewsText)&format=rss")!)
                    }
                }
                .navigationTitle("News")
                .onAppear {
                    rssParser.parseRSS(url: .init(string: "https://www.bing.com/news/search?q=euroleague&format=rss")!)
                }
                .searchable(
                    text: $searchNewsText,
                    isPresented: $isSearchPresented,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search News")
                )
                .onChange(of: searchNewsText) {
                    rssParser.parseRSS(url: .init(string: "https://www.bing.com/news/search?q=\(searchNewsText)&format=rss")!)
                }
            } else {
                WebView(vm: initVM, pathChanged: pathChanged, settingsClicked: settingsClicked)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: WebViewVM.self) { vm in
                        WebView(vm: vm, pathChanged: pathChanged, settingsClicked: settingsClicked)
                    }
            }
        }
        .tint(.primary)
        .introspect(.navigationStack, on: .iOS(.v17...)) {
            $0.hidesBarsOnSwipe = true
        }
        .onChange(of: isDarkMode) {
        }
        //        .sheet(isPresented: $isSettingsPresented) {
        //            NavigationStack {
        //                List {
        //                    Toggle("Dark Mode", isOn: $isDarkMode)
        //                }
        //                .frame(height: 100)
        //                .padding(.top)
        //                .overlay {
        //                    GeometryReader { g in
        //                        Color.clear
        //                            .presentationDetents([.height(g.size.height + 44)])
        //                    }
        //                }
        //                .navigationTitle("Settings")
        //                .navigationBarTitleDisplayMode(.inline)
        //            }
        //        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }

    func settingsClicked() {
        isSettingsPresented = true
    }

    func pathChanged(vm: WebViewVM) {
        navPath.append(vm)
    }
}

struct NewsView: View {
    let item: NewsItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
                .lineLimit(2)
            Text(item.description)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            if let hoursAgo = item.pubDate.timeAgo() {
                Text(hoursAgo)
            }
        }
        .padding()
        .multilineTextAlignment(.leading)
        .frame(height: 400, alignment: .bottom)
        .background {
            AsyncImage(url: .init(string: item.image)) {
                if let image = $0.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 400)
                        .overlay {
                            Rectangle()
                                .fill(.regularMaterial)
                                .mask(
                                    LinearGradient(gradient: Gradient(stops: [
                                        Gradient.Stop(color: Color(white: 0, opacity: 0),
                                                      location: 0),
                                        Gradient.Stop(color: Color(white: 0, opacity: 1),
                                                      location: 0.6)
                                    ]), startPoint: .top, endPoint: .bottom)
                                )
                        }
                }
            }
        }
        .clipped()
        .cornerRadius(20)
    }
}

struct WebView: View {
    @Bindable var vm: WebViewVM
    var pathChanged: (WebViewVM) -> Void
    var settingsClicked: () -> Void
    @State var isImageLoaded = false
    @State var isAboutPresented = false
    @State var isSearchPresented = false
    @State var sheetHeight = 0.0
    @State var isDevToolsPresented = false

    var body: some View {
        VStack {
            UIWebView(vm: vm)
            if vm.showSplitScreen {
                UIWebView(vm: vm)
            }
        }
        .animation(.smooth, value: vm.showSplitScreen)
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
                    ProgressView(value: vm.progress)
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
                        if let image = vm.images.first {
                            Button("Images", systemImage: "photo.stack") {
                                vm.imageURL = image
                            }
                        }
                        Button("Dev Tools", systemImage: "rectangle.on.rectangle.badge.gearshape") {
                            vm.addEruda()
                        }
                        Button("Translate", systemImage: "translate") {
                            vm.webview?.load(
                                .init(
                                    url: .init(
                                        string: "http://translate.google.com/translate?ie=UTF-8&u=\(vm.url.absoluteString)"
                                    )!
                                )
                            )
                        }
                        Button("Show split view", systemImage: "square.split.1x2") {
                            vm.showSplitScreen = true
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
        .quickLookPreview($vm.imageURL, in: vm.images)
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
            //                NavigationStack {
            VStack {
                about
                Button {
                    isAboutPresented = false
                    vm.pathChanged?(
                        .init(
                            url: .init(
                                string: "https://www.google.com/search?q=About \(vm.url.absoluteString)&tbm=ilp&ctx=chrome"
                            )!
                        )
                    )
                } label: {
                    Text("More")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .padding(.horizontal)
            }
            .padding()
            .overlay {
                GeometryReader { g in
                    Color.clear.onAppear {
                        sheetHeight = g.size.height + 56
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                }
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
            .presentationDetents([.height(sheetHeight)])
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
                //                    .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .redacted(reason: vm.pageTitle == nil ? .placeholder : [])
            }
            if vm.estReadingTimeMin != 0 {
                Text("Reading time: \(vm.estReadingTimeMin)min")
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
                        if let suggestion = suggestions[safe: i] {
                            vm.suggestions[i].favicon = try await NetworkManager.getFavicon(for: suggestion)
                        }
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

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = htmlContent.attributedString
    }
}

struct Suggestion: Identifiable, Equatable {
    let text: String
    var favicon: UIImage?
    let id = UUID()
}

@Observable
final class WebViewVM: NSObject {
    var url: URL
    var faviconUrlString: String?
    var favicon: UIImage?
    var pageTitle: String?
    var pageDescription: String?
    var pathChanged: ((WebViewVM) -> Void)?
    var isLoading = true
    var progress: Double = 0
    var imageURL: URL?
    var images: [URL] = []
    var accentColor: Int?
    var suggestions: [Suggestion] = []
    var searchText: String = ""
    var estReadingTimeMin: Int = 0
    var html: String = ""
    var webview: ObservableWebView?
    var showSplitScreen = false

    init(
        url: URL = .init(string: "https://google.com")!,
        faviconUrlString: String? = nil,
        favicon: UIImage? = nil,
        title: String? = nil,
        pageDescription: String? = nil,
        pathChanged: ((WebViewVM) -> Void)? = nil
    ) {
        self.url = url
        self.faviconUrlString = faviconUrlString
        self.favicon = favicon
        self.pageTitle = title
        self.pageDescription = pageDescription
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
            images.append(fileURL)
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

    @MainActor func getMetaData() {
        webview?.evaluateJavaScript(
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
                if pageTitle == nil {
                    pageTitle = dict["title"]
                }
                if pageDescription == nil {
                    pageDescription = dict["description"]
                }
                faviconUrlString = dict["favicon"]
                accentColor = Int(themeColor.dropFirst(), radix: 16)
                print("themeColor", themeColor)
            }
            if let error = error {
                print("Error retrieving: \(error)")
            }
        }
    }

    @MainActor func addEruda() {
        let script = """
                            (function () {
                                if (window.eruda) return;
                                var define;
                                if (window.define) {
                                    define = window.define;
                                    window.define = null;
                                }
                                var script = document.createElement('script');
                                script.src = '//cdn.jsdelivr.net/npm/eruda';
                                document.body.appendChild(script);
                                script.onload = function () {
                                    eruda.init();
                                    if (define) {
                                        window.define = define;
                                    }
                                }
                            })();
                        """
        webview?.evaluateJavaScript(script) {_, _ in }
    }

    @MainActor func translatePage() {
        let jsCode = """
            function googleTranslateElementInit() {
                new google.translate.TranslateElement({
                    pageLanguage: '',
                    layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
                },
                'google_translate_element');
            }
            var script = document.createElement('script');
            script.src = 'https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
            document.body.appendChild(script);
                        document.querySelector("div.skiptranslate").querySelector("a[href='https://translate.google.com']").remove();
            //            document.querySelector("img[src='https://www.google.com/images/cleardot.gif']”).parentElement.remove();
            //            var translateElement = document.createElement('div');
                        //            translateElement.setAttribute("id", "google_translate_element");
                        //            translateElement.style.position = 'fixed'; // Fix the element's position
                        //            translateElement.style.top = '0';          // Align it to the top edge
                        //            translateElement.style.left = '0';         // Align it to the left edge
                        //            translateElement.style.width = '100%';     // Make it full width
                        //            translateElement.style.zIndex = '9999';
            document.querySelector("div.skiptranslate").remove();
                        //            document.body.prepend(translateElement);
        """

        webview?.evaluateJavaScript(jsCode) { (_, error) in
            if let error = error {
                print("Error translating page: \(error.localizedDescription)")
            } else {
                print("Page translated successfully")
            }
        }
    }
}

class NetworkManager {
    static func getFavicon(for domain: String, size: Int = 32) async throws -> UIImage? {
        guard let url = URL(string: "https://www.google.com/s2/favicons?domain=\(domain)&sz=\(size)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return UIImage(data: data)
    }

    static func extractQueryParameter(from urlString: String, parameter: String) -> String? {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }

        if let value = queryItems.first(where: { $0.name == parameter })?.value {
            return value.removingPercentEncoding
        }

        return nil
    }
}

extension WebViewVM: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if navigationAction.navigationType == .linkActivated,
           let newURL = navigationAction.request.url,
           !newURL.absoluteString.contains("/#"),
           newURL.scheme == "http" || newURL.scheme == "https",
           !showSplitScreen {
            pathChanged?(.init(url: newURL))
            return .cancel
        } else {
            return .allow
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        getMetaData()

        let wordCountJS = #"""
        (function() {
        let article = document.querySelector('article');
            if (article) {
                            let text = document.body.innerText || document.body.textContent;
                            text = text.trim();
                            let wordArray = text.split(/\s+/);
                            return wordArray.filter(word => word.length > 0).length;
            } else {
                return 0;
        }
        })();
        """#

        webView.evaluateJavaScript(wordCountJS) { [self] (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let wordCount = result as? Int, wordCount != 0 {
                print("Word count: \(wordCount)")
                estReadingTimeMin = wordCount / 200
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getMetaData()
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
        webView.evaluateJavaScript("document.body.innerHTML") { [self] result, _ in
            if let res = result as? String {
                html = res
            }
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        webView.load(.init(url: .init(string: "https://www.google.com/search?q=\(url.absoluteString.replacingOccurrences(of: "https://", with: ""))")!))
    }
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

class ObservableWebView: WKWebView {
    var onProgressUpdate: ((Double) -> Void)?
    var cancellable: AnyCancellable?

    init(frame: CGRect, configuration: WKWebViewConfiguration, onProgressUpdate: ((Double) -> Void)?) {
        super.init(frame: frame, configuration: configuration)
        self.onProgressUpdate = onProgressUpdate
        cancellable = publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .sink { progress in
                print("Progress: \(progress)")
                onProgressUpdate?(progress)
            }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let webview = ObservableWebView(frame: .zero, configuration: config) { progress in
            vm.progress = progress
        }
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
    NewsView(
        item: .init(
            title: "NBA family reacts to LeBron James, the NBA’s scoring king, turning 40",
            link: "",
            description: "LeBron James celebrates his 40th birthday on Monday, and well wishes have begun to pour in from peers, fans and celebrities alike.",
            image: "http://www.bing.com/th?id=OVFT.CsOSd-MBRxy9FO11u79oEi",
            pubDate: "Mon, 30 Dec 2024 05:28:00 GMT"
        )
    )
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

    var attributedString: NSAttributedString? {
        let fullHTML = """
                    <style>

                    </style>
                    \(self)
            """
        do {
            let nsAttributedString = try NSAttributedString(
                data: Data(fullHTML.utf8),
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            return nsAttributedString
            //            do {
            //                return try AttributedString(nsAttributedString, including: \.uiKit)
            //                //                        attributedString?.font = .body
            //            } catch {
            //                print("Error converting NSAttributedString to AttributedString: \(error)")
            //            }
        } catch {
            print("Error creating NSAttributedString: \(error)")
        }
        return nil
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

@Observable
class RSSParser: NSObject, XMLParserDelegate, @unchecked Sendable {
    @ObservationIgnored private var currentElement = ""
    @ObservationIgnored private var currentTitle = ""
    @ObservationIgnored private var currentLink = ""
    @ObservationIgnored private var currentDescription = ""
    @ObservationIgnored private var currentImageUrl = ""
    @ObservationIgnored private var currentPubDate = ""
    var items: [NewsItem] = []

    func parseRSS(url: URL) {
        items = []
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            let parser = XMLParser(data: data)
            parser.shouldProcessNamespaces = true
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    // XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentImageUrl = ""
            currentPubDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "Image":
            currentImageUrl += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print(elementName)
        if elementName == "item" {
            if items.count < 10 {
                let item = NewsItem(
                    title: currentTitle,
                    link: currentLink,
                    description: currentDescription,
                    image: currentImageUrl.replacingOccurrences(of: "&pid=News", with: ""),
                    pubDate: currentPubDate
                )
                items.append(item)
            }
        }
    }

    //    func parserDidEndDocument(_ parser: XMLParser) {
    //        for item in items {
    //            print(item)
    //        }
    //    }
}

struct NewsItem: Identifiable {
    let title: String
    let link: String
    let description: String
    let image: String
    let pubDate: String
    var id: String { link }
}

extension String {
    func timeAgo() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let pastDate = dateFormatter.date(from: self) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: pastDate, relativeTo: Date())
        }
        return nil
    }
}
#endif
