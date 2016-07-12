import std.stdio;

import std.traits;
import std.datetime;
import std.typecons;

import database.database;
import database.dbdrive.mysql;
import database.dbdrive.impl;
import database.query;

import database.querybuilder;
import std.database.front;

@table("test2")
struct Test
{
	@primarykey()
	int id;

	@column("floatcol")
	float fcol;

	@column("doublecol")
	double dcol;

	@column("datecol")
	Date date;

	@column("datetimecol")
	DateTime dt;

	@column("timecol")
	Time time;

	@column()
	string stringcol;

	@column()
	ubyte[] ubytecol;
}

void main()
{
	enum str = getSetValueFun!(Test)();
	writeln(str);

	enum ley = buildKeyValue!(Test)();
	writeln(ley);

	DataBase dt = DataBase.create("mysql://127.0.0.1/test");
	dt.connect();

	Query!Test quer = new Query!Test(dt);

	Test tmp;
	tmp.id = 16;
	tmp.fcol = 3.5;
	tmp.dcol = 526.58;
	tmp.date = Date(2016,07,12);
	tmp.dt = DateTime(2016,12,15,15,30,20);
	tmp.time = Time(12,10,23,256);
	tmp.stringcol = "hello world";
	tmp.ubytecol = cast(ubyte[])"hellllo".dup;

	//quer.Insert(tmp);

	auto iter = quer.Select();

	while(!iter.empty)
	{
		Test tp = iter.front();
		iter.popFront();
		writeln("the string is : ", tp.stringcol);
		writeln("the ubyte is : ", cast(string)tmp.ubytecol);
	}

	/*tmp.stringcol = "hello hello";
	quer.Update(tmp);

	iter = quer.Select();
	
	while(!iter.empty)
	{
		Test tp = iter.front();
		iter.popFront();
		writeln("the string is : ", tp.stringcol);
	}*/

	quer.Delete(tmp);
}
