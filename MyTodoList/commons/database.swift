import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var todoid = randomString(length: 10)
    @objc dynamic var title = ""
    @objc dynamic var todoDone = false
    @objc dynamic var donetime = 0 //何秒タスクを完了したか
    @objc dynamic var dotime = 0 //目標時間
    @objc dynamic var date: Date? = nil
    @objc dynamic var datestring: String = "指定なし"
    @objc dynamic var InFlag = false
    @objc dynamic var base = ""
    let calendars = List<Calendar24>()
    override static func primaryKey() -> String? {
        return "todoid"
    }
    var rate: Int { //タスクの達成率
        let double_donetime :Double = Double(donetime)
        let double_dotime :Double = Double(dotime)
        let ans: Int = Int((double_donetime/double_dotime)*100.0)
        return ans
    }
    var dotime_string: String { //時間のフォーマッター
        var ans: String = ""
        ans = String(format: "%02dh %02dm", (dotime / 3600), (dotime / 60) % 60)
        return ans
    }
}

class Calendar24: Object {  //24時間カレンダーに追加されているタスクの情報
    @objc dynamic var calendarid = randomString(length: 10) //ID
    @objc dynamic var todoDone = false //タスクをやったか←いる？
    @objc dynamic var start = Date() //タスクの開始時間
    @objc dynamic var taskflag = true //予定かタスクか←聞きたい？
    @objc dynamic var default_allday = false //終日
    @objc dynamic var c_dotime = 0 //タスクの時間幅
    @objc dynamic var end = Date() //←いらなくね
    let todo = LinkingObjects(fromType: Todo.self, property: "calendars")
    override static func primaryKey() -> String? {
        return "calendarid"
    }
//    @objc dynamic var end: Date {
//        let day = start
//        let end = Calendar.current.date(byAdding: .second, value: c_dotime, to: day)!
//        return end
//    }
}


//class TodoItem: Object {
//  @objc dynamic var title = ""
//}

func daylist7() -> [String]{
    var days:[String] = []
    let date:Date = Date()
    let f = DateFormatter()
    f.timeStyle = .none
    f.dateStyle = .full
    f.locale = Locale(identifier: "ja_JP")
    days.append("指定なし")
    for i in 0...6 {
        let modifiedDate = Calendar.current.date(byAdding: .day, value: i, to: date)!
        days.append(f.string(from: modifiedDate))
    }
    return days
}


