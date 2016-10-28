package jspdb;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;

public class DB {
    Statement st;
    ResultSet rs;
    Connection c;

    public Statement getSt() {
        return st;
    }

    public ResultSet getRs() {
        return rs;
    }

    public DB() {
        String url = "jdbc:oracle:thin:@localhost:1521:orcl";
        String id = "system";
        String pw = "11111";
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver 호출 실패.");
        }
        try {
            c = DriverManager.getConnection(url, id, pw);
            st = c.createStatement();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    void createMovieInfoTable() {
        String str = "create table MovieInfo(" +
                "id number, " +
                "name varchar2(60), " +
                "genre varchar2(50)," +
                "time varchar2(7)," +
                "open varchar2(12)," +
                "director varchar2(40)," +
                "actors varchar2(200)," +
                "thumbAddr varchar2(200))";
        String str2 = "alter table MovieInfo "+
                "add constraint mv_id_pk primary key(id)";
        String str3 = "create sequence insertMovie increment by 1 start with 10000";
        excuteQ(str);
        excuteQ(str2);
        excuteQ(str3);
        System.out.println("**MovieInfo테이블이 생성되었습니다.**");
    }

    void createMemberInfoTable() {
        String str = "create table MemberInfo(" +
                "membership number," +
                "memberid varchar2(20) unique," +
                "memberpw varchar2(20)," +
                "memberName varchar2(15)," +
                "nickname varchar2(15) unique)";
        String str2 =  "alter table MemberInfo "+
                "add constraint mb_membership_pk primary key(membership)";
        String str3 = "create sequence insertMember increment by 1 start with 10000";
        excuteQ(str);
        excuteQ(str2);
        excuteQ(str3);
        System.out.println("**MemberInfo테이블이 생성되었습니다.**");
    }

    void createFavoriteInfoTable() {
        String str = "create table FavoriteInfo(" +
                "Memberid varchar2(20)," +
                "MovieID number)";
        String str2 = "alter table FavoriteInfo "+
                "add CONSTRAINT fv_memberid_fk "+
                "FOREIGN KEY (Memberid) "+
                "REFERENCES MemberInfo(MEMBERID) "+
                "ON DELETE CASCADE";
        String str3 = "alter table FavoriteInfo "+
                "add CONSTRAINT fv_movieid_fi_fk "+
                "FOREIGN KEY (MovieId) "+
                "REFERENCES MovieInfo(id) "+
                "ON DELETE CASCADE";
        excuteQ(str);
        excuteQ(str2);
        excuteQ(str3);
        System.out.println("**FavoriteInfo테이블이 생성되었습니다.**");
    }

    void deleteMovieInfoTable() {
        String str = "drop sequence insertMovie";
        String str2 = "drop table movieinfo";
        excuteQ(str);
        excuteQ(str2);
        System.out.println("**MovieInfo테이블이 제거되었습니다.**");
    }

    void deleteMemberInfoTable() {
        String str = "drop sequence insertMember";
        String str2 = "drop table MemberInfo";
        excuteQ(str);
        excuteQ(str2);
        System.out.println("**MemberInfo테이블이 제거되었습니다.**");
    }

    void deleteFavoriteInfoTable() {
        String str = "drop table FavoriteInfo";
        excuteQ(str);
        System.out.println("**FavoriteInfo테이블이 제거되었습니다.**");
    }

    public void excuteQ(String str) {
        try {
            rs = st.executeQuery(str);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void excuteU(String str) {
        try {
            st.executeUpdate(str);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void putMovie(String name, String genre, String time, String open, String director, String actors, String thumbAddr) {
        String str = "insert into MovieInfo(id, name, genre, time, open, director, actors, thumbAddr) " +
                "values(insertMovie.NEXTVAL, '" + name + "', '" + genre + "', '" + time + "', '" + open + "', '" + director + "', '" + actors + "', '" + thumbAddr + "')";
        excuteU(str);
    }

    public void putMember(String memberid, String memberpw, String memberName, String nickname) {
        String str = "insert into MemberInfo(membership, memberid, memberpw, memberName, nickname) " +
                "values(insertMember.NEXTVAL, '" + memberid + "', '" + memberpw + "', '" + memberName + "', '" + nickname + "')";
        excuteU(str);
    }

    public void getMember(String memberid) {
        String str = "select * from MemberInfo where memberid='" + memberid + "'";
        excuteQ(str);
    }

    public String[] login(String logid, String logpw) {
        String[] info = new String[2];
        String query = "select memberid, memberpw from MemberInfo where memberid='" + logid + "' and memberpw='" + logpw + "' ";
        try {
            rs = st.executeQuery(query);
            while (rs.next()) {
                for (int i = 0; i < 2; i++)
                    info[i] = rs.getString(i + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return info;
    }

    public String[] findMemberID(String fmemberName, String fnickname) {
        String[] info = new String[3];
        String query = "select memberid, memberName, nickname from MemberInfo where memberName='" + fmemberName + "' and nickname='" + fnickname + "' ";
        try {
            rs = st.executeQuery(query);
            while (rs.next()) {
                for (int i = 0; i < 3; i++)
                    info[i] = rs.getString(i + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return info;
    }

    public String[] findMemberPW(String fmemberName, String fmemberid) {
        String[] info = new String[3];
        String query = "select memberpw, memberName, memberid from MemberInfo where memberName='" + fmemberName + "' and memberid='" + fmemberid + "' ";
        try {
            rs = st.executeQuery(query);
            while (rs.next()) {
                for (int i = 0; i < 3; i++)
                    info[i] = rs.getString(i + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return info;
    }

    public ArrayList getAllMovieByCondition(String t1) {
        ArrayList<String[]> oper = new ArrayList<>();
        String str = "select * from MovieInfo";
        if (!t1.equals(""))
            str += " where " + t1 + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                String[] info = new String[8];
                for (int i = 0; i < 8; i++) {
                    info[i] = rs.getString(i + 1);
                }
                oper.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return oper;
    }

    public ArrayList getFvList(String logId) {
        ArrayList<String[]> all = new ArrayList<>();
        ArrayList<Integer> idList = new ArrayList<>();
        String str = "select movieid from FavoriteInfo where memberid = '" + logId + "' order by movieid";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                idList.add(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        for (int i = 0; i < idList.size(); i++) {
            try {
                ResultSet temp = st.executeQuery("select name, open from MovieInfo where id=" + idList.get(i) + " order by id");
                while (temp.next()) {
                    String[] oper = new String[2];
                    oper[0] = temp.getString(1);
                    oper[1] = temp.getString(2);
                    all.add(oper);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return all;
    }

    public void putFv(String logId, int movieId) {
        String str = "insert into FavoriteInfo(memberid, movieid) values('" + logId + "', " + movieId + ")";
        excuteU(str);
    }

    public void rmFv(String logid, int movieid){
        String str = "delete from FavoriteInfo where memberid='"+logid+"' and movieid="+movieid;
        excuteU(str);
    }

    public LinkedHashMap getMovie(String t1, String condition) {
        LinkedHashMap<String, String> oper = new LinkedHashMap<>();
        String str = "select " + t1 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next())
                oper.put(t1, rs.getString(1));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return oper;
    }

    public ArrayList getMovie(String t1, String t2, String condition) {
        ArrayList<LinkedHashMap<String, String>> all = new ArrayList<>();
        String str = "select " + t1 + "," + t2 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                LinkedHashMap<String, String> oper = new LinkedHashMap<>();
                oper.put(rs.getString(1), rs.getString(2));
                all.add(oper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return all;
    }

    public ArrayList getMovie(String t1, String t2, String t3, String condition) {
        ArrayList<LinkedHashMap<String, String>> all = new ArrayList<>();
        String str = "select " + t1 + "," + t2 + "," + t3 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            System.out.println(str);
            rs = st.executeQuery(str);
            while (rs.next()) {
                LinkedHashMap<String, String> oper = new LinkedHashMap<>();
                oper.put(t1, rs.getString(1));
                oper.put(t2, rs.getString(2));
                oper.put(t3, rs.getString(3));
                all.add(oper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return all;
    }

    public ArrayList getMovie(String t1, String t2, String t3, String t4, String condition) {
        ArrayList<LinkedHashMap<String, String>> all = new ArrayList<>();
        String str = "select " + t1 + "," + t2 + "," + t3 + "," + t4 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                LinkedHashMap<String, String> oper = new LinkedHashMap<>();
                oper.put(t1, rs.getString(1));
                oper.put(t2, rs.getString(2));
                oper.put(t3, rs.getString(3));
                oper.put(t4, rs.getString(4));
                all.add(oper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return all;
    }

    public ArrayList getMovie(String t1, String t2, String t3, String t4, String t5, String condition) {
        ArrayList<LinkedHashMap<String, String>> all = new ArrayList<>();
        String str = "select " + t1 + "," + t2 + "," + t3 + "," + t4 + "," + t5 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                LinkedHashMap<String, String> oper = new LinkedHashMap<>();
                oper.put(t1, rs.getString(1));
                oper.put(t2, rs.getString(2));
                oper.put(t3, rs.getString(3));
                oper.put(t4, rs.getString(4));
                oper.put(t5, rs.getString(5));
                all.add(oper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return all;
    }

    public ArrayList getMovie(String t1, String t2, String t3, String t4, String t5, String t6, String condition) {
        ArrayList<LinkedHashMap<String, String>> all = new ArrayList<>();
        String str = "select " + t1 + "," + t2 + "," + t3 + "," + t4 + "," + t5 + "," + t6 + " from movieinfo";
        if (!condition.equals(""))
            str += " where " + condition + " order by id";
        else str += " order by id";
        try {
            rs = st.executeQuery(str);
            while (rs.next()) {
                LinkedHashMap<String, String> oper = new LinkedHashMap<>();
                oper.put(t1, rs.getString(1));
                oper.put(t2, rs.getString(2));
                oper.put(t3, rs.getString(3));
                oper.put(t4, rs.getString(4));
                oper.put(t5, rs.getString(5));
                oper.put(t5, rs.getString(6));
                all.add(oper);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return all;
    }

    public void commit() {
        try {
            rs = st.executeQuery("commit");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}