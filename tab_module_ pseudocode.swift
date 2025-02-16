// Root Module

class ApplicationCoordinator {
    
    func runTabBarFlow() {
        let fooTab = FooBuilder().makeTabBarRegisteration()
        let pooTab = PooBuilder().makeTabBarRegisteration()
        
        let coordinator = TabBarCoordinator(
            factory: MainTabBuilder(tabs: [fooTab, pooTab])
        )
        
        coordinator.start()
    }
}

// MainTab Module

class TabBarCoordinator {
    let factory: MainTabBuilder
    
    func start() {
        let tabVC = factory.makeTabVC()
        // 라우터 로직
    }
    
    init(factory: MainTabBuilder) {
        self.factory = factory
    }
}

class MainTabBuilder {
    private let tabs: [TabBarRegisteration]
    
    init(tabs: [TabBarRegisteration]) {
        self.tabs = tabs
    }
    
    func makeTabVC() -> TabBarController {
        return TabBarController(tabList: tabs)
    }
}

class TabBarController: UITabBarController {
    
    private let tabList: [TabBarRegisteration]
    
    init(tabList: [TabBarRegisteration]) {
        self.tabList = tabList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarItems()
        configureViewControllers()
    }
    
    //MARK: - Custom Method
    
    private func configureTabBarItems() {
        tabList.forEach { factory in
            factory.rootVC.vc.tabBarItem = UITabBarItem(title: factory.title,
                                                        image: factory.image,
                                                        selectedImage: factory.selectedImage)
        }
    }
    
    private func configureViewControllers(){
        tabList.forEach { factory in
            viewControllers?.append(factory.rootVC.vc)
        }
    }
    
}

// Foo Module

class FooBuilder {
    func makeTabBarRegisteration() -> TabBarRegisteration {
        let vc = makeFooVC()
        return TabBarRegisteration(title: "Foo", image: UIImage(), selectedImage: UIImage(), rootVC: vc)
    }
    
    func makeFooVC() -> ViewControllable {
        FooVC()
    }
}

class FooVC: ViewControllable {
    let vc = UIViewController(nibName: nil, bundle: nil)
}


// BaseFeature

protocol ViewControllable {
    var vc: UIViewController { get }
}


struct TabBarRegisteration {
    let title: String
    let image: UIImage
    let selectedImage: UIImage
    let rootVC: any ViewControllable
}
