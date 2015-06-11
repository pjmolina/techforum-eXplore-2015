/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import appworks.ds.filter.Filter;

public class SearchOptions {

    private String searchText;

    private String sortColumn;

    private Comparator sortComparator;

    private boolean sortAscending;

    private List<Filter> filters = new ArrayList<Filter>();

    public SearchOptions() {
    }

    public SearchOptions(String searchText, String sortColumn, Comparator sortComparator,
            boolean sortAscending) {
        this.searchText = searchText;
        this.sortColumn = sortColumn;
        this.sortComparator = sortComparator;
        this.sortAscending = sortAscending;
    }

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public Comparator getSortComparator() {
        return sortComparator;
    }

    public void setSortComparator(Comparator sortComparator) {
        this.sortComparator = sortComparator;
    }

    public String getSortColumn() {
        return sortColumn;
    }

    public void setSortColumn(String sortColumn) {
        this.sortColumn = sortColumn;
    }

    public boolean isSortAscending() {
        return sortAscending;
    }

    public void setSortAscending(boolean sortAscending) {
        this.sortAscending = sortAscending;
    }

    public void addFilter(Filter filter) {
        if (this.filters == null) {
            this.filters = new ArrayList<Filter>();
        }

        this.filters.add(filter);
    }

    public List<Filter> getFilters() {
        return this.filters;
    }

    public void setFilters(List<Filter> filters) {
        this.filters = filters;
    }
}