package jspdb;

import java.util.ArrayList;

public class MovieInfo {
    private ArrayList<String> totalInfo;
    private ArrayList<String> movieName;
    private ArrayList<String> movieTime;
    private ArrayList<String> movieOpen;
    private ArrayList<String> movieDirector;
    private ArrayList<String> movieActors;
    private ArrayList<String> movieGenre;
    private ArrayList<String> thumbnail;
    private boolean isDirector;
    private boolean isActors;

    public ArrayList<String> getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(ArrayList<String> thumbnail) {
        this.thumbnail = thumbnail;
    }

    public MovieInfo() {
        setTotalInfo(new ArrayList<>());
        setThumbnail(new ArrayList<>());
        setMovieName(new ArrayList<>());
        setMovieGenre(new ArrayList<>());
        setMovieTime(new ArrayList<>());
        setMovieOpen(new ArrayList<>());
        setMovieDirector(new ArrayList<>());
        setMovieActors(new ArrayList<>());
        setDirector(false);
        setActors(false);
    }

    public ArrayList<String> getTotalInfo() {
        return totalInfo;
    }

    public void setTotalInfo(ArrayList<String> totalInfo) {
        this.totalInfo = totalInfo;
    }

    public ArrayList<String> getMovieName() {
        return movieName;
    }

    public void setMovieName(ArrayList<String> movieName) {
        this.movieName = movieName;
    }

    public ArrayList<String> getMovieTime() {
        return movieTime;
    }

    public void setMovieTime(ArrayList<String> movieTime) {
        this.movieTime = movieTime;
    }

    public ArrayList<String> getMovieOpen() {
        return movieOpen;
    }

    public void setMovieOpen(ArrayList<String> movieOpen) {
        this.movieOpen = movieOpen;
    }

    public ArrayList<String> getMovieDirector() {
        return movieDirector;
    }

    public void setMovieDirector(ArrayList<String> movieDirector) {
        this.movieDirector = movieDirector;
    }

    public ArrayList<String> getMovieActors() {
        return movieActors;
    }

    public void setMovieActors(ArrayList<String> movieActors) {
        this.movieActors = movieActors;
    }

    public ArrayList<String> getMovieGenre() {
        return movieGenre;
    }

    public void setMovieGenre(ArrayList<String> movieGenre) {
        this.movieGenre = movieGenre;
    }

    public boolean isDirector() {
        return isDirector;
    }

    public void setDirector(boolean director) {
        isDirector = director;
    }

    public boolean isActors() {
        return isActors;
    }

    public void setActors(boolean actors) {
        isActors = actors;
    }
}
