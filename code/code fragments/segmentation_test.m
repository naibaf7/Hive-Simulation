function segmentation_test()
    A = zeros(500,500);
    A(200:250,100:300) = 1;
    A(50:100,70:100) = 2;
    imagesc(logical(A))
    pause(5);
    BW2 = bwselect(logical(A),150+101,200);
    imagesc(BW2)

end

