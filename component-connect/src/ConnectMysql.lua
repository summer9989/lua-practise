require("luasql.mysql")

--创建环境对象
env = luasql.mysql()

--连接数据库
connect = env:connect("push", "root", "yunnex6j7", "10.10.50.107", 3306)

cursor = connect:execute("select * from msg_client limit 10")

row = cursor:fetch({}, "test")

file = io.open("client.txt", "w+")

while row do
    record = string.format("%s\n", row.id)
    print(record)
    file:write(record)
    row = cursor:fetch(row, "a")
end

file:close()  --关闭文件对象
connect:close()  --关闭数据库连接
env:close()   --关闭数据库环境
