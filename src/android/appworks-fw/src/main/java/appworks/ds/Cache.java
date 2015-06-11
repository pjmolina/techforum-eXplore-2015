/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.ds;

/**
 * This interface mark the datasource as cacheable
 */
public interface Cache {

    public void invalidate();
}
