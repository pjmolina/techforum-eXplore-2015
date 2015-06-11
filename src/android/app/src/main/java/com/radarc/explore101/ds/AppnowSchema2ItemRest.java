/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package com.radarc.explore101.ds;
import java.util.List;
 
import retrofit.Callback;
import retrofit.http.GET;
import retrofit.http.Path;
import retrofit.http.Query;

public interface AppnowSchema2ItemRest{

    @GET("/a2cf4995-73dc-4bb7-8d9c-af017d125e42")
    public void getAll(Callback<AppnowSchema2Item.List> cb);

    @GET("/a2cf4995-73dc-4bb7-8d9c-af017d125e42")
    public void search(
            @Query("searchText") String searchText,
            @Query("sortingColumn") String sortingColumn,
            @Query("sortAscending") boolean sortAscending,
            @Query("offset") int pageIndex,
            @Query("blockSize") int blockSize,
            @Query("condition") String condition,
            Callback<AppnowSchema2Item.List> cb);

    @GET("/a2cf4995-73dc-4bb7-8d9c-af017d125e42/{rowId}")
    public void getItem(String rowId, Callback<AppnowSchema2Item> cb);

    @GET("/a2cf4995-73dc-4bb7-8d9c-af017d125e42/distinct/{colName}")
    public void getDistinctValues(@Path("colName") String colName, Callback<List<String>> cb);
}


