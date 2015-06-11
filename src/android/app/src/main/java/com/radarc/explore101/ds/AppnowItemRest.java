/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package com.radarc.explore101.ds;
import java.util.List;
 
import retrofit.Callback;
import retrofit.http.GET;
import retrofit.http.Path;
import retrofit.http.Query;

public interface AppnowItemRest{

    @GET("/dc9d64ab-614b-444a-9374-bfb0b14892d4")
    public void getAll(Callback<AppnowItem.List> cb);

    @GET("/dc9d64ab-614b-444a-9374-bfb0b14892d4")
    public void search(
            @Query("searchText") String searchText,
            @Query("sortingColumn") String sortingColumn,
            @Query("sortAscending") boolean sortAscending,
            @Query("offset") int pageIndex,
            @Query("blockSize") int blockSize,
            @Query("condition") String condition,
            Callback<AppnowItem.List> cb);

    @GET("/dc9d64ab-614b-444a-9374-bfb0b14892d4/{rowId}")
    public void getItem(String rowId, Callback<AppnowItem> cb);

    @GET("/dc9d64ab-614b-444a-9374-bfb0b14892d4/distinct/{colName}")
    public void getDistinctValues(@Path("colName") String colName, Callback<List<String>> cb);
}


