package jspdb;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

public class parseMovieInfo {
	static DB db;
	static MovieInfo mi;
	static Document doc;

	public static void main(String args[]) throws Exception {
		HttpClient httpClient = new DefaultHttpClient();
		HttpGet httpGet = new HttpGet("http://movie.naver.com/movie/running/premovie.nhn");
		
		httpClient.execute(httpGet, new BasicResponseHandler() {
			@Override
			public String handleResponse(HttpResponse response) throws IOException {
				String res = new String(super.handleResponse(response));
				doc = Jsoup.parse(res);
				return res;
			}
		});
		
		Elements names = doc.select("dt.tit a");
		Elements times = doc.select("dl.info_txt1 dd");
		Elements thumbAddr = doc.select("ul.lst_detail_t1 img");

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

		db = new DB();
		mi = new MovieInfo();
		
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
			} else if (!str.contains("|")) {
				if (str.contains("분")) {
					str = str.replace("분", "").trim();
					mi.getMovieGenre().add("unknown");
					categorizeByTime(str, mi.getMovieTime());
					categorizeByOpen("unknown", mi.getMovieOpen());
					mi.setDirector(true);
				} else if (str.contains("개봉")) {
					str = str.replace("개봉", "").trim();
					mi.getMovieGenre().add("unknown");
					mi.getMovieTime().add("unknown");
					mi.getMovieOpen().add(str.replace("개봉", ""));
					mi.setDirector(true);
				} else {
					mi.getMovieGenre().add(str);
					mi.getMovieTime().add("unknown");
					mi.getMovieOpen().add("unknown");
					mi.setDirector(true);
				}
			}
		}
		deleteDBTable();
		createDBTable();
		parseDataToDB(db);
	}

	private static void categorizeSynopsis(String str) {
		StringTokenizer st = new StringTokenizer(str, "|");
		int tokenCount = st.countTokens();
		while (st.hasMoreTokens()) {
			String word = st.nextToken().trim();
			if ((tokenCount == 2) && str.contains("분") && str.contains("개봉")) {
				mi.getMovieGenre().add("unknown");
				categorizeByTime(word, mi.getMovieTime());
				word = st.nextToken().trim();
				categorizeByOpen(word, mi.getMovieOpen());
				mi.setDirector(true);
			} else if ((tokenCount == 2) && !str.contains("분") && str.contains("개봉")) {
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
		word = word.replace("분", "").trim();
		movieTime.add(word);
	}

	private static void categorizeByOpen(String word, ArrayList movieOpen) {
		word = word.replace("개봉", "").trim();
		movieOpen.add(word);
	}

	private static void parseDataToDB(DB db) {
		for (int i = 0; i < mi.getMovieName().size() - 1; i++) {
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
