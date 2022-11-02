//
//  ViewController.swift
//  test
//
//  Created by Anna Abdeeva on 31.10.2022.
//

import UIKit
import os

struct Product: Equatable {
    var id: String; // unique identifier
    let name: String;
    let producer: String;
}

protocol Shop {
    /**
     Adds a new product object to the Shop.
     - Parameter product: product to add to the Shop
     - Returns: false if the product with same id already exists in the Shop, true – otherwise.
     */
    func addNewProduct(product: Product) -> Bool
    
    /**
     Deletes the product with the specified id from the Shop.
     - Returns: true if the product with same id existed in the Shop, false – otherwise.
     */
    func deleteProduct(id: String) -> Bool
    
    /**
     - Returns: 10 product names containing the specified string.
     If there are several products with the same name, producer's name is added to product's name in the format "<producer> - <product>",
     otherwise returns simply "<product>".
     */
    func listProductsByName(searchString: String) -> Set<String>
    
    /**
     - Returns: 10 product names whose producer contains the specified string,
     result is ordered by producers.
     */
    func listProductsByProducer(searchString: String) -> [String]
}

// TODO: your implementation goes here
class ShopImpl: Shop {
    
    var productStore: [Product] = []
    
    /**
     Adds a new product object to the Shop.
     - Parameter product: product to add to the Shop
     - Returns: false if the product with same id already exists in the Shop, true – otherwise.
     */
    func addNewProduct(product: Product) -> Bool {
        if productStore.contains(where: { $0.id == product.id }) {
            return false
        } else {
            productStore.append(product)
            return true
        }
    }
    
    /**
     Deletes the product with the specified id from the Shop.
     - Returns: true if the product with same id existed in the Shop, false – otherwise.
     */
    func deleteProduct(id: String) -> Bool {
        if productStore.contains(where: { $0.id == id }) {
            productStore.removeAll(where: { $0.id == id })
            return true
        } else {
            return false
        }
    }
    
    /**
     - Returns: 10 product names containing the specified string.
     If there are several products with the same name, producer's name is added to product's name in the format "<producer> - <product>",
     otherwise returns simply "<product>".
     */
    func listProductsByName(searchString: String) -> Set<String> {
        //Array searchByProductName stores first 10 filtered elements of productStore by the name which contains() function takes as a parameter
        let searchProductsByName = productStore.filter { $0.name.contains(searchString) }.prefix(10)
        
        // Created Set which will be shown as a result of current function
        var resultList = Set<String>()
        
        let groupedFilteredProducts = Dictionary(grouping: searchProductsByName, by: \.name)
        
        for (name, products) in groupedFilteredProducts {
            if products.count == 1 {
                resultList.insert(name)
            } else {
                resultList = resultList.union(Set(products.map { $0.producer + " - " + $0.name }))
            }
        }
        
        return resultList
    }
    
    /**
     - Returns: 10 product names whose producer contains the specified string,
     result is ordered by producers.
     */
    func listProductsByProducer(searchString: String) -> [String] {
        let searchProductsByProducer = productStore.filter { $0.producer.contains(searchString) }.prefix(10)
        let searchProductsByProducerCount = searchProductsByProducer.count
        let searchProductsArray = Array(searchProductsByProducer[0 ..< searchProductsByProducerCount])
        let resultNamesSorted = searchProductsArray.sorted(by: { $0.producer < $1.producer }).map { $0.name }
        return resultNamesSorted
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test(lib: ShopImpl())
    }
    
    func test(lib: Shop) {
        assert(!lib.deleteProduct(id: "1"))
        assert(lib.addNewProduct(product: Product(id: "1", name: "1", producer: "Lex")))
        assert(!lib.addNewProduct(product: Product(id: "1", name: "any name because we check id only", producer: "any producer")))
        assert(lib.deleteProduct(id: "1"))
        assert(lib.addNewProduct(product: Product(id: "3", name: "Some Product3", producer: "Some Producer2")))
        assert(lib.addNewProduct(product: Product(id: "4", name: "Some Product1", producer: "Some Producer3")))
        assert(lib.addNewProduct(product: Product(id: "2", name: "Some Product2", producer: "Some Producer2")))
        assert(lib.addNewProduct(product: Product(id: "1", name: "Some Product1", producer: "Some Producer1")))
        assert(lib.addNewProduct(product: Product(id: "5", name: "Other Product5", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "6", name: "Other Product6", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "7", name: "Other Product7", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "8", name: "Other Product8", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "9", name: "Other Product9", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "10", name: "Other Product10", producer: "Other Producer4")))
        assert(lib.addNewProduct(product: Product(id: "11", name: "Other Product11", producer: "Other Producer4")))
        
        var byNames: Set<String> = lib.listProductsByName(searchString: "Product")
        assert(byNames.count == 10)

        byNames = lib.listProductsByName(searchString: "Some Product")
        assert(byNames.count == 4)
        assert(byNames.contains("Some Producer3 - Some Product1"))
        assert(byNames.contains("Some Product2"))
        assert(byNames.contains("Some Product3"))
        assert(!byNames.contains("Some Product1"))
        assert(byNames.contains("Some Producer1 - Some Product1"))

        var byProducer: [String] = lib.listProductsByProducer(searchString: "Producer")
        assert(byProducer.count == 10)

        byProducer = lib.listProductsByProducer(searchString: "Some Producer")
        assert(byProducer.count == 4)
        assert(byProducer[0] == "Some Product1")
        assert(byProducer[1] == "Some Product2" || byProducer[1] == "Some Product3")
        assert(byProducer[2] == "Some Product2" || byProducer[2] == "Some Product3")
        assert(byProducer[3] == "Some Product1")
    }
}


