/*
 * Copyright (c) 2015.
 * This code is part of http://www.radarconline.com , the Bright Enterprise App Builder.
 * Created by Icinetic S.L.
 */

/*
 * This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
 */

package appworks.util;

/**
 * Numeric utility methods
 */
public class MathUtils {

    /**
     * Calculate the order of magnitude of a number (float by now)
     *
     * @param range the input string
     * @return the resulting order
     */
    public static int getOrderOfMagnitude(int range) {

        int aux = range;
        int mag = 1;
        while (aux > 10) {
            mag = mag * 10;
            aux = aux / 10;
        }
        ;
        return mag;
    }


}
