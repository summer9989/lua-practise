local mysql = require "resty.mysql"
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end

local ok, err, errcode, sqlstate = db:connect {
    host = "10.10.50.107",
    port = 3306,
    database = "push",
    user = "root",
    password = "yunnex6j7",
    charset = "utf8",
    max_packet_size = 1024 * 1024,
}

if not ok then
    ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
    return
end

ngx.say("connected to mysql.")

local res, err, errcode, sqlstate = db:query("drop table if exists cats")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

res, err, errcode, sqlstate = db:query("create table cats "
        .. "(id serial primary key, "
        .. "name varchar(5))")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

ngx.say("table cats created.")

res, err, errcode, sqlstate = db:query("insert into cats (name) "
        .. "values (\'Bob\'),(\'\'),(null)")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

ngx.say(res.affected_rows, " rows inserted into table cats ",
        "(last insert id: ", res.insert_id, ")")

-- run a select query, expected about 10 rows in
-- the result set:
res, err, errcode, sqlstate = db:query("select * from cats order by id asc", 10)
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

local ok, err = db:close()
if not ok then
    ngx.say("failed to close: ", err)
    return
end
