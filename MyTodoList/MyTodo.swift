import Foundation

class MyTodo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    var todoTitle: String?
    var todoDone: Bool = false
    var index: Int?
    //コンストラクタ
    override init() {
    }
    //デコード処理(取り出す時)
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    //エンコード処理(入れる時)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}

func truecount(array: Array<MyTodo>) -> Int {
    var count = 0
    for x in array {
        if x.todoDone {
            count = count + 1
        }
    }
    return count
}


