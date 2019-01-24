module model.LoginInfo;

import hunt.entity;
import model.UserInfo;
import model.AppInfo;



@Table("logininfo")
class LoginInfo : Model
{
    mixin MakeModel;

    @AutoIncrement @PrimaryKey 
    int id;

    int create_time;
    int update_time;
    
    // int uid;
    @JoinColumn("uid")
    UserInfo uinfo;

    @JoinColumn("appid")
    AppInfo app;
}