# 1) What is the relationship between a class and an object?
#    A class is a template for creating objects; objects are things created from
#    classes.
#    - The class defines the attributes and the behaviors that its objects will 
#      have access to when created
#    - Attribute values are unique to each object; behaviors are shared among 
#      objects of the same class.

# 2) What are class variables and class methods?
#    Class variables are variables that track data associated with a class as a 
#    whole, rather than to any one single object.
#     ie. Data that is unconcerned with any single object's state.
#    Class methods are methods that provide behavior for the class as a whole,
#    rather than for individual objects.

#    tl;dr: Behaviors and methods that concern the class as a whole concept, 
#     instead of specific objects of that class.

# 3) Inheritance:
#    Classes can sub-class from one parent class (referred to as the superclass.)
#     Subclasses gain access to all the methods (and class variables) defined in
#     the parent class.
#    Modules are bundles of methods, classes, and constants that can be mixed in
#     to a class to grant that class and its objects the behaviors within the
#     module.
#    Method lookup path: 
#     Class -> Modules (last->first) -> Superclass -> Superclass modules -> etc..
#     -> Object -> Kernel -> BasicObject