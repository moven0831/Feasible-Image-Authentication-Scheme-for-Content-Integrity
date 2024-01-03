pragma circom 2.1.0;


template Crop(hOrig, wOrig, hNew, wNew, hStartNew, wStartNew) {
    signal input orig_img[hOrig][wOrig][3];
    signal input new_img[hNew][wNew][3];

    signal output n_check;

    for (var i = 0; i <  hNew; i++) {
		for (var j = 0; j < wNew; j++) {
			for (var k = 0; k < 3; k++) {
				new_img[i][j][k] === orig_img[hStartNew + i][wStartNew + j][k];	
			}
		}
	}
	n_check <== 1;
}

// TODO: make new_img a public input
component main = Crop(2048, 1365, 100, 100, 500, 500);
