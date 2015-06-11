/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */
package appworks.dialogs;

import android.support.v4.app.DialogFragment;
import java.util.ArrayList;

/**
 * Abstract base class for selection dialogs.
 * Developers must subclass appropriately. This is usefull for master-detail and selection scenarios
 * @see DatasourceSelectionDialog
 * @see ValuesSelectionDialog
 * @see ResourceListSelectionDialog
 *
 */
public abstract class SelectionDialog extends DialogFragment {
    public static final String INITIAL_VALUES = "InitialValues";

    protected SelectionListener mSelectionListener;

    protected boolean mMultipleChoice;

    protected boolean mHaveSearch;

    protected String mTitle;

    /**
     * If this dialog will allow multiple choices
     *
     * @param multipleChoice true to enable multiple choices
     */
    public SelectionDialog setMultipleChoice(boolean multipleChoice) {
        this.mMultipleChoice = multipleChoice;
        return this;
    }

    /**
     * Enable a search edit text in this selection dialog.
     *
     * @param hs true to enable searches
     */
    public SelectionDialog setHaveSearch(boolean hs) {
        this.mHaveSearch = hs;
        return this;
    }

    public SelectionDialog setTitle(String title){
        this.mTitle = title;
        return this;
    }


    /**
     * The listener to be called when a selection is done (single or multiple)
     *
     * @param listener an object implementing the {@link SelectionListener} interface.
     */
    public void setSelectionListener(SelectionListener listener) {
        this.mSelectionListener = listener;
    }

    /**
     * interface for dialog dismiss actions
     */
    public interface SelectionListener {

        public void onSelected(ArrayList<String> terms);
    }
}
