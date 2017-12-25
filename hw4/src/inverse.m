function inv = inverse(H)
    H(abs(H)<0.1)=0.1;
    inv=H.^(-1);
end