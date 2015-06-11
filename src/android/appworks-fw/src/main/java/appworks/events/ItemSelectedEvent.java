/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

package appworks.events;

/**
 * otto event
 */
public class ItemSelectedEvent {

    public int position;

    public Object target;

    public String tag;

    public ItemSelectedEvent(int position, String tag, Object target) {
        this.position = position;
        this.target = target;
        this.tag = tag;
    }

    @Override
    public String toString() {
        return new StringBuilder("ItemSelectedEvent: ")
                .append("(position = ")
                .append(position)
                .append(", obj = ")
                .append(target.toString())
                .append(")")
                .toString();
    }
}
