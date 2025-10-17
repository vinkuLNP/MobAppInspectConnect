# clean_architecture

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

In order to generate any system file, command "dart run build_runner build --delete-conflicting-outputs" need to implemented. But it will generate only once and need to be called again and again. Instead "dart run build_runner watch" can be used to generate file automatically oonce any change is being made in code which requires system generated file. 

auto_route package is used to generate routes automatically. @RoutePage() is need to be added at the top of class screen, which you want to add in routes and add routename in file auto_router.dart replacing View or Screen keyword of class name with Route keyword. Then run the command "dart run build_runner build --delete-conflicting-outputs" to genrate auto_router.g.dart file.

ObjectBox package is used to store the local database. It is NoSQL database. For this, you need to define your model by adding an @Entity to top of model.

Injectable is used to inject any dependency accross the project. 

To generate to/from JSON code for a class, JsonSerializable is used. You can provide arguments to JsonSerializable to configure the generated code. You can also customize individual fields by annotating them with JsonKey and providing custom arguments

For State Management, provider is used.

# inspectConnect
