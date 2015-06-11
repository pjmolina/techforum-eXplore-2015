/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package com.radarc.explore101.ds;
import java.util.List;
 
import retrofit.Callback;
import retrofit.http.GET;
import retrofit.http.Path;
import retrofit.http.Query;

public interface AppnowSchema3ItemRest{

    @GET("/364f27d4-8618-4041-925a-7c3da527af22")
    public void getAll(Callback<AppnowSchema3Item.List> cb);

    @GET("/364f27d4-8618-4041-925a-7c3da527af22")
    public void search(
            @Query("searchText") String searchText,
            @Query("sortingColumn") String sortingColumn,
            @Query("sortAscending") boolean sortAscending,
            @Query("offset") int pageIndex,
            @Query("blockSize") int blockSize,
            @Query("condition") String condition,
            Callback<AppnowSchema3Item.List> cb);

    @GET("/364f27d4-8618-4041-925a-7c3da527af22/{rowId}")
    public void getItem(String rowId, Callback<AppnowSchema3Item> cb);

    @GET("/364f27d4-8618-4041-925a-7c3da527af22/distinct/{colName}")
    public void getDistinctValues(@Path("colName") String colName, Callback<List<String>> cb);
}


