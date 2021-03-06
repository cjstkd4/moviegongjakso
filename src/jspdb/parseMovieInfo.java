package jspdb;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.sql.SQLException;
import java.util.*;

public class parseMovieInfo {
    static DB db;
    static MovieInfo mi;

    public static void main(String args[]) throws Exception {
        Document doc = Jsoup.connect("http://movie.naver.com/movie/running/premovie.nhn").get();
        Elements names = doc.select("dt.tit a");
        Elements times = doc.select("dl.info_txt1 dd");
        Elements thumbAddr = doc.select("ul.lst_detail_t1 img");

        db = new DB();
        mi = new MovieInfo();
        for (Element e : names) {
            ArrayList<String> movieName = mi.getMovieName();
            movieName.add(e.text());
            mi.setMovieName(movieName);
        }

        for (Element e : times) {
            ArrayList<String> totalInfo = mi.getTotalInfo();
            totalInfo.add(e.text());
            mi.setTotalInfo(totalInfo);
        }

        for (Element e : thumbAddr) {
            ArrayList<String> thumbList = mi.getThumbnail();
            String s = e.toString();
            StringTokenizer st = new StringTokenizer(s, "\"");
            st.nextToken();
            String stk = st.nextToken();
            thumbList.add(stk);
            mi.setThumbnail(thumbList);
        }

        for (int i = 0; i < mi.getTotalInfo().size(); i++) {
            String str = mi.getTotalInfo().get(i);
            if (str.contains("|") && !mi.isActors() && !mi.isDirector()) {
                categorizeSynopsis(str);
            } else if (mi.isDirector() && !mi.isActors()) {
                mi.getMovieDirector().add(str);
                mi.setDirector(false);
                mi.setActors(true);
            } else if (!mi.isDirector() && mi.isActors()) {
                if (str.contains("|")) {
                    mi.getMovieActors().add("unknown");
                    i--;
                } else {
                    mi.getMovieActors().add(str);
                }
                mi.setActors(false);
            }
        }
        deleteDBTable();
        createDBTable();
        parseDataToDB(db);
    }

    private static void deleteDBTable() {
        db.deleteFavoriteInfoTable();
        db.deleteMovieInfoTable();
        db.deleteMemberInfoTable();
    }

    private static void createDBTable() {
        db.createMovieInfoTable();
        db.createMemberInfoTable();
        db.createFavoriteInfoTable();
    }

    private static void categorizeByTime(String word, ArrayList movieTime) {
        word = word.replace("��", "").trim();
        movieTime.add(word);
    }

    private static void categorizeByOpen(String word, ArrayList movieOpen) {
        word = word.replace("����", "").trim();
        movieOpen.add(word);
    }

    private static void categorizeSynopsis(String str) {
        StringTokenizer st = new StringTokenizer(str, "|");
        int tokenCount = st.countTokens();
        while (st.hasMoreTokens()) {
            String word = st.nextToken().trim();
            if ((tokenCount == 2) && str.contains("��") && str.contains("����")) {
                mi.getMovieGenre().add("unknown");
                categorizeByTime(word, mi.getMovieTime());
                word = st.nextToken().trim();
                categorizeByOpen(word, mi.getMovieOpen());
                mi.setDirector(true);
            } else if ((tokenCount == 2) && !str.contains("��") && str.contains("����")) {
                mi.getMovieGenre().add(word);
                mi.getMovieTime().add("unknown");
                word = st.nextToken().trim();
                categorizeByOpen(word, mi.getMovieOpen());
                mi.setDirector(true);
            } else if (tokenCount == 3) {
                mi.getMovieGenre().add(word);
                word = st.nextToken().trim();
                categorizeByTime(word, mi.getMovieTime());
                word = st.nextToken().trim();
                categorizeByOpen(word, mi.getMovieOpen());
                mi.setDirector(true);
            }
        }
    }

    private static void parseDataToDB(DB db) {
        for (int i = 0; i < mi.getMovieName().size(); i++) {
            String name = mi.getMovieName().get(i);
            String genre = mi.getMovieGenre().get(i);
            String time = mi.getMovieTime().get(i);
            String open = mi.getMovieOpen().get(i);
            String director = mi.getMovieDirector().get(i);
            String actors = mi.getMovieActors().get(i);
            String thumbnail = mi.getThumbnail().get(i);
            db.putMovie(name, genre, time, open, director, actors, thumbnail);
        }
        db.commit();
    }

    private void closeDB(DB db) {
        try {
            db.c.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
