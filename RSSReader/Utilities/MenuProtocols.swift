
protocol HomeControllerDelegate: AnyObject {
    func toggleMenu()
}


protocol MenuControllerDelegate: AnyObject {
    func toggleHome()
}
