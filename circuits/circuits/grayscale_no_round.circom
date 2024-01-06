pragma circom 2.1.0;


template GrayscaleChecker(hOrig, wOrig) {
    signal input orig_img[hOrig][wOrig][3];
    signal input gray_img[hOrig][wOrig];
    signal input negativeRemainder[hOrig][wOrig];    
    signal input positiveRemainder[hOrig][wOrig];

    signal output n_check;

    for (var i = 0; i < hOrig; i++) {
        for (var j = 0; j < wOrig; j++) {
            30 * orig_img[i][j][0] + 59 * orig_img[i][j][1] + 11 * orig_img[i][j][2] === 100 * gray_img[i][j] - negativeRemainder[i][j] + positiveRemainder[i][j];
        }
    }

     n_check <== hOrig * wOrig;
}

component main = GrayscaleChecker(100, 100);
