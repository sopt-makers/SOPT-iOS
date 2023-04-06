import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/DependencyPlugin")),
        .local(path: .relativeToRoot("Plugins/ConfigPlugin")),
        .local(path: .relativeToRoot("Plugins/EnvPlugin"))
    ],
    generationOptions: .options()
)
