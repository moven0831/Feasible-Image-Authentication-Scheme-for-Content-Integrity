pragma circom 2.1.0;


template Resize(hOrig, wOrig, hNew, wNew) {
    signal input orig_img[hOrig][wOrig];
    signal input new_img[hNew][wNew];

	signal output n_check;

    for (var i = 0; i < hNew; i++) {
		for (var j = 0; j < wNew; j++) {
			var x_l = (wOrig - 1) * j / (wNew - 1);
			var y_l = (hOrig - 1) * i / (hNew - 1);

			var x_h = x_l * (wNew - 1) == (wOrig - 1) * j ? x_l : x_l + 1;
			var y_h = y_l * (hNew - 1) == (hOrig - 1) * i ? y_l : y_l + 1;

			var xRatioWeighted = ((wOrig - 1) * j) - (wNew - 1)*x_l;
			var yRatioWeighted = ((hOrig - 1) * i) - (hNew - 1)*y_l;

			var denom = (wNew - 1) * (hNew - 1);
			var sum = orig_img[y_l][x_l] * (wNew - 1 - xRatioWeighted) * (hNew - 1 - yRatioWeighted)
				+ orig_img[y_l][x_h] * xRatioWeighted * (hNew - 1 - yRatioWeighted)
				+ orig_img[y_h][x_l] * yRatioWeighted * (wNew - 1 - xRatioWeighted)
				+ orig_img[y_h][x_h] * xRatioWeighted * yRatioWeighted;

			new_img[i][j] * denom === sum;
		}		
	}
	n_check <== 1;
}

component main = Resize(3, 6, 3, 2);
